package gemvService64

import scala.language.postfixOps

/**
 * Elaboration-time parameters for the common 64-wide GEMV service.
 *
 * Authoritative spec: `gemvService64/doc/gemv-m2a-design.md`.
 *
 * M2a freeze: `bankLen = 64`, aligned with the 256-bit AXI weight beat
 * (32 B = 64×INT4) and the ActBuffer 1024-bit wide read (64×FP16).
 *
 * @param vectorDim   inner-product length K (default 2048 = `DdrMemoryMap.vectorDim`)
 * @param maxRows     largest output dim M serviced by one Job (2048 for W_Q)
 * @param bankLen     K elements per beat / MAC width (64, do not change for M2a)
 * @param groupSize   INT4 quantization group size along K (128)
 */
case class GemvGenerics(
  vectorDim: Int = 2048,
  maxRows:   Int = 2048,
  bankLen:   Int = 64,
  groupSize: Int = 128,
  /** Output result FIFO depth; also bounds rows in flight in the MAC pipeline. */
  outFifoDepth: Int = 16
) {
  require(vectorDim % bankLen == 0, s"vectorDim ($vectorDim) must be a multiple of bankLen ($bankLen)")
  require(groupSize % bankLen == 0, s"groupSize ($groupSize) must be a multiple of bankLen ($bankLen)")

  /** FP16 element width in bits. */
  val fp16Width: Int = 16

  /** INT4 nibble width in bits. */
  val int4Width: Int = 4

  /** macBeats per row = K / bankLen (2048 / 64 = 32). */
  val tilesPerRow: Int = vectorDim / bankLen

  /** Width of one ActBuffer wide word (64 × FP16 = 1024). */
  val tileFp16Width: Int = bankLen * fp16Width

  /** Width of one DDR weight beat (64 × INT4 = 256). */
  val tileInt4Width: Int = bankLen * int4Width

  /** INT4 scale groups per row (K / groupSize = 16). */
  val groupsPerRow: Int = vectorDim / groupSize

  /** Number of K-tiles that share one scale group (groupSize / bankLen = 2). */
  val tilesPerGroup: Int = groupSize / bankLen

  /** Bytes of one INT4 weight row (K / 2). */
  val rowByteStride: Int = vectorDim / 2

  /** Bytes of one INT4 weight tile (bankLen / 2 = 32). */
  val tileByteStride: Int = bankLen / 2
}
