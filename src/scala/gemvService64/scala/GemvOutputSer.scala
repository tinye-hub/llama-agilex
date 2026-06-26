package gemvService64

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

/**
 * Serialize per-row FP16 results into the `qOut` AXI4-Stream (design §9.4).
 *
 * Row results arrive on `rowIn` (one FP16 per row, lossless `Flow` from
 * [[GemvMacBeat]]) and are buffered in a `StreamFifo`. The engine guarantees the
 * FIFO never overflows by bounding rows-in-flight to `outFifoDepth`.
 *
 * `tuser` encoding (M2a):
 *   [15]    busy  (0 on the final beat, matching RmsNorm)
 *   [14:11] layerId
 *   [10:8]  gemvOp (W_Q=0, W_K=1, W_V=2)
 *   [7:0]   output row index low 8 bits
 *
 * `tlast` is asserted on the last row of the Job (`row == mRows-1`).
 */
class GemvOutputSer(g: GemvGenerics) extends Component {

  val axisCfg = GemvAxisCfg()
  val rowW    = log2Up(g.maxRows + 1)

  val io = new Bundle {
    val rowIn = slave(Flow(Bits(g.fp16Width bits)))
    val op    = in UInt (GemvOp.width bits)
    val layer = in UInt (4 bits)
    val mRows = in UInt (rowW bits)
    val clear = in Bool ()

    val qOut     = master(Axi4Stream(axisCfg))
    val popFire  = out Bool ()
    val done     = out Bool ()
    val overflow = out Bool ()
  }

  val fifo = StreamFifo(Bits(g.fp16Width bits), depth = g.outFifoDepth)

  val push = Stream(Bits(g.fp16Width bits))
  push.valid   := io.rowIn.valid
  push.payload := io.rowIn.payload
  fifo.io.push << push
  // Overflow is prevented by the engine's in-flight gating (rows in flight are
  // bounded to `outFifoDepth`); `io.overflow` is exposed for sim assertions.
  io.overflow := io.rowIn.valid && !push.ready

  val emitIdx = Reg(UInt(rowW bits)) init (0)
  val isLast  = emitIdx === (io.mRows - 1)

  val tuser = Bits(16 bits)
  tuser(7 downto 0)   := emitIdx.asBits.resize(8)
  tuser(10 downto 8)  := io.op(2 downto 0).asBits
  tuser(14 downto 11) := io.layer.asBits
  tuser(15)           := !isLast

  io.qOut.valid        := fifo.io.pop.valid
  io.qOut.payload.data := fifo.io.pop.payload
  io.qOut.payload.last := isLast
  io.qOut.payload.user := tuser.resized
  if (axisCfg.useKeep) io.qOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1
  fifo.io.pop.ready := io.qOut.ready

  val popFire = fifo.io.pop.fire
  when(popFire) {
    emitIdx := emitIdx + 1
    when(isLast) {
      emitIdx := 0
    }
  }

  io.popFire := popFire
  io.done    := popFire && isLast

  when(io.clear) {
    emitIdx := 0
  }
  fifo.io.flush := io.clear
}
