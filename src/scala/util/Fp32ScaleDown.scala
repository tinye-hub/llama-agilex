package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/** Divide FP32 by 2^rightShift via exponent field only (no DSP). */
object Fp32ScaleDown {
  def apply(src: Bits, rightShift: Int): Bits = {
    val expo    = src.drop(23).take(8).asUInt
    val newExpo = Mux(expo > rightShift, expo - rightShift, U(0)).asBits
    src.msb ## newExpo ## src.take(23)
  }

  def apply(src: Bits, rightShift: UInt): Bits = {
    val expo    = src.drop(23).take(8).asUInt
    val newExpo = Mux(expo > rightShift, expo - rightShift, U(0)).asBits
    src.msb ## newExpo ## src.take(23)
  }
}

/** Llama 3.2 1B RMSNorm epsilon = 1e-5 in IEEE FP32. */
object Fp32Epsilon {
  def bits: Bits = B(0x358637BD, 32 bits)
}
