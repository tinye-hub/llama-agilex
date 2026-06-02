package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/** BlackBox for Quartus `fp32MultAcc` (Agilex native FP MAC). */
class IntelFpMultAccBlackBox(val ipName: String = "fp32MultAcc") extends BlackBox {
  val io = new Bundle {
    val accumulate  = in Bool()
    val fp32_mult_a = in Bits(32 bits)
    val fp32_mult_b = in Bits(32 bits)
    val clk         = in Bool()
    val ena         = in Bits(3 bits)
    val fp32_result = out Bits(32 bits)
  }

  noIoPrefix()
  mapClockDomain(clock = io.clk)
  setDefinitionName(ipName)
}

/** BlackBox for Quartus `fp32Add` (Agilex native FP adder). */
class IntelFpAddBlackBox(val ipName: String = "fp32Add") extends BlackBox {
  val io = new Bundle {
    val fp32_adder_a = in Bits(32 bits)
    val fp32_adder_b = in Bits(32 bits)
    val clk          = in Bool()
    val ena          = in Bits(3 bits)
    val fp32_result  = out Bits(32 bits)
  }

  noIoPrefix()
  mapClockDomain(clock = io.clk)
  setDefinitionName(ipName)
}

/** Clock-enable value that enables all pipeline stages (per IP default note: tie ena to VCC). */
object IntelNativeFpDspEna {
  def allEnabled: Bits = B(7, 3 bits)
}
