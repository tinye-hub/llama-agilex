package top

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite._
import rmsNorm.{RmsNormAxiTop, RmsNormAxisCfg}
import util.{RmsNormAlteraIp, RmsNormAlteraIpSim}
import llamaScheduler.{HpsJobCtrl, LlamaSchedulerM2a}
import ddrAgent.{DdrAgentAxi, DdrAgentM2}
import gemvService64.{GemvAxisCfg, GemvService64}

/**
 * Milestone 2a PL top: M1 path + [[GemvService64]] L0 W_Q.
 *
 * ```text
 *   Scheduler ── MemCmd ──► DdrMemCmdArb ◄── tileFetch bridge ◄── Gemv
 *   DdrAgentM2 ── embed/gamma ──► RmsNorm ──fork──► actIn ──► Gemv
 *                    scaleOut ───────────────────────────────► scaleLoad
 *                    weightBeat ──────────────────────────────► weightBeat
 *   Gemv.qOut ──► io.qOut
 * ```
 */
class LlamaM2aTop(val g: LlamaM2aGenerics) extends Component {

  val axisCfg = RmsNormAxisCfg()
  val dim     = g.dim

  val io = new Bundle {
    val hps        = slave(AxiLite4(HpsJobCtrl.axiLiteConfig))
    val ddrAxi     = master(Axi4(DdrAgentAxi.config(dataWidth = g.axiDataWidth)))
    val rmsNormOut = master(Axi4Stream(axisCfg))
    val qOut       = master(Axi4Stream(GemvAxisCfg()))
  }

  val hpsCtrl = new HpsJobCtrl()
  hpsCtrl.io.axiLite <> io.hps

  val scheduler = new LlamaSchedulerM2a(g)
  scheduler.io.jobStart       := hpsCtrl.io.jobStart
  scheduler.io.jobAbort       := hpsCtrl.io.jobAbort
  scheduler.io.softResetSched := hpsCtrl.io.softResetSched
  scheduler.io.tokenId        := hpsCtrl.io.tokenId
  scheduler.io.seqPos         := hpsCtrl.io.seqPos
  scheduler.io.jobPhase       := hpsCtrl.io.jobPhase
  scheduler.io.promptLen      := hpsCtrl.io.promptLen

  hpsCtrl.io.busy            := scheduler.io.busy
  hpsCtrl.io.jobDoneSticky   := scheduler.io.jobDoneSticky
  hpsCtrl.io.jobErrorSticky  := scheduler.io.jobErrorSticky
  hpsCtrl.io.errorCode       := scheduler.io.errorCode
  hpsCtrl.io.schedStateDbg   := scheduler.io.schedStateDbg

  val ddrAgent = DdrAgentM2(axiCfg = DdrAgentAxi.config(dataWidth = g.axiDataWidth))

  val tileBridge = new DdrTileFetchBridge()
  val memArb     = new DdrMemCmdArb()

  scheduler.io.memCmd >> memArb.io.schedCmd
  tileBridge.io.memCmd >> memArb.io.gemvCmd
  memArb.io.memCmd >> ddrAgent.io.memCmd
  scheduler.io.memDone << ddrAgent.io.memDone
  ddrAgent.io.axi <> io.ddrAxi

  val rmsNorm = if (g.useSimIp) {
    RmsNormAxiTop(
      dim = dim,
      toFp32_func = RmsNormAlteraIpSim.toFp32,
      toFp16_func = RmsNormAlteraIpSim.toFp16,
      mul_func    = RmsNormAlteraIpSim.mul,
      sqrSum_func = RmsNormAlteraIpSim.sqrSum,
      add_func    = RmsNormAlteraIpSim.add,
      rsqrt_func  = RmsNormAlteraIpSim.rsqrt
    )
  } else {
    RmsNormAxiTop(dim = dim)
  }

  val gemv = if (g.useSimIp) {
    GemvService64(
      g.gemvG,
      toFp32_func   = RmsNormAlteraIpSim.toFp32,
      toFp16_func   = RmsNormAlteraIpSim.toFp16,
      mul_func      = RmsNormAlteraIpSim.mul,
      add_func      = RmsNormAlteraIpSim.add,
      groupAcc_func = util.fp32MultAcc.firstAcc_sim
    )
  } else {
    GemvService64(g.gemvG)
  }

  ddrAgent.io.embedOut >> rmsNorm.io.dataIn
  ddrAgent.io.gammaOut >> rmsNorm.io.weightIn

  val normFork = StreamFork(rmsNorm.io.dataOut, 2)
  normFork(0) >> io.rmsNormOut
  normFork(1) >> gemv.io.actIn

  ddrAgent.io.scaleOut >> gemv.io.scaleLoad
  ddrAgent.io.weightBeat >> gemv.io.weightBeat
  tileBridge.io.tileFetch << gemv.io.tileFetch

  scheduler.io.gemv <> gemv.io.ctrl

  scheduler.io.rmsNormOutLast := rmsNorm.io.dataOut.fire && rmsNorm.io.dataOut.payload.last

  gemv.io.qOut >> io.qOut
}

object LlamaM2aTop {
  def apply(g: LlamaM2aGenerics = LlamaM2aGenerics()): LlamaM2aTop = new LlamaM2aTop(g)
}
