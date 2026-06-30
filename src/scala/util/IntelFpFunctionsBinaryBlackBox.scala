package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * BlackBox for binary Quartus `altera_fp_functions` IPs (e.g. `fp32Div`).
 *
 * Port names match [[quartus_ip]] `*_bb.v` shells (`a` = left / dividend, `b` = right / divisor).
 */
class IntelFpFunctionsBinaryBlackBox(
  val ipName:      String,
  val inputWidth:  Int,
  val outputWidth: Int
) extends BlackBox {

  val io = new Bundle {
    val clk    = in Bool()
    val areset = in Bool()
    val en     = in Bits(1 bits)
    val a      = in Bits(inputWidth bits)
    val b      = in Bits(inputWidth bits)
    val q      = out Bits(outputWidth bits)
  }

  noIoPrefix()
  mapClockDomain(clock = io.clk, reset = io.areset, resetActiveLevel = HIGH)
  setDefinitionName(ipName)
}
