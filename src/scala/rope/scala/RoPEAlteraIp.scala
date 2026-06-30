package rope

import spinal.core._
import spinal.lib._
import util.{fp16ToFp32, fp32Add, fp32MultAcc, fp32ToFp16}

import scala.language.postfixOps

/**
 * FP16 RoPE arithmetic via Agilex Quartus IPs (FP16 in → FP32 compute → FP16 out).
 */
object RoPEAlteraIp {
  val toFp32Lat = fp16ToFp32.latency
  val mulLat    = fp32MultAcc.latency
  val addLat    = fp32Add.latency
  val toFp16Lat = fp32ToFp16.latency

  val mulFp16Lat: Int = toFp32Lat + mulLat + toFp16Lat
  val addFp16Lat: Int = toFp32Lat + addLat + toFp16Lat
  val elemLat: Int    = mulFp16Lat + addFp16Lat

  private def mulFp16Impl(
      a: Flow[Bits],
      b: Flow[Bits],
      mul: (Flow[Bits], Flow[Bits]) => Flow[Bits],
      to32: Flow[Bits] => Flow[Bits],
      to16: Flow[Bits] => Flow[Bits]
  ): Flow[Bits] = {
    val p = mul(to32(a), to32(b))
    to16(p)
  }

  private def addFp16Impl(
      a: Flow[Bits],
      b: Flow[Bits],
      add: (Flow[Bits], Flow[Bits]) => Flow[Bits],
      to32: Flow[Bits] => Flow[Bits],
      to16: Flow[Bits] => Flow[Bits]
  ): Flow[Bits] = {
    val s = add(to32(a), to32(b))
    to16(s)
  }

  def mulFp16Fn(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] =
    mulFp16Impl(a, b, fp32MultAcc.mul, fp16ToFp32.convert, fp32ToFp16.convert)

  def addFp16Fn(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] =
    addFp16Impl(a, b, fp32Add.add, fp16ToFp32.convert, fp32ToFp16.convert)

  def mulFp16_sim(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] =
    mulFp16Impl(a, b, fp32MultAcc.mul_sim, fp16ToFp32.convert_sim, fp32ToFp16.convert_sim)

  def addFp16_sim(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] =
    addFp16Impl(a, b, fp32Add.add_sim, fp16ToFp32.convert_sim, fp32ToFp16.convert_sim)
}
