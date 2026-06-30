package rope

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * RoPE element pairing (llama-fpga [[rope.RoPERotate]]).
 *
 * For each incoming FP16 beat, presents (A, B) where B is the rotate-half partner
 * so that `out = A*cos + B*sin` matches standard interleaved RoPE.
 */
class RoPERotate(maxDim: Int) extends Component {

  val io = new Bundle {
    val input  = slave(Flow(Bits(16 bits)))
    val output = master(Flow(RoPELinkedPair()))
    val dim    = in UInt (log2Up(maxDim) bits)
  }

  val halfDim = io.dim.drop(1).asUInt
  val inCnt   = UInt(log2Up(maxDim) - 1 bits).setAsReg().init(0)
  val inCntOvf = inCnt === halfDim
  val inputSecondHalf = Bool().setAsReg().init(False)

  when(io.input.valid) {
    inCnt := inCnt + 1
    when(inCntOvf) {
      inCnt.clearAll()
      inputSecondHalf := ~inputSecondHalf
    }
  }

  val rotateFifo = StreamFifo(Bits(16 bits), maxDim / 2)
  val rotateFifoPop = rotateFifo.io.pop.m2sPipe()
  rotateFifo.io.push.valid   := io.input.valid & ~inputSecondHalf
  rotateFifo.io.push.payload := io.input.payload

  val bypassFifo = StreamFifo(Bits(16 bits), maxDim / 2)
  val bypassFifoPop = bypassFifo.io.pop.m2sPipe()
  bypassFifo.io.push.valid   := io.input.valid
  bypassFifo.io.push.payload := io.input.payload

  val rotateOutCnt = UInt(log2Up(maxDim) - 1 bits).setAsReg().init(0)
  val rotateOutCntOvf = rotateOutCnt === halfDim
  val rotateSecondHalf = Bool().setAsReg().init(False)

  val rotateOut = Flow(Bits(16 bits))
  val in2Rotate = Flow(Bits(16 bits))
  val r = io.input.payload
  in2Rotate.valid := io.input.valid & inputSecondHalf
  in2Rotate.payload := (~r.msb ## r.dropHigh(1))

  when(io.input.valid) {
    rotateOutCnt := rotateOutCnt + 1
    when(rotateOutCntOvf) {
      rotateOutCnt.clearAll()
      rotateSecondHalf := ~rotateSecondHalf
    }
  }

  rotateOut.valid := in2Rotate.valid
  rotateOut.payload := Mux(rotateSecondHalf, rotateFifoPop.payload, in2Rotate.payload)
  rotateFifoPop.ready.removeAssignments()
  rotateFifoPop.ready := rotateSecondHalf

  io.output.valid   := rotateOut.valid
  io.output.payload.a := bypassFifoPop.payload
  io.output.payload.b := rotateOut.payload
  bypassFifoPop.ready := rotateOut.valid
}
