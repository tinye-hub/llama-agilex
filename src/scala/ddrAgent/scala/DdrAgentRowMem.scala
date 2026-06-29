package ddrAgent

import spinal.core._
import spinal.lib._

/**
 * Row staging buffer for DDR read → stream drain (4096 B = one embed/gamma row).
 *
 * One AXI beat per M20K entry (e.g. 32 B @ 256-bit AXI) with asynchronous read.
 */
class DdrAgentRowMem(val beatBytes: Int, val rowBytes: Int) extends Area {
  require(rowBytes > 0 && beatBytes > 0 && rowBytes % beatBytes == 0)

  val beatBytesW = log2Up(beatBytes)
  val rowDepth   = rowBytes / beatBytes
  val addrW      = log2Up(rowDepth)
  val beatWidth  = beatBytes * 8
  val slotsPerBeat = beatBytes / 2
  val slotW        = log2Up(slotsPerBeat)

  private val mem = Mem(Bits(beatWidth bits), rowDepth)
  mem.addAttribute("ramstyle", "M20K")

  def writeBeat(beatIdx: UInt, data: Bits, enable: Bool): Unit =
    mem.write(beatIdx.resize(addrW), data, enable = enable)

  def readBeat(beatIdx: UInt): Bits =
    mem.readAsync(beatIdx.resize(addrW))

  def beatIndexForStreamBeat(streamBeat: UInt): UInt =
    (streamBeat >> slotW).resize(addrW)

  def slotInBeat(streamBeat: UInt): UInt =
    streamBeat(slotW - 1 downto 0)

  def fp16AtStreamBeat(beatWord: Bits, streamBeat: UInt): Bits = {
    val slots = Vec(
      for (s <- 0 until slotsPerBeat)
        yield beatWord((s * 16 + 15) downto (s * 16))
    )
    slots.read(slotInBeat(streamBeat))
  }
}
