package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * BlackBox wrapper for Intel/Altera Floating-Point IP cores.
 *
 * Mirrors the structure of [[XilinxFloatIPFlowIO]] so that the same
 * function-injection pattern used in [[RMSNormFp32]] (Xilinx reference) can be
 * reused verbatim on Agilex, with only the injected function objects swapped.
 *
 * Intel IP naming convention expected by Quartus:
 *   - Non-accumulate (unary / binary):  port a → "dataa", port b → "datab",
 *     result → "result", enable → "clk_en", done → "nan" / "overflow" (unused).
 *   - The instantiation name (ipName) must match the Quartus IP component name
 *     generated via the IP Catalog (altera_fp_functions family or DSP Builder).
 *
 * @param ipName      Quartus component name, e.g. "fp32_mul", "fp32_rsqrt".
 * @param latency     Pipeline depth in clock cycles (0 = combinational).
 * @param numOfOperand Number of data inputs: 1 (unary) or 2 (binary).
 * @param inputWidth  Bit-width of each input operand (16 or 32).
 * @param outputWidth Bit-width of the result (16 or 32).
 * @param isAcc       True for accumulator-style IP (takes Flow[Fragment[Bits]]).
 */
class IntelFloatIPFlowIO(
  val ipName:       String,
  val latency:      Int,
  val numOfOperand: Int,
  val inputWidth:   Int,
  val outputWidth:  Int,
  val isAcc:        Boolean = false
) extends BlackBox {

  val io = new Bundle {
    // Clock / reset.  aclk present whenever latency > 0.
    val aclk    = if (latency != 0) in Bool()                              else null
    val aresetn = if (isAcc)        in Bool()                              else null

    // Non-accumulate ports ------------------------------------------------
    val a = if (!isAcc && numOfOperand >= 1) slave(Flow(Bits(inputWidth bits)))  else null
    val b = if (!isAcc && numOfOperand >= 2) slave(Flow(Bits(inputWidth bits)))  else null
    val r = if (!isAcc)                      master(Flow(Bits(outputWidth bits))) else null

    // Accumulate ports -----------------------------------------------------
    val accIn  = if (isAcc) slave(Flow(Fragment(Bits(inputWidth bits))))  else null
    val accOut = if (isAcc) master(Flow(Fragment(Bits(outputWidth bits)))) else null
  }

  // -------------------------------------------------------------------------
  // Port renaming to match Intel ALTFP / altera_fp_functions pin names.
  //
  // altera_fp_functions (non-acc):
  //   clock    → <ipName>_clk  (or just "clk" for some variants)
  //   valid-in → not needed; IP is always-enabled pipeline
  //   dataa    → first operand
  //   datab    → second operand
  //   result   → output
  //   valid-out → "valid" (optional; we track by latency counter instead)
  //
  // For maximum portability the SpinalHDL valid bit is connected to a
  // dedicated "valid" input when available, or left unconnected when the IP
  // is a free-running pipeline (valid-tracking done by the caller via the
  // latency value).
  // -------------------------------------------------------------------------

  noIoPrefix()

  if (!isAcc) {
    if (numOfOperand >= 1) io.a.setName("dataa")
    if (numOfOperand >= 2) io.b.setName("datab")
    io.r.setName("result")
    // valid companion signals expected by altera_fp_functions "enable" port
    if (numOfOperand >= 1) io.a.valid.setName("valid_in")
    if (numOfOperand >= 2) io.b.valid.setName("valid_in")   // same net
    io.r.valid.setName("valid_out")
  }

  if (isAcc) {
    io.accIn.setName("dataa")
    io.accIn.last.setName("accum_sload")   // last-beat drives accumulator sload
    io.accOut.setName("result")
    io.accOut.last.setName("valid_out")
    io.accIn.valid.setName("valid_in")
  }

  if (latency != 0) {
    if (isAcc) {
      mapClockDomain(clock = io.aclk, reset = io.aresetn, resetActiveLevel = LOW)
    } else {
      mapClockDomain(clock = io.aclk)
    }
  }

  this.setDefinitionName(ipName)
}
