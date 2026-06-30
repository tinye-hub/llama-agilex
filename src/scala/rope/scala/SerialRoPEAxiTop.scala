package rope

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

/** AXI-stream wrapper for [[SerialRoPE]] (Questa / top integration). */
class SerialRoPEAxiTop(
    g: RoPEGenerics = RoPEGenerics(),
    useSimIp: Boolean = false
) extends Component {

  val axisCfg = RoPEAxisCfg()

  val io = new Bundle {
    val seqPos  = in UInt (g.posWidth bits)
    val dataIn  = slave(Axi4Stream(axisCfg))
    val dataOut = master(Axi4Stream(axisCfg))
  }

  val mul: (Flow[Bits], Flow[Bits]) => Flow[Bits] =
    if (useSimIp) RoPEAlteraIp.mulFp16_sim _ else RoPEAlteraIp.mulFp16Fn _
  val add: (Flow[Bits], Flow[Bits]) => Flow[Bits] =
    if (useSimIp) RoPEAlteraIp.addFp16_sim _ else RoPEAlteraIp.addFp16Fn _

  val core = new SerialRoPE(g, mul, add)
  core.io.seqPos := io.seqPos
  core.io.dataIn << io.dataIn
  io.dataOut << core.io.dataOut
}

/** Generate synthesis Verilog into `rope/gen/verilog/`. */
object RopeGen extends App {
  val headDim = sys.env.getOrElse("ROPE_HEAD_DIM", RoPETableInit.headDim.toString).toInt
  val maxPos  = sys.env.getOrElse("ROPE_MAX_POS", RoPETableInit.maxPos.toString).toInt
  val outDir  = sys.env.getOrElse("ROPE_GEN_DIR", "rope/gen/verilog")
  val simIp   = sys.env.getOrElse("ROPE_SIM_IP", "0") == "1"

  val g = RoPEGenerics(headDim = headDim, maxPos = maxPos)

  SpinalConfig(
    targetDirectory = outDir,
    oneFilePerComponent = false,
    inlineRom = true
  ).generateVerilog(new SerialRoPEAxiTop(g, useSimIp = simIp))

  println(s"Generated $outDir/SerialRoPEAxiTop.v (headDim=$headDim, maxPos=$maxPos, simIp=$simIp)")
}
