package top

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite._
import rmsNorm.{RmsNormAxiTop, RmsNormAxisCfg}
import util.{RmsNormAlteraIp, RmsNormAlteraIpSim}
import llamaScheduler.{HpsJobCtrl, LlamaSchedulerM1}
import ddrAgent.{DdrAgentAxi, DdrAgentM1}

/**
 * Milestone 1 PL top: [[LlamaSchedulerM1]] + [[DdrAgentM1]] + [[RmsNormAxiTop]].
 *
 * ```text
 *   HPS (AXI4-Lite) ── HpsJobCtrl ── LlamaSchedulerM1 ── MemCmd ── DdrAgentM1
 *                                    │                embedOut ──┐
 *                                    │                gammaOut ─┼── RmsNormAxiTop ── rmsNormOut
 *                                    └── rmsNormOutLast ─────────┘
 * ```
 */
class LlamaM1Top(val g: LlamaM1Generics) extends Component {

  val axisCfg = RmsNormAxisCfg()
  val dim     = g.dim

  val io = new Bundle {
    val hps        = slave(AxiLite4(HpsJobCtrl.axiLiteConfig))
    val ddrAxi     = master(Axi4(DdrAgentAxi.config(dataWidth = g.axiDataWidth)))
    val rmsNormOut = master(Axi4Stream(axisCfg))
  }

  val hpsCtrl = new HpsJobCtrl()
  hpsCtrl.io.axiLite <> io.hps

  val scheduler = new LlamaSchedulerM1()
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

  val ddrAgent = DdrAgentM1(axiCfg = DdrAgentAxi.config(dataWidth = g.axiDataWidth))
  scheduler.io.memCmd  >> ddrAgent.io.memCmd
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

  ddrAgent.io.embedOut >> rmsNorm.io.dataIn
  ddrAgent.io.gammaOut >> rmsNorm.io.weightIn

  scheduler.io.rmsNormOutLast := rmsNorm.io.dataOut.fire && rmsNorm.io.dataOut.payload.last

  rmsNorm.io.dataOut >> io.rmsNormOut
}

object LlamaM1Top {
  def apply(g: LlamaM1Generics = LlamaM1Generics()): LlamaM1Top = new LlamaM1Top(g)
}
