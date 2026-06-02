package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * RMSNorm function-injection bundle for Agilex Quartus IPs.
 *
 * Wire into `RmsNormCore` / `RMSNormFp32` constructor parameters the same way as Xilinx
 * `fp32mul8.mul`, `fp32acc22.acc`, etc. in llama-fpga.
 */
object RmsNormAlteraIp {
  val toFp32:   Flow[Bits] => Flow[Bits]                               = fp16ToFp32.convert
  val toFp16:   Flow[Bits] => Flow[Bits]                               = fp32ToFp16.convert
  val mul:      (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32MultAcc.mul
  val mulBlock: (Stream[Bits], Stream[Bits]) => Stream[Bits]         = fp32MultAcc.mulStream
  val acc:      Flow[Fragment[Bits]] => Flow[Fragment[Bits]]           = fp32MultAcc.serialAcc
  val add:      (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32Add.add
  val rsqrt:    Flow[Bits] => Flow[Bits]                               = fp32Rsqrt.rsqrt
}

/** Simulation stubs (no BlackBox). */
object RmsNormAlteraIpSim {
  val toFp32:   Flow[Bits] => Flow[Bits]                               = fp16ToFp32.convert_sim
  val toFp16:   Flow[Bits] => Flow[Bits]                               = fp32ToFp16.convert_sim
  val mul:      (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32MultAcc.mul_sim
  val mulBlock: (Stream[Bits], Stream[Bits]) => Stream[Bits]         = fp32MultAcc.mulStream_sim
  val acc:      Flow[Fragment[Bits]] => Flow[Fragment[Bits]]           = fp32MultAcc.serialAcc_sim
  val add:      (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32Add.add_sim
  val rsqrt:    Flow[Bits] => Flow[Bits]                               = fp32Rsqrt.rsqrt_sim
}
