package rmsNorm

/** Software FP16 convert helpers for simulation testbenches only. */
object Fp16Sim {
  def floatToBits(f: Float): Int = {
    val bits = java.lang.Float.floatToIntBits(f)
    val sign = (bits >>> 31) & 1
    val exp  = (bits >>> 23) & 0xff
    val mant = bits & 0x7fffff
    if (exp == 0xff) return (sign << 15) | 0x7c00
    if (exp == 0) return sign << 15
    val newExp = exp - 127 + 15
    if (newExp >= 0x1f) return (sign << 15) | 0x7c00
    if (newExp <= 0) return sign << 15
    val newMant = mant >>> 13
    (sign << 15) | (newExp << 10) | newMant
  }

  def bitsToFloat(h: Int): Float = {
    val sign = (h >>> 15) & 1
    val exp  = (h >>> 10) & 0x1f
    val mant = h & 0x3ff
    if (exp == 0) return if (sign == 1) -0.0f else 0.0f
    if (exp == 0x1f) {
      if (mant == 0) return if (sign == 1) -Float.PositiveInfinity else Float.PositiveInfinity
      return Float.NaN
    }
    val e    = exp - 15 + 127
    val m    = mant << 13
    val bits = (sign << 31) | (e << 23) | m
    java.lang.Float.intBitsToFloat(bits)
  }
}
