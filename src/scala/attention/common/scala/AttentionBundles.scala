package attention.common

import spinal.core._
import spinal.lib.bus.amba4.axis.Axi4StreamConfig

/** M2c attention / softmax parameters (Llama 3.2 1B, 1K decode). */
case class AttentionGenerics(maxSeqLen: Int = 1025) {
  require(maxSeqLen >= 1 && maxSeqLen <= 1025, s"maxSeqLen=$maxSeqLen out of range")
  val lenWidth: Int = log2Up(maxSeqLen + 1)
  val idxWidth:  Int = log2Up(maxSeqLen)
}

object AttentionAxisCfg {
  def apply(): Axi4StreamConfig = Axi4StreamConfig(
    dataWidth = 2,
    useKeep   = true,
    useStrb   = false,
    useLast   = true,
    useId     = false,
    useDest   = false,
    useUser   = true,
    userWidth = 16
  )
}

/** IEEE754 binary32 `a > b` (NaN-safe: never true when either operand is NaN). */
object Fp32Compare {
  def gt(a: Bits, b: Bits): Bool = {
    val aNaN = a(30 downto 23) === B(255, 8 bits) && a(22 downto 0) =/= 0
    val bNaN = b(30 downto 23) === B(255, 8 bits) && b(22 downto 0) =/= 0
    val aNeg = a(31)
    val bNeg = b(31)
    val magGt = a(30 downto 0).asUInt > b(30 downto 0).asUInt
    val magLt = a(30 downto 0).asUInt < b(30 downto 0).asUInt
    val ordGt = (aNeg =/= bNeg) ? (!aNeg) | (aNeg && magLt)
    !aNaN && !bNaN && ordGt
  }
}

/**
 * IEEE754 binary16 `a > b` (NaN-safe). Same ordered sign-magnitude compare as
 * [[Fp32Compare]] but on the narrow 16-bit field — used for softmax max-tracking
 * so no fp16->fp32 conversion sits in the per-element compare path.
 */
object Fp16Compare {
  def gt(a: Bits, b: Bits): Bool = {
    val aNaN = a(14 downto 10) === B(31, 5 bits) && a(9 downto 0) =/= 0
    val bNaN = b(14 downto 10) === B(31, 5 bits) && b(9 downto 0) =/= 0
    val aNeg = a(15)
    val bNeg = b(15)
    val magGt = a(14 downto 0).asUInt > b(14 downto 0).asUInt
    val magLt = a(14 downto 0).asUInt < b(14 downto 0).asUInt
    val ordGt = (aNeg =/= bNeg) ? (!aNeg) | (aNeg && magLt)
    !aNaN && !bNaN && ordGt
  }
}
