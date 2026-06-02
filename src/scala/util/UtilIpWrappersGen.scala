package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/** Generates Verilog for util IP wrapper smoke test (BlackBox instance names). */
object UtilIpWrappersGen extends App {
  val outDir = "gen/util_ip_wrappers"
  SpinalConfig(targetDirectory = outDir).generateVerilog(new UtilIpWrappersTop)
  println(s"Generated $outDir/UtilIpWrappersTop.v")
}

class UtilIpWrappersTop extends Component {
  val a16 = slave(Flow(Bits(16 bits)))
  val a32 = slave(Flow(Bits(32 bits)))
  val b32 = slave(Flow(Bits(32 bits)))
  val accIn = slave(Flow(Fragment(Bits(32 bits))))
  val sa = slave(Stream(Bits(32 bits)))
  val sb = slave(Stream(Bits(32 bits)))

  val r16to32 = master(Flow(Bits(32 bits)))
  val r32to16 = master(Flow(Bits(16 bits)))
  val rsqrt   = master(Flow(Bits(32 bits)))
  val rmul    = master(Flow(Bits(32 bits)))
  val radd    = master(Flow(Bits(32 bits)))
  val racc    = master(Flow(Fragment(Bits(32 bits))))
  val rmulS   = master(Stream(Bits(32 bits)))

  r16to32 << fp16ToFp32.convert(a16)
  r32to16 << fp32ToFp16.convert(a32)
  rsqrt   << fp32Rsqrt.rsqrt(a32)
  rmul    << fp32MultAcc.mul(a32, b32)
  radd    << fp32Add.add(a32, b32)
  racc    << fp32MultAcc.serialAcc(accIn)
  rmulS   << fp32MultAcc.mulStream(sa, sb)
}
