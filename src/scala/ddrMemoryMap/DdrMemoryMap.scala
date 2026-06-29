package ddrMemoryMap

/**
 * DDR logical address map for Llama 3.2 1B Plan A (DE25-Nano).
 *
 * Authoritative spec: `ddrMemoryMap/doc/ddr-memory-map.md`
 *
 * Constants are logical byte offsets in the PL model window (`0x0000_0000` .. `0x7FFF_FFFF`).
 * On DE25-Nano the active 1 GiB mirror (`0x0` .. `0x3FFF_FFFF`) is backed by LPDDR4B;
 * LPDDR4A is HPS-only. DdrAgent uses logical addr as LPDDR4B byte offset (no bank decode yet).
 *
 * Offline packers, LlamaScheduler, and DdrAgent must use the same constants here.
 */
object DdrMemoryMap {

  // ---------------------------------------------------------------------------
  // Layout identity (metadata / HpsJobCtrl read-only regs)
  // ---------------------------------------------------------------------------

  /** ASCII "LM32" — written to `META_BASE` GlobalHeader. */
  val layoutMagic: Long = 0x4C4D3332L

  /** Bump when `ddr-memory-map.md` or region bases change. */
  val layoutVersion: Int = 1

  // ---------------------------------------------------------------------------
  // Model / vector geometry
  // ---------------------------------------------------------------------------

  val vectorDim: Int     = 2048
  val fp16Bytes: Int     = 2
  val rowBytes: Long     = 0x1000L // vectorDim * fp16Bytes
  val vocabSize: Int     = 128256
  val gammaCount: Int    = 33
  val nLayers: Int       = 16
  val maxContextLen: Int = 1024 // 1K context (主线)

  // ---------------------------------------------------------------------------
  // Region bases and sizes
  // ---------------------------------------------------------------------------

  val embBase: Long       = 0x00000000L
  val embSize: Long       = vocabSize.toLong * rowBytes // 0x1F500000, 501 MiB
  val embEndInclusive: Long = embBase + embSize - 1     // 0x1F4FFFFF

  val rmsGammaBase: Long       = 0x1F500000L
  val rmsGammaSize: Long       = gammaCount.toLong * rowBytes // 0x21000, 132 KiB
  val rmsGammaEndInclusive: Long = rmsGammaBase + rmsGammaSize - 1 // 0x1F520FFF

  val attnBase: Long          = 0x20000000L
  val attnLayerStride: Long   = 0x00500000L // 5 MiB per layer
  val attnSize: Long          = nLayers.toLong * attnLayerStride // 80 MiB

  val ffnBase: Long           = 0x25000000L
  val ffnLayerStride: Long    = 0x01800000L // 24 MiB per layer
  val ffnSize: Long           = nLayers.toLong * ffnLayerStride // 384 MiB

  val kvBase: Long            = 0x3D000000L
  val kvLayerStride: Long     = 0x00200000L // 2 MiB per layer @ 1K
  val kvTokenStride: Long     = 0x00000800L // K 1 KiB + V 1 KiB per token
  val kvVecBytes: Long        = 0x00000400L // [8,64] FP16 = 1 KiB
  val kvSize: Long            = nLayers.toLong * kvLayerStride // 32 MiB

  val metaBase: Long          = 0x3F000000L
  val metaSize: Long          = 0x01000000L // 16 MiB

  val metaGlobalHeaderSize: Long = 0x1000L
  val metaAttnScaleBase: Long    = metaBase + 0x00001000L
  val metaFfnScaleBase: Long     = metaBase + 0x00200000L

  val extBase: Long           = 0x40000000L

  // ---------------------------------------------------------------------------
  // Attention sub-matrix offsets (within one layer)
  // ---------------------------------------------------------------------------

  val attnWQOffset: Long = 0x00000000L // 2 MiB INT4
  val attnWKOffset: Long = 0x00200000L // 512 KiB
  val attnWVOffset: Long = 0x00280000L // 512 KiB
  val attnWOOffset: Long = 0x00300000L // 2 MiB

  // ---------------------------------------------------------------------------
  // FFN sub-matrix offsets (within one layer)
  // ---------------------------------------------------------------------------

  val ffnGateOffset: Long = 0x00000000L // 8 MiB INT4
  val ffnUpOffset: Long   = 0x00800000L
  val ffnDownOffset: Long = 0x01000000L

  // ---------------------------------------------------------------------------
  // RMSNorm norm kind (matches scheduler / tuser normKind)
  // ---------------------------------------------------------------------------

  object NormKind {
    val norm1: Int     = 0 // input_layernorm
    val norm2: Int     = 1 // post_attention_layernorm
    val finalNorm: Int = 2 // model.norm

    def isValid(kind: Int): Boolean = kind >= norm1 && kind <= finalNorm
  }

  // ---------------------------------------------------------------------------
  // Token ID / embedding
  // ---------------------------------------------------------------------------

  def isValidTokenId(tokenId: Int): Boolean =
    tokenId >= 0 && tokenId < vocabSize

  /** `EMB_BASE + token_id * ROW_BYTES` */
  def embRowBase(tokenId: Int): Long = {
    require(isValidTokenId(tokenId), s"tokenId out of range: $tokenId (valid 0..${vocabSize - 1})")
    embBase + tokenId.toLong * rowBytes
  }

  /** Inclusive byte range `[embRowBase, embRowBase + rowBytes)`. */
  def embRowByteRange(tokenId: Int): (Long, Long) = {
    val base = embRowBase(tokenId)
    (base, base + rowBytes)
  }

  // ---------------------------------------------------------------------------
  // RMSNorm gamma
  // ---------------------------------------------------------------------------

  def isValidLayer(layer: Int): Boolean =
    layer >= 0 && layer < nLayers

  /**
   * Index into the contiguous γ table (0..32).
   * `normKind == finalNorm` ignores `layer` and returns 32.
   */
  def gammaIndex(layer: Int, normKind: Int): Int = {
    require(NormKind.isValid(normKind), s"invalid normKind: $normKind")
    if (normKind == NormKind.finalNorm) {
      gammaCount - 1
    } else {
      require(isValidLayer(layer), s"layer out of range: $layer (valid 0..${nLayers - 1})")
      layer * 2 + normKind
    }
  }

  /** `RMS_GAMMA_BASE + gamma_index * ROW_BYTES` */
  def gammaAddr(layer: Int, normKind: Int): Long =
    rmsGammaBase + gammaIndex(layer, normKind).toLong * rowBytes

  def gammaByteRange(layer: Int, normKind: Int): (Long, Long) = {
    val base = gammaAddr(layer, normKind)
    (base, base + rowBytes)
  }

  /** Bytes read from DDR for all 33 RMSNorm calls in one full token. */
  val rmsGammaBytesPerToken: Long = gammaCount.toLong * rowBytes // 132 KiB

  // ---------------------------------------------------------------------------
  // Attention weights
  // ---------------------------------------------------------------------------

  def attnLayerBase(layer: Int): Long = {
    require(isValidLayer(layer), s"layer out of range: $layer")
    attnBase + layer.toLong * attnLayerStride
  }

  def wQ(layer: Int): Long = attnLayerBase(layer) + attnWQOffset
  def wK(layer: Int): Long = attnLayerBase(layer) + attnWKOffset
  def wV(layer: Int): Long = attnLayerBase(layer) + attnWVOffset
  def wO(layer: Int): Long = attnLayerBase(layer) + attnWOOffset

  // ---------------------------------------------------------------------------
  // INT4 scale metadata (META_ATTN_SCALE_BASE)
  // ---------------------------------------------------------------------------

  /** FP16 scales per row for K=2048, group_size=128. */
  val int4GroupsPerRowK2048: Int = vectorDim / 128

  /** Bytes of one layer's attention scale table (W_Q + W_K + W_V + W_O). */
  val attnScaleBytesPerLayer: Long = 81920L * fp16Bytes

  /** Byte offset of W_Q scale sub-table for `layer` within `metaAttnScaleBase`. */
  def attnWqScaleBase(layer: Int): Long = {
    require(isValidLayer(layer), s"layer out of range: $layer")
    metaAttnScaleBase + layer.toLong * attnScaleBytesPerLayer
  }

  def attnWkScaleBase(layer: Int): Long =
    attnWqScaleBase(layer) + vectorDim.toLong * int4GroupsPerRowK2048 * fp16Bytes

  def attnWvScaleBase(layer: Int): Long =
    attnWkScaleBase(layer) + (vectorDim / 4).toLong * int4GroupsPerRowK2048 * fp16Bytes

  def attnWoScaleBase(layer: Int): Long =
    attnWvScaleBase(layer) + (vectorDim / 4).toLong * int4GroupsPerRowK2048 * fp16Bytes

  /** Total FP16 scale bytes for one GEMV Job (M rows × groups_per_row × 2). */
  def gemvScaleBytes(mRows: Int, groupsPerRow: Int = int4GroupsPerRowK2048): Long =
    mRows.toLong * groupsPerRow.toLong * fp16Bytes

  // ---------------------------------------------------------------------------
  // FFN weights
  // ---------------------------------------------------------------------------

  def ffnLayerBase(layer: Int): Long = {
    require(isValidLayer(layer), s"layer out of range: $layer")
    ffnBase + layer.toLong * ffnLayerStride
  }

  def gateProj(layer: Int): Long = ffnLayerBase(layer) + ffnGateOffset
  def upProj(layer: Int): Long   = ffnLayerBase(layer) + ffnUpOffset
  def downProj(layer: Int): Long = ffnLayerBase(layer) + ffnDownOffset

  // ---------------------------------------------------------------------------
  // KV cache (1K, FP16, token-major)
  // ---------------------------------------------------------------------------

  def isValidTokenPos(tokenPos: Int): Boolean =
    tokenPos >= 0 && tokenPos < maxContextLen

  def kvTokenBase(layer: Int, tokenPos: Int): Long = {
    require(isValidLayer(layer), s"layer out of range: $layer")
    require(isValidTokenPos(tokenPos), s"tokenPos out of range: $tokenPos (valid 0..${maxContextLen - 1})")
    kvBase + layer.toLong * kvLayerStride + tokenPos.toLong * kvTokenStride
  }

  def kAddr(layer: Int, tokenPos: Int): Long = kvTokenBase(layer, tokenPos)

  def vAddr(layer: Int, tokenPos: Int): Long = kvTokenBase(layer, tokenPos) + kvVecBytes

  // ---------------------------------------------------------------------------
  // Sanity (call from tests or REPL)
  // ---------------------------------------------------------------------------

  /** Throws `IllegalArgumentException` if documented spot-check addresses disagree. */
  def sanityCheck(): Unit = {
    assert(embSize == 0x1F500000L)
    assert(embEndInclusive == 0x1F4FFFFFL)
    assert(rmsGammaSize == 0x21000L)
    assert(rmsGammaEndInclusive == 0x1F520FFFL)
    assert(embRowBase(0) == 0x00000000L)
    assert(embRowBase(1) == 0x00001000L)
    assert(embRowBase(128255) == 0x1F4FF000L)
    assert(gammaAddr(0, NormKind.norm1) == 0x1F500000L)
    assert(gammaAddr(0, NormKind.norm2) == 0x1F501000L)
    assert(gammaAddr(7, NormKind.norm1) == 0x1F50E000L)
    assert(gammaAddr(0, NormKind.finalNorm) == 0x1F520000L)
    assert(gammaIndex(15, NormKind.norm2) == 31)
    assert(gammaIndex(0, NormKind.finalNorm) == 32)
    assert(attnLayerBase(0) == attnBase)
    assert(attnLayerBase(15) == attnBase + 15L * attnLayerStride)
    assert(wQ(0) == 0x20000000L)
    assert(attnWqScaleBase(0) == metaAttnScaleBase)
    assert(gemvScaleBytes(vectorDim) == 65536L)
    assert(ffnLayerBase(0) == ffnBase)
    assert(gateProj(3) == ffnBase + 3L * ffnLayerStride)
    assert(kvTokenBase(0, 0) == kvBase)
    assert(kAddr(5, 10) == kvBase + 5L * kvLayerStride + 10L * kvTokenStride)
    assert(vAddr(5, 10) == kAddr(5, 10) + kvVecBytes)
    assert(!isValidTokenId(128256))
    assert(isValidTokenId(128255))
  }
}
