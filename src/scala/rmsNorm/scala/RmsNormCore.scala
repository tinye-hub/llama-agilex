package rmsNorm

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import util.{Fp32Epsilon, Fp32ScaleDown}

import scala.language.postfixOps

object RmsNormCore {
  def apply(
    dim: Int,
    toFp32_func: Flow[Bits] => Flow[Bits],
    toFp16_func: Flow[Bits] => Flow[Bits],
    mul_func: (Flow[Bits], Flow[Bits]) => Flow[Bits],
    sqrSum_func: Flow[Fragment[Bits]] => Flow[Fragment[Bits]],
    add_func: (Flow[Bits], Flow[Bits]) => Flow[Bits],
    rsqrt_func: Flow[Bits] => Flow[Bits]
  ): RmsNormCore =
    new RmsNormCore(RmsNormGenerics(dim), toFp32_func, toFp16_func, mul_func, sqrSum_func, add_func, rsqrt_func)
}

/**
 * RMSNorm core: activation / gamma each into a [[StreamFifo]]; square-sum + rsqrt run on the
 * live data input path. EMIT starts once `scaleLock` is valid, the weight FIFO is non-empty,
 * and [[io.emitAllow]] is true (outer output FIFO empty and downstream ready). The EMIT
 * datapath is all `Flow` (no handshake) for full pipelined throughput.
 */
class RmsNormCore(
  val g: RmsNormGenerics,
  toFp32_func: Flow[Bits] => Flow[Bits],
  toFp16_func: Flow[Bits] => Flow[Bits],
  mul_func: (Flow[Bits], Flow[Bits]) => Flow[Bits],
  sqrSum_func: Flow[Fragment[Bits]] => Flow[Fragment[Bits]],
  add_func: (Flow[Bits], Flow[Bits]) => Flow[Bits],
  rsqrt_func: Flow[Bits] => Flow[Bits]
) extends Component {

  val io = new Bundle {
    val dataIn    = slave(Stream(Bits(16 bits)))
    val weightIn  = slave(Stream(Bits(16 bits)))
    val dataOut   = master(Flow(Bits(16 bits)))
    /** True when the outer output FIFO is empty and the AXI sink can accept (safe to start EMIT). */
    val emitAllow = in Bool()
    val busy      = out Bool()
  }

  val dim        = g.dim
  val fifoDepth  = g.fifoDepth
  val addrWidth  = log2Up(dim)
  val cntWidth   = log2Up(dim + 1)
  val occWidth   = log2Up(fifoDepth + 1)
  val scaleShift = log2Up(dim)

  object State extends SpinalEnum {
    val IDLE, COLLECT, WAIT_RSQRT, EMIT = newElement()
  }
  val state = RegInit(State.IDLE)

  val dataFifo = StreamFifo(
    dataType = Bits(16 bits),
    depth    = fifoDepth
  )
  val weightFifo = StreamFifo(
    dataType = Bits(16 bits),
    depth    = fifoDepth
  )

  val dataCnt   = Reg(UInt(cntWidth bits)) init (0)
  val weightCnt = Reg(UInt(cntWidth bits)) init (0)

  val dataDone   = dataCnt === U(dim, cntWidth bits)
  val weightDone = weightCnt === U(dim, cntWidth bits)

  val collectActive = state === State.COLLECT
  val acceptData    = collectActive && !dataDone
  val acceptWeight  = !weightDone && (state === State.COLLECT || state === State.WAIT_RSQRT || state === State.EMIT)

  val weightHasData = weightFifo.io.occupancy =/= U(0, occWidth bits)

  // --- data in: FIFO push + live square-sum tap (same beat) ---
  val dataPush = Stream(Bits(16 bits))
  dataPush.valid   := io.dataIn.valid && acceptData
  dataPush.payload := io.dataIn.payload
  dataFifo.io.push << dataPush
  io.dataIn.ready := dataPush.ready

  when(dataPush.fire) {
    dataCnt := dataCnt + 1
  }

  val collectFlow = Flow(Bits(16 bits))
  collectFlow.valid   := dataPush.fire
  collectFlow.payload := dataPush.payload

  val toBeNormFp32 = toFp32_func(collectFlow)

  val sqrCnt  = Reg(UInt(addrWidth bits)) init (0)
  val sqrLast = sqrCnt === U(dim - 1, addrWidth bits)
  when(toBeNormFp32.valid) {
    sqrCnt := sqrCnt + 1
    when(sqrLast) {
      sqrCnt := 0
    }
  }

  val sqrSumIn = Flow(Fragment(Bits(32 bits)))
  sqrSumIn.valid    := toBeNormFp32.valid
  sqrSumIn.fragment := toBeNormFp32.payload
  sqrSumIn.last     := sqrLast

  val sqrSumOut = sqrSum_func(sqrSumIn)

  val accDone = sqrSumOut.valid && sqrSumOut.last

  val meanSquare = Fp32ScaleDown(sqrSumOut.fragment, scaleShift)

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

  // --- weight in: FIFO push (may continue during WAIT_RSQRT / EMIT) ---
  val weightPush = Stream(Bits(16 bits))
  weightPush.valid   := io.weightIn.valid && acceptWeight
  weightPush.payload := io.weightIn.payload
  weightFifo.io.push << weightPush
  io.weightIn.ready := weightPush.ready

  when(weightPush.fire) {
    weightCnt := weightCnt + 1
  }

  // --- EMIT: Flow-only datapath (×gamma → ×scaleLock → fp16), no internal backpressure ---
  val outIdx     = Reg(UInt(addrWidth bits)) init (0)
  val emitActive = state === State.EMIT
  val emitLast   = outIdx === U(dim - 1, addrWidth bits)

  val emitBeatValid = emitActive && dataFifo.io.pop.valid && weightFifo.io.pop.valid

  val inputRaw = Flow(Bits(16 bits))
  inputRaw.valid   := emitBeatValid
  inputRaw.payload := dataFifo.io.pop.payload

  val weightRaw = Flow(Bits(16 bits))
  weightRaw.valid   := emitBeatValid
  weightRaw.payload := weightFifo.io.pop.payload

  dataFifo.io.pop.ready   := emitBeatValid
  weightFifo.io.pop.ready := emitBeatValid

  val inputFp32 = toFp32_func(inputRaw)
  val gammaFp32 = toFp32_func(weightRaw)
  val scaledOut = mul_func(inputFp32, gammaFp32)

  val rsqrtFlow = Flow(Bits(32 bits))
  rsqrtFlow.valid   := scaleLockValid && emitActive
  rsqrtFlow.payload := scaleLock

  val normFp32 = mul_func(scaledOut, rsqrtFlow)
  val normFp16 = toFp16_func(normFp32)

  io.dataOut.valid   := normFp16.valid && emitActive
  io.dataOut.payload := normFp16.payload

  val outBeat = io.dataOut.valid
  when(outBeat) {
    outIdx := outIdx + 1
    when(emitLast) {
      scaleLockValid := False
    }
  }

  val jobDone = outBeat && emitLast

  dataFifo.io.flush   := jobDone
  weightFifo.io.flush := jobDone

  switch(state) {
    is(State.IDLE) {
      state := State.COLLECT
    }
    is(State.COLLECT) {
      when(dataDone) {
        state := State.WAIT_RSQRT
      }
    }
    is(State.WAIT_RSQRT) {
      when(scaleLockValid && weightHasData && io.emitAllow) {
        state := State.EMIT
      }
    }
    is(State.EMIT) {
      when(jobDone) {
        state     := State.IDLE
        dataCnt   := 0
        weightCnt := 0
        sqrCnt    := 0
        outIdx    := 0
      }
    }
  }

  io.busy := state =/= State.IDLE

  state.simPublic()
  dataCnt.simPublic()
  weightCnt.simPublic()
  scaleLockValid.simPublic()
  accDone.simPublic()
}
