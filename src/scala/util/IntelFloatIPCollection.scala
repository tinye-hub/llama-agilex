package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Intel/Altera floating-point IP wrappers for Agilex 5E (Quartus `quartus_ip/`).
 *
 * | Quartus component | Scala object   | Latency (cycles) | BlackBox |
 * |:---|:---|:---:|:---|
 * | fp16ToFp32          | fp16ToFp32     | 0  | altera_fp_functions |
 * | fp32ToFp16          | fp32ToFp16     | 2  | altera_fp_functions |
 * | fp32Rsqrt           | fp32Rsqrt      | 14 | altera_fp_functions |
 * | fp32MultAcc         | fp32MultAcc    | 4  | native FP DSP |
 * | fp32Add             | fp32Add        | 4  | native FP DSP |
 *
 * Latencies for fp16/fp32 convert and rsqrt come from Quartus `*_generation.rpt`.
 * Native DSP latency is approximate (mult/add/output pipelines); re-check in simulation.
 *
 * Synthesis: `setDefinitionName` must match the Quartus IP instance name; RTL is linked
 * via `golden_top.qsf` `IP_FILE` entries, not via Scala paths.
 */
object fp16ToFp32 {

  val ipName  = "fp16ToFp32"
  val latency = 0

  def convert(a: Flow[Bits]): Flow[Bits] = new Composite(a, "convert") {
    val adp = new FpFunctionsUnaryAdapter(ipName, latency, 16, 32)
    adp.io.a << a
  }.adp.io.r

  def convert_sim(a: Flow[Bits]): Flow[Bits] = new Composite(a, "convert_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 1, 16, 32)
    ip.io.a << a
  }.ip.io.r
}

object fp32ToFp16 {

  val ipName  = "fp32ToFp16"
  val latency = 2

  def convert(a: Flow[Bits]): Flow[Bits] = new Composite(a, "convert") {
    val adp = new FpFunctionsUnaryAdapter(ipName, latency, 32, 16)
    adp.io.a << a
  }.adp.io.r

  def convert_sim(a: Flow[Bits]): Flow[Bits] = new Composite(a, "convert_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 1, 32, 16)
    ip.io.a << a
  }.ip.io.r
}

object fp32Rsqrt {

  val ipName  = "fp32Rsqrt"
  val latency = 14

  def rsqrt(a: Flow[Bits]): Flow[Bits] = new Composite(a, "rsqrt") {
    val adp = new FpFunctionsUnaryAdapter(ipName, latency, 32, 32)
    adp.io.a << a
  }.adp.io.r

  def rsqrt_sim(a: Flow[Bits]): Flow[Bits] = new Composite(a, "rsqrt_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 1, 32, 32)
    ip.io.a << a
  }.ip.io.r
}

object fp32MultAcc {

  val ipName = "fp32MultAcc"
  /** Native FP DSP mult+acc pipeline depth (ModelSim). */
  val latency = 5

  def mul(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] = new Composite(a, "mul") {
    val adp = new FpMultAccMulAdapter(ipName, latency)
    adp.io.a << a
    adp.io.b << b
  }.adp.io.r

  def mulStream(a: Stream[Bits], b: Stream[Bits]): Stream[Bits] = new Composite(a, "mulStream") {
    val adp = new FpMultAccMulStreamAdapter(ipName, latency)
    adp.io.a << a
    adp.io.b << b
  }.adp.io.r

  def serialAcc(a: Flow[Fragment[Bits]]): Flow[Fragment[Bits]] = new Composite(a, "serialAcc") {
    val adp = new FpMultAccSerialAccAdapter(ipName, latency)
    adp.io.accIn << a
  }.adp.io.accOut

  /** RMSNorm collect path: one MAC chain for `sum(x_i^2)`. */
  def sqrSum(a: Flow[Fragment[Bits]]): Flow[Fragment[Bits]] = new Composite(a, "sqrSum") {
    val adp = new FpMultAccSqrSumAdapter(ipName, latency)
    adp.io.accIn << a
  }.adp.io.accOut

  def mul_sim(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] = new Composite(a, "mul_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 2, 32, 32)
    ip.io.a << a
    ip.io.b << b
  }.ip.io.r

  def serialAcc_sim(a: Flow[Fragment[Bits]]): Flow[Fragment[Bits]] = new Composite(a, "serialAcc_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 1, 32, 32, isAcc = true)
    ip.io.accIn << a
  }.ip.io.accOut

  def sqrSum_sim(a: Flow[Fragment[Bits]]): Flow[Fragment[Bits]] = new Composite(a, "sqrSum_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 1, 32, 32, isAcc = true)
    ip.io.accIn << a
  }.ip.io.accOut

  def mulStream_sim(a: Stream[Bits], b: Stream[Bits]): Stream[Bits] = new Composite(a, "mulStream_sim") {
    val ip = new IntelFloatIPStreamMulSim(latency)
    ip.io.a << a
    ip.io.b << b
  }.ip.io.r
}

object fp32Add {

  val ipName  = "fp32Add"
  val latency = 4

  def add(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] = new Composite(a, "add") {
    val adp = new FpAddAdapter(ipName, latency)
    adp.io.a << a
    adp.io.b << b
  }.adp.io.r

  def add_sim(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] = new Composite(a, "add_sim") {
    val ip = new IntelFloatIPFlowIOSim(latency, 2, 32, 32)
    ip.io.a << a
    ip.io.b << b
  }.ip.io.r
}
