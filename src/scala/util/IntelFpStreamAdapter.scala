package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Converts a binary `Flow` multiply into a `Stream` multiply with joint ready on both operands.
 * Only one multiply is in flight at a time so the Flow output can be captured safely.
 */
class FpMultAccMulStreamAdapter(
  val ipName:  String,
  val latency: Int
) extends Component {

  val io = new Bundle {
    val a = slave(Stream(Bits(32 bits)))
    val b = slave(Stream(Bits(32 bits)))
    val r = master(Stream(Bits(32 bits)))
  }

  val mul = new FpMultAccMulAdapter(ipName, latency)

  val outR = Stream(Bits(32 bits))
  val held = RegInit(False)
  val heldPayload = Reg(Bits(32 bits))

  outR.valid   := held
  outR.payload := heldPayload

  val inFlight = RegInit(False)
  val canAccept = !held || outR.ready

  val fire = io.a.valid && io.b.valid && canAccept && !inFlight
  mul.io.a.valid   := fire
  mul.io.a.payload := io.a.payload
  mul.io.b.valid   := fire
  mul.io.b.payload := io.b.payload

  when(fire) {
    inFlight := True
  }
  when(mul.io.r.valid) {
    held := True
    heldPayload := mul.io.r.payload
    inFlight := False
  }
  when(outR.fire) {
    held := False
  }

  io.a.ready := io.b.valid && canAccept && !inFlight
  io.b.ready := io.a.valid && canAccept && !inFlight
  io.r       << outR
}
