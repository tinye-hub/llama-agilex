package rope

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/** Precomputed cos/sin FP16 ROMs (offline table from [[RoPETableInit]]). */
class RoPECosSinRom(g: RoPEGenerics) extends Component {

  val romAddrW = log2Up(RoPETableInit.wordCount)

  val io = new Bundle {
    val seqPos = in UInt (g.posWidth bits)
    val dimIdx = in UInt (g.dimIdxWidth bits)
    val cosOut = out Bits (16 bits)
    val sinOut = out Bits (16 bits)
  }

  val addr = ((io.seqPos.resize(romAddrW) * U(g.headDim, romAddrW bits)) +
    io.dimIdx.resize(romAddrW)).resize(romAddrW)

  private def mkRom(bits: Array[Int]) = {
    val init = bits.map(b => B(b, 16 bits))
    Mem(Bits(16 bits), initialContent = init)
  }

  val cosRom = mkRom(RoPETableInit.cosBits)
  val sinRom = mkRom(RoPETableInit.sinBits)

  // Registered ROM read: 65536x16 infers wide mux; readSync meets 400 MHz vs readAsync.
  io.cosOut := cosRom.readSync(addr)
  io.sinOut := sinRom.readSync(addr)
}
