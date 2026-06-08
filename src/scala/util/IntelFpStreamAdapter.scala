package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Pipelined FP32 multiply Stream adapter backed by [[IntelFpMultAccBlackBox]] (`accumulate = 0`).
 *
 * When both operand streams present a beat and the output FIFO has space, a new multiply is
 * launched every cycle. Operand streams only need paired `valid` (classic join); there is no
 * single-in-flight `held` / `inFlight` slot. `valid` on the output is delayed by `latency`;
 * `payload` is driven directly from the IP result.
 */
class FpMultAccMulStreamAdapter(
  val ipName:       String,
  val latency:      Int,
  val outFifoDepth: Int = 0
) extends Component {

  val io = new Bundle {
    val a = slave(Stream(Bits(32 bits)))
    val b = slave(Stream(Bits(32 bits)))
    val r = master(Stream(Bits(32 bits)))
  }

  val fifoDepth = if (outFifoDepth > 0) outFifoDepth else latency + 4
  val outFifo   = StreamFifo(Bits(32 bits), fifoDepth)

  val ip = new IntelFpMultAccBlackBox(ipName)
  ip.io.ena        := B(7, 3 bits)
  ip.io.accumulate := False

  val canFeed  = outFifo.io.push.ready
  val beatFire = io.a.valid && io.b.valid && canFeed

  ip.io.fp32_mult_a := Mux(beatFire, io.a.payload, B(0, 32 bits))
  ip.io.fp32_mult_b := Mux(beatFire, io.b.payload, B(0, 32 bits))

  val outPush = Stream(Bits(32 bits))
  outPush.valid   := Delay(beatFire, latency, init = False)
  outPush.payload := ip.io.fp32_result
  outFifo.io.push << outPush

  io.r       << outFifo.io.pop
  io.a.ready := io.b.valid && canFeed
  io.b.ready := io.a.valid && canFeed
}
