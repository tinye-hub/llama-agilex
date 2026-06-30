package rope

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

/**
 * Serial RoPE on one head vector (`head_dim` FP16 beats in and out).
 *
 * Processes interleaved dimension pairs with [[RoPEPairPipe]] and offline
 * [[RoPECosSinRom]] tables (Llama 3.2 1B: head_dim=64, rope_theta=500k).
 */
class SerialRoPE(
    g: RoPEGenerics,
    mulFp16: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RoPEAlteraIp.mulFp16Fn,
    addFp16: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RoPEAlteraIp.addFp16Fn
) extends Component {

  val axisCfg = RoPEAxisCfg()
  val dimW    = log2Up(g.headDim)
  val pairW   = log2Up(g.headDim / 2)

  val io = new Bundle {
    val seqPos  = in UInt (g.posWidth bits)
    val dataIn  = slave(Axi4Stream(axisCfg))
    val dataOut = master(Axi4Stream(axisCfg))
  }

  object State extends SpinalEnum {
    val IDLE, EMIT_Y0, EMIT_Y1 = newElement()
  }

  val cosSinRom = new RoPECosSinRom(g)
  val pairPipe  = new RoPEPairPipe(mulFp16, addFp16)

  val state     = RegInit(State.IDLE)
  val inIdx     = Reg(UInt(dimW bits)) init (0)
  val outIdx    = Reg(UInt(dimW bits)) init (0)
  val seqPosReg = Reg(UInt(g.posWidth bits)) init (0)
  val userReg   = Reg(Bits(16 bits)) init (0)
  val x0Reg     = Reg(Bits(16 bits)) init (0)
  val x1Reg     = Reg(Bits(16 bits)) init (0)
  val pairIdx   = Reg(UInt(pairW bits)) init (0)
  val y0Hold    = Reg(Bits(16 bits)) init (0)
  val y1Hold    = Reg(Bits(16 bits)) init (0)
  val cosLatch  = Reg(Bits(16 bits)) init (0)
  val sinLatch  = Reg(Bits(16 bits)) init (0)
  val inputDone = Reg(Bool()) init (False)

  val inLast  = inIdx === U(g.headDim - 1)
  val outLast = outIdx === U(g.headDim - 1)

  // Latch ROM address on even beats; readSync + output reg => 2-cycle table latency.
  val romSeqPos = Reg(UInt(g.posWidth bits))
  val romDimIdx = Reg(UInt(g.dimIdxWidth bits))
  when(io.dataIn.fire && inIdx(0) === False) {
    romSeqPos := Mux(inIdx === 0, io.seqPos, seqPosReg)
    romDimIdx := ((inIdx >> 1) << 1).resized
  }
  cosSinRom.io.seqPos := romSeqPos
  cosSinRom.io.dimIdx := romDimIdx

  val cosRomD1 = RegNext(cosSinRom.io.cosOut)
  val sinRomD1 = RegNext(cosSinRom.io.sinOut)

  val pipeBusy    = Reg(Bool()) init (False)
  val pairPending = Reg(Bool()) init (False)

  val oddBeatFire = io.dataIn.fire && inIdx(0) === True
  val commitPair  = pairPending && !pipeBusy && state === State.IDLE &&
    (!io.dataOut.valid || io.dataOut.ready)

  io.dataIn.ready := !inputDone && state === State.IDLE && !pipeBusy && !pairPending &&
    (!io.dataOut.valid || io.dataOut.ready)

  when(io.dataIn.fire) {
    when(inIdx === 0) {
      seqPosReg := io.seqPos
      userReg   := io.dataIn.payload.user(15 downto 0)
    }
    when(inIdx(0) === False) {
      x0Reg := io.dataIn.payload.data
    }
    when(oddBeatFire) {
      x1Reg       := io.dataIn.payload.data
      pairIdx     := inIdx >> 1
      pairPending := True
    }
    inIdx := inIdx + 1
    when(inLast) {
      inputDone := True
    }
  }

  val startD = RegNext(commitPair) init (False)

  pairPipe.io.start := startD
  pairPipe.io.x0    := x0Reg
  pairPipe.io.x1    := x1Reg
  pairPipe.io.cos   := cosLatch
  pairPipe.io.sin   := sinLatch

  when(commitPair) {
    cosLatch    := cosRomD1
    sinLatch    := sinRomD1
    pipeBusy    := True
    pairPending := False
  }
  when(pairPipe.io.done) {
    y0Hold := pairPipe.io.y0
    y1Hold := pairPipe.io.y1
    outIdx := (pairIdx << 1).resized
    state  := State.EMIT_Y0
  }
  when(state === State.EMIT_Y1 && io.dataOut.fire) {
    pipeBusy := False
  }

  io.dataOut.valid        := False
  io.dataOut.payload.data := 0
  io.dataOut.payload.last := outLast
  io.dataOut.payload.user  := userReg.resized
  io.dataOut.payload.keep  := B(3, 2 bits)

  switch(state) {
    is(State.IDLE) {
      // wait for pairPipe
    }
    is(State.EMIT_Y0) {
      io.dataOut.valid        := True
      io.dataOut.payload.data := y0Hold
      when(io.dataOut.fire) {
        state  := State.EMIT_Y1
        outIdx := outIdx + 1
      }
    }
    is(State.EMIT_Y1) {
      io.dataOut.valid        := True
      io.dataOut.payload.data := y1Hold
      when(io.dataOut.fire) {
        outIdx := outIdx + 1
        when(outLast) {
          outIdx    := 0
          inIdx     := 0
          inputDone := False
        }
        state := State.IDLE
      }
    }
  }
}
