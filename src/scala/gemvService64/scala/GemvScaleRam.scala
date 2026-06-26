package gemvService64

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * On-chip scale table for the current GEMV Job (design §7).
 *
 * The Scheduler preloads the whole scale sub-table (one FP16 scale per INT4
 * group) before `gemvStart` via a single DDR read; the GEMV hot path then only
 * reads this RAM (`groupIndex` → FP16 scale), never DDR per tile.
 *
 * Capacity is `maxRows × groupsPerRow` FP16 entries (W_Q: 2048 × 16 = 32768 =
 * 64 KiB). Scales arrive in `pack_scale_zero_table` order (group-major: row 0
 * groups 0..15, row 1 groups 0..15, ...).
 *
 * This is a plain write-pointer RAM: it always accepts `loadIn` beats, and the
 * write pointer is reset with `clear` between Jobs. Completion of the preload is
 * tracked upstream (Scheduler `MemDone`), not here — the number of scales per
 * Job (`M × groupsPerRow`) is only known after the Job is dispatched, so a
 * self-timed `loaded` flag cannot be derived from a fixed generic.
 */
class GemvScaleRam(g: GemvGenerics) extends Component {

  val depth = g.maxRows * g.groupsPerRow
  val addrW = log2Up(depth)
  val cntW  = log2Up(depth + 1)

  val io = new Bundle {
    /** Scale preload stream: one FP16 scale per beat, in group order. */
    val loadIn = slave(Stream(Bits(g.fp16Width bits)))
    /** Reset the write pointer to preload a new sub-table. */
    val clear  = in Bool ()
    /** Number of scales written since the last `clear` (debug / Scheduler). */
    val writeCount = out UInt (cntW bits)

    /** Combinational read: group index → FP16 scale. */
    val groupIndex = in UInt (addrW bits)
    val scaleFp16  = out Bits (g.fp16Width bits)
  }

  val mem = Mem(Bits(g.fp16Width bits), depth)

  val writePtr = Reg(UInt(cntW bits)) init (0)

  io.loadIn.ready := True

  mem.write(
    address = writePtr.resized,
    data    = io.loadIn.payload,
    enable  = io.loadIn.fire
  )

  when(io.loadIn.fire) {
    writePtr := writePtr + 1
  }
  when(io.clear) {
    writePtr := 0
  }

  io.writeCount := writePtr
  io.scaleFp16  := mem.readAsync(io.groupIndex)
}
