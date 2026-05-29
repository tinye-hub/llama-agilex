package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Intel/Altera Floating-Point IP wrappers for Agilex 5E013B.
 *
 * Mirrors [[XilinxFloatIPCollection]] so that the function-injection pattern
 * used in RMSNormFp32 / RmsNormAxiTop can be swapped between vendors by
 * simply referencing objects in this file instead of the Xilinx equivalents.
 *
 * Instantiation names (ipName strings) must match the component names in your
 * Quartus project.  Create each IP via the Quartus IP Catalog:
 *   - altera_fp_functions  (ALTFP_MULT, ALTFP_ADD, ALTFP_SQRT, ALTFP_CONVERT)
 *   - or DSP Builder Advanced Blockset for custom precision/latency.
 *
 * Latency constants are typical values for altera_fp_functions at ~400 MHz on
 * Agilex 5.  Adjust after checking the Quartus IP Catalog for your exact
 * frequency / precision settings.
 *
 * RMSNorm data path requires:
 *   fp16toFp32Altera  – FP16 → FP32 conversion         (unary, latency ~6)
 *   fp32toFp16Altera  – FP32 → FP16 conversion         (unary, latency ~6)
 *   fp32mul8Altera    – FP32 multiply                   (binary, latency ~8)
 *   fp32acc11Altera   – FP32 serial accumulate          (unary-acc, latency ~11)
 *   fp32rsqrt28Altera – FP32 reciprocal square root     (unary, latency ~28)
 */

// ---------------------------------------------------------------------------
// fp16toFp32Altera  (FP16 → FP32, unary, latency 6)
// ---------------------------------------------------------------------------
object fp16toFp32Altera {

  val ipName  = "fp16_to_fp32"
  val latency = 6

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 1, inputWidth = 16, outputWidth = 32
  )

  /** Convert FP16 to FP32, synthesisable path. */
  def convert(a: Flow[Bits]) = new Composite(a, "toFp32") {
    val ip = new ipFlowIO()
    ip.io.a << a
  }.ip.io.r

  def convert(a: Bits, vld: Bool) = new Composite(a, "toFp32") {
    val ip = new ipFlowIO()
    ip.io.a.valid   := vld
    ip.io.a.payload := a
  }.ip.io.r
}

// ---------------------------------------------------------------------------
// fp32toFp16Altera  (FP32 → FP16, unary, latency 6)
// ---------------------------------------------------------------------------
object fp32toFp16Altera {

  val ipName  = "fp32_to_fp16"
  val latency = 6

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 1, inputWidth = 32, outputWidth = 16
  )

  /** Convert FP32 to FP16, synthesisable path. */
  def convert(a: Flow[Bits]) = new Composite(a, "toFp16") {
    val ip = new ipFlowIO()
    ip.io.a << a
  }.ip.io.r

  def convert(a: Bits, vld: Bool) = new Composite(a, "toFp16") {
    val ip = new ipFlowIO()
    ip.io.a.valid   := vld
    ip.io.a.payload := a
  }.ip.io.r
}

// ---------------------------------------------------------------------------
// fp32mul8Altera  (FP32 multiply, binary, latency 8)
// ---------------------------------------------------------------------------
object fp32mul8Altera {

  val ipName  = "fp32_mul"
  val latency = 8

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 2, inputWidth = 32, outputWidth = 32
  )

  /** FP32 multiply — synthesisable path. */
  def mul(a: Flow[Bits], b: Flow[Bits]) = new Composite(a, "mul") {
    val ip = new ipFlowIO()
    ip.io.a << a
    ip.io.b << b
  }.ip.io.r

  def mul(a: Bits, b: Bits, vld: Bool) = new Composite(a, "mul") {
    val ip = new ipFlowIO()
    ip.io.a.valid   := vld
    ip.io.a.payload := a
    ip.io.b.valid   := vld
    ip.io.b.payload := b
  }.ip.io.r
}

// ---------------------------------------------------------------------------
// fp32add8Altera  (FP32 add, binary, latency 8)
// Used internally; also useful for the +epsilon step.
// ---------------------------------------------------------------------------
object fp32add8Altera {

  val ipName  = "fp32_add"
  val latency = 8

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 2, inputWidth = 32, outputWidth = 32
  )

  def add(a: Flow[Bits], b: Flow[Bits]) = new Composite(a, "add") {
    val ip = new ipFlowIO()
    ip.io.a << a
    ip.io.b << b
  }.ip.io.r

  def add(a: Bits, b: Bits, vld: Bool) = new Composite(a, "add") {
    val ip = new ipFlowIO()
    ip.io.a.valid   := vld
    ip.io.a.payload := a
    ip.io.b.valid   := vld
    ip.io.b.payload := b
  }.ip.io.r
}

// ---------------------------------------------------------------------------
// fp32acc11Altera  (FP32 serial accumulator, unary-acc, latency 11)
//
// Intel ALTFP_ADD in accumulator mode: each valid beat is added to the running
// total; when accIn.last fires the accumulator resets after emitting the final
// sum via accOut.last.
// ---------------------------------------------------------------------------
object fp32acc11Altera {

  val ipName  = "fp32_acc"
  val latency = 11

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 1, inputWidth = 32, outputWidth = 32, isAcc = true
  )

  def acc(a: Flow[Fragment[Bits]]) = new Composite(a, "acc") {
    val ip = new ipFlowIO()
    ip.io.accIn << a
  }.ip.io.accOut
}

// ---------------------------------------------------------------------------
// fp32rsqrt28Altera  (FP32 reciprocal square root, unary, latency 28)
//
// Implemented via ALTFP_SQRT followed by a reciprocal stage inside the IP,
// or as a single altera_fp_functions component with mode = INV_SQRT.
// Actual latency depends on IP Catalog configuration; 28 is a common value.
// ---------------------------------------------------------------------------
object fp32rsqrt28Altera {

  val ipName  = "fp32_rsqrt"
  val latency = 28

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 1, inputWidth = 32, outputWidth = 32
  )

  def rsqrt(a: Flow[Bits]) = new Composite(a, "rsqrt") {
    val ip = new ipFlowIO()
    ip.io.a << a
  }.ip.io.r

  def rsqrt(a: Bits, vld: Bool) = new Composite(a, "rsqrt") {
    val ip = new ipFlowIO()
    ip.io.a.valid   := vld
    ip.io.a.payload := a
  }.ip.io.r
}

// ---------------------------------------------------------------------------
// fp16mul6Altera  (FP16 multiply, binary, latency 6)
// Provided for completeness; not on the RMSNorm critical path.
// ---------------------------------------------------------------------------
object fp16mul6Altera {

  val ipName  = "fp16_mul"
  val latency = 6

  class ipFlowIO extends IntelFloatIPFlowIO(
    ipName = ipName, latency = latency,
    numOfOperand = 2, inputWidth = 16, outputWidth = 16
  )

  def mul(a: Flow[Bits], b: Flow[Bits]) = new Composite(a, "mul") {
    val ip = new ipFlowIO()
    ip.io.a << a
    ip.io.b << b
  }.ip.io.r

  def mul(a: Bits, b: Bits, vld: Bool) = new Composite(a, "mul") {
    val ip = new ipFlowIO()
    ip.io.a.valid   := vld
    ip.io.a.payload := a
    ip.io.b.valid   := vld
    ip.io.b.payload := b
  }.ip.io.r
}
