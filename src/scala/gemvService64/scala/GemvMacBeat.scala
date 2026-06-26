package gemvService64

import spinal.core._
import spinal.lib._
import util.{RmsNormAlteraIp, fp32MultAcc}

import scala.language.postfixOps

object GemvMacBeat {
  def apply(
    g: GemvGenerics,
    toFp32_func:   Flow[Bits] => Flow[Bits]                            = RmsNormAlteraIp.toFp32,
    toFp16_func:   Flow[Bits] => Flow[Bits]                            = RmsNormAlteraIp.toFp16,
    mul_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits]              = RmsNormAlteraIp.mul,
    add_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits]              = RmsNormAlteraIp.add,
    groupAcc_func: (Bool, Flow[Fragment[Bits]]) => Flow[Fragment[Bits]] = fp32MultAcc.firstAcc
  ): GemvMacBeat =
    new GemvMacBeat(g, toFp32_func, toFp16_func, mul_func, add_func, groupAcc_func)
}

/**
 * 64-wide FP16 MAC beat with FP32 adder tree, per-tile scale, and per-row
 * FP32 accumulation (design §2.6.3).
 *
 * Per beat:
 *   1. 64 FP16 activations (`xWide`) × 64 FP16 weights (`wWide`) → FP32 products
 *   2. balanced adder tree → one FP32 `tilePartial`
 *   3. `tilePartial × scaleFp32` (one scale multiply per tile, not per lane —
 *      INT4 dequant factors the group scale out of the inner product, which is
 *      both cheaper and slightly more accurate than scaling each weight)
 *   4. native-FP-DSP serial accumulate across the row's `tilesPerRow` tiles
 *   5. on the row's last tile (`beatLast`) the FP32 sum → FP16 → `rowOut`
 *
 * `scaleFp32` is sampled with the beat and delayed internally to align with the
 * adder-tree output, so callers present it combinationally alongside `xWide` /
 * `wWide`. For a pure FP16 MAC (no quantization) pass `scaleFp32 = 1.0`.
 *
 * Datapath is `Flow`-only (one beat/cycle, no backpressure), like the RMSNorm
 * EMIT path. Injected functions default to the real Quartus FP IPs; pass `*Sim`
 * variants for Verilator control-flow runs (same pipeline latencies).
 */
class GemvMacBeat(
  g: GemvGenerics,
  toFp32_func:   Flow[Bits] => Flow[Bits],
  toFp16_func:   Flow[Bits] => Flow[Bits],
  mul_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits],
  add_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits],
  groupAcc_func: (Bool, Flow[Fragment[Bits]]) => Flow[Fragment[Bits]],
  mulLatency: Int = 5,
  addLatency: Int = 3
) extends Component {

  val bankLen = g.bankLen
  val treeLevels = log2Up(bankLen)
  require((1 << treeLevels) == bankLen, s"bankLen ($bankLen) must be a power of two")
  val treeLatency = mulLatency + addLatency * treeLevels

  val io = new Bundle {
    /** Per-beat valid + 64×FP16 activation word + 64×FP16 weight word. */
    val beatValid = in Bool ()
    val xWide     = in Bits (g.tileFp16Width bits)
    val wWide     = in Bits (g.tileFp16Width bits)
    /** Group scale for this tile (FP32), sampled with the beat. */
    val scaleFp32 = in Bits (32 bits)
    /** High on the last tile of the current row (tile `tilesPerRow-1`). */
    val beatLast  = in Bool ()
    /** One FP16 result per row. */
    val rowOut    = master(Flow(Bits(g.fp16Width bits)))
  }

  // --- 64 lane multiplies: FP16 -> FP32 -> mul ---
  val prods = (0 until bankLen).map { j =>
    val xRaw = Flow(Bits(g.fp16Width bits))
    xRaw.valid   := io.beatValid
    xRaw.payload := io.xWide(j * g.fp16Width, g.fp16Width bits)

    val wRaw = Flow(Bits(g.fp16Width bits))
    wRaw.valid   := io.beatValid
    wRaw.payload := io.wWide(j * g.fp16Width, g.fp16Width bits)

    mul_func(toFp32_func(xRaw), toFp32_func(wRaw))
  }

  // --- balanced FP32 adder tree: 64 -> 1 ---
  def reduceTree(flows: Seq[Flow[Bits]]): Flow[Bits] = {
    if (flows.length == 1) flows.head
    else reduceTree(flows.grouped(2).toSeq.map {
      case Seq(a, b) => add_func(a, b)
      case Seq(a)    => a
    })
  }
  val treeOut = reduceTree(prods)

  // --- per-tile scale multiply (aligned to tree output) ---
  val scaleAligned = Flow(Bits(32 bits))
  scaleAligned.valid   := treeOut.valid
  scaleAligned.payload := Delay(io.scaleFp32, treeLatency)
  val tileScaled = mul_func(treeOut, scaleAligned)

  // --- per-row serial accumulate of the scaled tile partials ---
  // Track the first tile of each row so the accumulator starts a fresh sum even
  // when rows stream back-to-back (no inter-row gap). `firstTile` is the value
  // for the current beat; the next valid beat is "first" iff this one is "last".
  val firstTile = RegInit(True)
  when(io.beatValid) {
    firstTile := io.beatLast
  }

  val accLatency = treeLatency + mulLatency
  val partial = Flow(Fragment(Bits(32 bits)))
  partial.valid    := tileScaled.valid
  partial.fragment := tileScaled.payload
  partial.last     := Delay(io.beatValid && io.beatLast, accLatency, init = False)
  val partialFirst = Delay(io.beatValid && firstTile, accLatency, init = False)

  val accOut = groupAcc_func(partialFirst, partial)

  val rowSum = Flow(Bits(32 bits))
  rowSum.valid   := accOut.valid && accOut.last
  rowSum.payload := accOut.fragment

  io.rowOut << toFp16_func(rowSum)
}
