package attention.softmax

import attention.common._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

/** AXI4-Stream wrapper around [[SoftmaxCore]] (Questa DUT / M2c integration). */
class SerialSafeSoftmaxAxiTop(
    g: AttentionGenerics = AttentionGenerics()
) extends Component {

  val axisCfg = AttentionAxisCfg()

  val io = new Bundle {
    val scoresIn   = slave(Axi4Stream(axisCfg))
    val weightsOut = master(Axi4Stream(axisCfg))
  }

  val core = new SoftmaxCore(
    g,
    SoftmaxAlteraIp.toFp32,
    SoftmaxAlteraIp.toFp16,
    SoftmaxAlteraIp.add,
    SoftmaxAlteraIp.mul,
    SoftmaxAlteraIp.exp,
    SoftmaxAlteraIp.div
  )

  val scoreStream = Stream(Fragment(Bits(16 bits)))
  val scoreValid  = RegInit(False)
  val scoreData   = Reg(Bits(16 bits))
  val scoreLast   = RegInit(False)

  io.scoresIn.ready := !scoreValid || scoreStream.ready
  val scoreStageFire = io.scoresIn.valid && (!scoreValid || scoreStream.ready)
  when(scoreStageFire) {
    scoreValid := True
    scoreData  := io.scoresIn.payload.data
    scoreLast  := io.scoresIn.payload.last
  }.elsewhen(scoreStream.fire) {
    scoreValid := False
  }
  scoreStream.valid    := scoreValid
  scoreStream.fragment := scoreData
  scoreStream.last     := scoreLast

  val inBeatCnt = Reg(UInt(g.lenWidth bits)) init (0)
  val userHold  = Reg(Bits(15 bits)) init (0)
  when(scoreStageFire) {
    when(inBeatCnt === 0) {
      userHold := io.scoresIn.payload.user(14 downto 0)
    }
    inBeatCnt := inBeatCnt + 1
    when(io.scoresIn.payload.last) {
      inBeatCnt := 0
    }
  }
  core.io.scoresUser := userHold

  core.io.scoresIn << scoreStream

  val outFifo = StreamFifo(
    dataType = Fragment(Bits(16 bits)),
    depth    = 16
  )

  val outPush = Stream(Fragment(Bits(16 bits)))
  outPush.valid    := core.io.weightsOut.valid
  outPush.fragment := core.io.weightsOut.fragment
  outPush.last     := core.io.weightsOut.last
  outFifo.io.push << outPush
  core.io.weightsOut.ready := outPush.ready

  val outBeatCnt = Reg(UInt(g.lenWidth bits)) init (0)
  when(outFifo.io.pop.fire) {
    outBeatCnt := outBeatCnt + 1
    when(outFifo.io.pop.payload.last) {
      outBeatCnt := 0
    }
  }

  val outLast = outFifo.io.pop.payload.last
  val outUser = Bits(16 bits)
  outUser(14 downto 0) := core.io.weightsUser
  outUser(15)          := !outLast

  io.weightsOut.valid        := outFifo.io.pop.valid
  io.weightsOut.payload.data := outFifo.io.pop.payload.fragment
  io.weightsOut.payload.keep.setAll()
  io.weightsOut.payload.last := outLast
  io.weightsOut.payload.user := outUser.resized
  outFifo.io.pop.ready       := io.weightsOut.ready
}

/** Generate synthesis Verilog into `attention/softmax/gen/verilog/`. */
object SoftmaxGen extends App {
  val maxSeqLen = sys.env.getOrElse("SOFTMAX_MAX_SEQ_LEN", "1025").toInt
  val outDir    = sys.env.getOrElse("SOFTMAX_GEN_DIR", "attention/softmax/gen/verilog")

  SpinalConfig(
    targetDirectory = outDir,
    oneFilePerComponent = false
  ).generateVerilog(new SerialSafeSoftmaxAxiTop(AttentionGenerics(maxSeqLen = maxSeqLen)))

  println(s"Generated $outDir/SerialSafeSoftmaxAxiTop.v (maxSeqLen=$maxSeqLen)")
}
