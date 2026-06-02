package rmsNorm

import spinal.core._
import spinal.lib._
import util.{Fp32Epsilon, Fp32ScaleDown}

import scala.language.postfixOps

/**
 * RMSNorm core for Llama-style pre-norm: collect 2048 FP16 activations + gamma,
 * compute rsqrt(mean(x^2)+eps), emit normalized FP16 vector.
 *
 * All floating ops are injected (see [[util.RmsNormAlteraIp]] / [[util.RmsNormAlteraIpSim]]).
 */
class RmsNormCore(
  val dim: Int,
  toFp32_func: Flow[Bits] => Flow[Bits],
  toFp16_func: Flow[Bits] => Flow[Bits],
  mul_func: (Flow[Bits], Flow[Bits]) => Flow[Bits],
  mul_func_block: (Stream[Bits], Stream[Bits]) => Stream[Bits],
  acc_func: Flow[Fragment[Bits]] => Flow[Fragment[Bits]],
  add_func: (Flow[Bits], Flow[Bits]) => Flow[Bits],
  rsqrt_func: Flow[Bits] => Flow[Bits]
) extends Component {

  val io = new Bundle {
    val dataIn   = slave(Stream(Bits(16 bits)))
    val weightIn = slave(Stream(Bits(16 bits)))
    val dataOut  = master(Stream(Bits(16 bits)))
    val busy     = out Bool()
  }

  val addrWidth  = log2Up(dim)
  val cntWidth   = log2Up(dim + 1)
  val scaleShift = log2Up(dim)

  object State extends SpinalEnum {
    val IDLE, COLLECT, WAIT_RSQRT, EMIT = newElement()
  }
  val state = RegInit(State.IDLE)

  val inputMem  = Mem(Bits(16 bits), wordCount = dim)
  val weightMem = Mem(Bits(16 bits), wordCount = dim)

  val dataCnt   = Reg(UInt(cntWidth bits)) init (0)
  val weightCnt = Reg(UInt(cntWidth bits)) init (0)

  val dataDone   = dataCnt === U(dim, cntWidth bits)
  val weightDone = weightCnt === U(dim, cntWidth bits)

  // -------------------------------------------------------------------------
  // Collect path: FP16 in -> buffer, square-sum accumulator
  // -------------------------------------------------------------------------
  val collectFire = io.dataIn.fire
  when(collectFire) {
    inputMem.write(dataCnt.resize(addrWidth), io.dataIn.payload)
    dataCnt := dataCnt + 1
  }

  when(io.weightIn.fire) {
    weightMem.write(weightCnt.resize(addrWidth), io.weightIn.payload)
    weightCnt := weightCnt + 1
  }

  val collectFlow = Flow(Bits(16 bits))
  collectFlow.valid   := io.dataIn.fire
  collectFlow.payload := io.dataIn.payload

  val toBeNormFp32 = toFp32_func(collectFlow)
  val squared      = mul_func(toBeNormFp32, toBeNormFp32)

  val sqrCnt    = Reg(UInt(addrWidth bits)) init (0)
  val sqrLast   = sqrCnt === dim - 1
  when(squared.valid) {
    sqrCnt := sqrCnt + 1
    when(sqrLast) {
      sqrCnt := 0
    }
  }

  val accIn = Flow(Fragment(Bits(32 bits)))
  accIn.valid   := squared.valid
  accIn.fragment := squared.payload
  accIn.last    := sqrLast

  val accOut = acc_func(accIn)

  val accDone = accOut.valid && accOut.last

  val meanSquare = Fp32ScaleDown(accOut.fragment, scaleShift)

  val addA = Flow(Bits(32 bits))
  val addB = Flow(Bits(32 bits))
  addA.valid   := accDone
  addA.payload := meanSquare
  addB.valid   := accDone
  addB.payload := Fp32Epsilon.bits

  val meanWithEps = add_func(addA, addB)
  val rsqrtOut    = rsqrt_func(meanWithEps)

  val scaleLockValid = RegInit(False)
  val scaleLock      = Reg(Bits(32 bits))
  when(rsqrtOut.valid) {
    scaleLockValid := True
    scaleLock      := rsqrtOut.payload
  }

  // -------------------------------------------------------------------------
  // Emit path
  // -------------------------------------------------------------------------
  val emitIdx     = Reg(UInt(addrWidth bits)) init (0)
  val emitActive  = state === State.EMIT
  val emitLast    = emitIdx === dim - 1
  val launchEmit  = RegInit(False)

  when(state === State.WAIT_RSQRT && scaleLockValid) {
    launchEmit := True
    emitIdx    := 0
  }
  when(io.dataOut.fire && emitActive && !emitLast) {
    launchEmit := True
  }

  val inputRaw = Stream(Bits(16 bits))
  inputRaw.valid   := emitActive && launchEmit
  inputRaw.payload := inputMem.readAsync(emitIdx)

  val weightRaw = Stream(Bits(16 bits))
  weightRaw.valid   := emitActive && launchEmit
  weightRaw.payload := weightMem.readAsync(emitIdx)

  val inputFp32 = RmsNormStreamUtil.toFp32Stream(inputRaw, toFp32_func)
  val gammaFp32 = RmsNormStreamUtil.toFp32Stream(weightRaw, toFp32_func)

  when(inputFp32.fire) {
    launchEmit := False
  }

  val scaledOut = mul_func_block(inputFp32, gammaFp32)

  val scaledFlow = Flow(Bits(32 bits))
  scaledFlow.valid   := scaledOut.fire
  scaledFlow.payload := scaledOut.payload
  scaledOut.ready    := scaleLockValid && emitActive

  val rsqrtFlow = Flow(Bits(32 bits))
  rsqrtFlow.valid   := scaleLockValid
  rsqrtFlow.payload := scaleLock

  val normFp32 = mul_func(scaledFlow, rsqrtFlow)
  val normFp16 = toFp16_func(normFp32)

  io.dataOut.valid   := normFp16.valid
  io.dataOut.payload := normFp16.payload

  when(io.dataOut.fire && emitActive) {
    emitIdx := emitIdx + 1
    when(emitLast) {
      scaleLockValid := False
    }
  }

  // -------------------------------------------------------------------------
  // FSM
  // -------------------------------------------------------------------------
  switch(state) {
    is(State.IDLE) {
      when(io.dataIn.valid || io.weightIn.valid) {
        state          := State.COLLECT
        dataCnt        := 0
        weightCnt      := 0
        sqrCnt         := 0
        scaleLockValid := False
      }
    }
    is(State.COLLECT) {
      when(dataDone && weightDone) {
        state := State.WAIT_RSQRT
      }
    }
    is(State.WAIT_RSQRT) {
      when(scaleLockValid) {
        state := State.EMIT
      }
    }
    is(State.EMIT) {
      when(io.dataOut.fire && emitLast) {
        state := State.IDLE
      }
    }
  }

  io.dataIn.ready := (state === State.COLLECT) && !dataDone
  io.weightIn.ready := (state === State.COLLECT) && !weightDone

  io.busy := state =/= State.IDLE
}
