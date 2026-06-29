package top

import gemvService64.GemvGenerics
import spinal.core._

/** Milestone 2a top-level elaboration parameters. */
case class LlamaM2aGenerics(
  dim:          Int     = 2048,
  gemvM:        Int     = 2048,
  useSimIp:     Boolean = false,
  axiDataWidth: Int     = 256
) {
  require(dim > 0 && gemvM > 0)
  val gemvG = GemvGenerics(vectorDim = dim, maxRows = gemvM)

  val scaleBytesTotal: Long =
    gemvM.toLong * gemvG.groupsPerRow.toLong * 2L

  val scaleChunkBytes: Long = 0x1000L

  val scaleChunks: Int =
    ((scaleBytesTotal + scaleChunkBytes - 1) / scaleChunkBytes).toInt
}
