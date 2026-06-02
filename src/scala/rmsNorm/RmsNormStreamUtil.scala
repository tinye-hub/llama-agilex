package rmsNorm

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

object RmsNormStreamUtil {

  /** Stream slave to Flow (downstream Flow has no backpressure). */
  def streamToFlow(s: Stream[Bits]): Flow[Bits] = {
    val f = Flow(Bits(s.payload.getWidth bits))
    f.valid   := s.valid
    f.payload := s.payload
    s.ready   := True
    f
  }

  /** Flow master to Stream (single-cycle valid pulses). */
  def flowToStream(f: Flow[Bits]): Stream[Bits] = {
    val s = Stream(Bits(f.payload.getWidth bits))
    s.valid   := f.valid
    s.payload := f.payload
    s
  }

  def toFp32Stream(
    s: Stream[Bits],
    toFp32: Flow[Bits] => Flow[Bits]
  ): Stream[Bits] = {
    val f = Flow(Bits(s.payload.getWidth bits))
    f.valid   := s.valid
    f.payload := s.payload
    val outF = toFp32(f)
    val outS = flowToStream(outF)
    s.ready := outS.ready
    outS
  }
}
