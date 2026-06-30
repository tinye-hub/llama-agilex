package attention.softmax

import spinal.core._
import spinal.lib._
import util.{fp16ToFp32, fp32Add, fp32Div, fp32Exp, fp32MultAcc, fp32ToFp16}

import scala.language.postfixOps

/** Quartus FP IP bundle for [[SoftmaxCore]] / [[SerialSafeSoftmaxAxiTop]]. */
object SoftmaxAlteraIp {
  val toFp32: Flow[Bits] => Flow[Bits]                               = fp16ToFp32.convert
  val toFp16: Flow[Bits] => Flow[Bits]                               = fp32ToFp16.convert
  val add:    (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32Add.add
  val mul:    (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32MultAcc.mul
  val exp:    Flow[Bits] => Flow[Bits]                               = fp32Exp.exp
  val div:    (Flow[Bits], Flow[Bits]) => Flow[Bits]                = fp32Div.div

  val expLatency: Int = fp32Exp.latency
  val divLatency: Int = fp32Div.latency
  val addLatency: Int = fp32Add.latency
  val mulLatency: Int = fp32MultAcc.latency
  val toFp16Latency: Int = fp32ToFp16.latency
}
