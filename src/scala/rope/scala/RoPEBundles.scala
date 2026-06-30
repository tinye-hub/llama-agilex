package rope

import spinal.core._
import spinal.lib.bus.amba4.axis.Axi4StreamConfig

/** M2b RoPE parameters (Llama 3.2 1B: head_dim=64, 1K context). */
case class RoPEGenerics(
    headDim: Int = RoPETableInit.headDim,
    maxPos:  Int = RoPETableInit.maxPos,
    fp16Width: Int = 16
) {
  require(headDim == RoPETableInit.headDim,
    s"headDim=$headDim must match RoPETableInit (${RoPETableInit.headDim})")
  require(maxPos <= RoPETableInit.maxPos,
    s"maxPos=$maxPos exceeds compiled table (${RoPETableInit.maxPos})")
  require(headDim % 2 == 0, "headDim must be even")
  val dimIdxWidth: Int = log2Up(headDim)
  val posWidth:    Int = log2Up(maxPos)
  val romAddrWidth: Int = log2Up(maxPos * headDim)
}

object RoPEAxisCfg {
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

/** Paired outputs from [[RoPERotate]] (original + rotated partner). */
case class RoPELinkedPair() extends Bundle {
  val a = Bits(16 bits)
  val b = Bits(16 bits)
}
