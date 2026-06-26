package gemvService64

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * INT4 weight beat → 64 signed integers expressed as FP16 (design §6).
 *
 * One 256-bit DDR beat carries 64 nibbles (`pack_uint4_nibbles`, low nibble of
 * each byte first). Nibble `j` lives at bits `[j*4 +: 4]`. Symmetric INT4 maps
 * the stored UINT4 `0..15` to signed `-8..7` via `q_signed = nibble - 8`.
 *
 * This block is purely combinational: it converts each signed value to its
 * exact FP16 encoding through a 16-entry constant table (integers -8..7 are
 * all representable in FP16). The **group scale** is *not* applied here — it is
 * factored out and applied once per tile inside [[GemvMacBeat]], which is
 * cheaper than 64 per-lane multiplies and slightly more accurate.
 *
 * Output `wWide` lane `j` occupies bits `[j*16 +: 16]`, matching the ActBuffer
 * activation lane order so [[GemvMacBeat]] multiplies aligned operands.
 */
class Int4Unpack(g: GemvGenerics) extends Component {
  require(g.int4Width == 4, "Int4Unpack assumes 4-bit nibbles")

  val io = new Bundle {
    val weightBeat = in Bits (g.tileInt4Width bits)   // 256 bits = 64 nibbles
    val wWide      = out Bits (g.tileFp16Width bits)   // 1024 bits = 64 × FP16
  }

  /** FP16 encodings of the integers -8 .. 7, indexed by nibble (0..15). */
  val fp16Int: Vec[Bits] = Vec(
    Seq(
      0xC800, // -8
      0xC700, // -7
      0xC600, // -6
      0xC500, // -5
      0xC400, // -4
      0xC200, // -3
      0xC000, // -2
      0xBC00, // -1
      0x0000, //  0
      0x3C00, //  1
      0x4000, //  2
      0x4200, //  3
      0x4400, //  4
      0x4500, //  5
      0x4600, //  6
      0x4700  //  7
    ).map(v => B(v, g.fp16Width bits))
  )

  for (j <- 0 until g.bankLen) {
    val nibble = io.weightBeat(j * g.int4Width, g.int4Width bits).asUInt
    io.wWide(j * g.fp16Width, g.fp16Width bits) := fp16Int(nibble)
  }
}
