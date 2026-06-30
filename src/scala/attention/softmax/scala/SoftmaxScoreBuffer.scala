package attention.softmax

import attention.common.AttentionGenerics
import spinal.core._
import spinal.lib._

/**
 * Single-port score/exp buffer with synchronous read (M20K registered output).
 *
 * `rdata` is valid one cycle after `raddr` is presented. Sync read lets Quartus
 * use the M20K output register, removing the async-read `uTco` + long combinational
 * path into the FP DSP (was the softmax setup-timing critical path).
 */
class SoftmaxScoreBuffer(g: AttentionGenerics) extends Component {
  val depth = g.maxSeqLen

  val io = new Bundle {
    val wen   = in Bool()
    val waddr = in UInt(g.idxWidth bits)
    val wdata = in Bits(16 bits)
    val raddr = in UInt(g.idxWidth bits)
    val rdata = out Bits(16 bits)
  }

  val mem = Mem(Bits(16 bits), depth)
  mem.addAttribute("ramstyle", "M20K")

  io.rdata := mem.readSync(io.raddr)
  when(io.wen) {
    mem.write(io.waddr, io.wdata)
  }
}
