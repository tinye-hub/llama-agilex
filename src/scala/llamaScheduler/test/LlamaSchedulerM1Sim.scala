package llamaScheduler

import ddrMemoryMap.DdrMemoryMap
import ddrAgent.{DdrSinkId, MemCmdType}
import spinal.core._
import spinal.core.sim._
import util.VerilatorSimCompat

import scala.collection.mutable
import scala.language.postfixOps

/**
 * Isolated [[LlamaSchedulerM1]] sim with mock MemCmd sink / MemDone source.
 * Validates MemCmd sequencing, axis_ctx, token_id OOB, and FSM completion.
 */
object LlamaSchedulerM1Sim extends App {

  case class CapturedCmd(
      sinkId: Int,
      ddrAddr: Long,
      byteLen: Long,
      axisCtx: Int
  )

  def initDut(dut: LlamaSchedulerM1): Unit = {
    dut.io.jobStart #= false
    dut.io.jobAbort #= false
    dut.io.softResetSched #= false
    dut.io.tokenId #= 0
    dut.io.seqPos #= 0
    dut.io.jobPhase #= 0
    dut.io.promptLen #= 0
    dut.io.memCmd.ready #= true
    dut.io.memDone.valid #= false
    dut.io.memDone.payload.tag #= 0
    dut.io.memDone.payload.error #= 0
    dut.io.memDone.payload.sinkId #= 0
    dut.io.rmsNormOutLast #= false
  }

  def pulseJobStart(
      dut: LlamaSchedulerM1,
      tokenId: Int,
      seqPos: Int = 0
  ): Unit = {
    dut.io.tokenId #= tokenId
    dut.io.seqPos #= seqPos
    dut.clockDomain.waitSampling()
    dut.io.jobStart #= true
    dut.clockDomain.waitSampling()
    dut.io.jobStart #= false
  }

  def captureMemCmds(
      dut: LlamaSchedulerM1,
      expected: Int,
      maxCycles: Int = 200
  ): Seq[CapturedCmd] = {
    val out = mutable.ArrayBuffer[CapturedCmd]()
    var timeout = 0
    while (out.size < expected && timeout < maxCycles) {
      if (dut.io.memCmd.valid.toBoolean && dut.io.memCmd.ready.toBoolean) {
        val p = dut.io.memCmd.payload
        assert(p.cmdType.toInt == MemCmdType.read, s"cmdType=${p.cmdType.toInt}")
        out += CapturedCmd(
          sinkId  = p.sinkId.toInt,
          ddrAddr = p.ddrAddr.toLong,
          byteLen = p.byteLen.toLong,
          axisCtx = p.axisCtx.toInt
        )
      }
      dut.clockDomain.waitSampling()
      timeout += 1
    }
    assert(out.size == expected, s"expected $expected MemCmd(s), got ${out.size} (timeout=$timeout)")
    out.toSeq
  }

  def driveMemDones(dut: LlamaSchedulerM1, count: Int): Unit = {
    var done = 0
    while (done < count) {
      dut.clockDomain.waitSampling()
      if (dut.io.memDone.ready.toBoolean) {
        dut.io.memDone.valid #= true
        dut.io.memDone.payload.sinkId #= done
        dut.clockDomain.waitSampling()
        dut.io.memDone.valid #= false
        done += 1
      }
    }
  }

  def awaitSchedState(dut: LlamaSchedulerM1, expected: Int, maxCycles: Int = 500): Unit = {
    var timeout = 0
    while (timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if (dut.io.schedStateDbg.toInt == expected) return
    }
    assert(false, s"timeout waiting schedStateDbg=$expected (got ${dut.io.schedStateDbg.toInt})")
  }

  val cfg = VerilatorSimCompat.withWDataCompat(
    SimConfig
      .withWave
      .workspacePath("llamaScheduler/gen/sim/LlamaSchedulerM1")
      .withConfig(SpinalConfig(targetDirectory = "llamaScheduler/gen/sim/hw"))
  ).compile(new LlamaSchedulerM1())

  cfg.doSim { dut =>
    initDut(dut)
    dut.clockDomain.forkStimulus(10)
    dut.clockDomain.waitSampling(5)

    // --- Happy path: token_id=0, seqPos=42 ---
    val seqPos = 42
    pulseJobStart(dut, tokenId = 0, seqPos = seqPos)

    val cmds = captureMemCmds(dut, expected = 2)
    assert(cmds(0).sinkId == DdrSinkId.embedRow)
    assert(cmds(0).ddrAddr == DdrMemoryMap.embRowBase(0))
    assert(cmds(0).byteLen == DdrMemoryMap.rowBytes)
    assert(cmds(1).sinkId == DdrSinkId.rmsGamma)
    assert(cmds(1).ddrAddr == DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1))
    assert(cmds(1).byteLen == DdrMemoryMap.rowBytes)

    val expectedCtx = (DdrMemoryMap.NormKind.norm1 << 9) | seqPos
    assert(cmds(0).axisCtx == expectedCtx, s"axis_ctx embed: ${cmds(0).axisCtx} != $expectedCtx")
    assert(cmds(1).axisCtx == expectedCtx, s"axis_ctx gamma: ${cmds(1).axisCtx} != $expectedCtx")

    driveMemDones(dut, count = 2)
    awaitSchedState(dut, expected = 3) // WAIT_RMSNORM

    dut.io.rmsNormOutLast #= true
    dut.clockDomain.waitSampling()
    dut.io.rmsNormOutLast #= false
    awaitSchedState(dut, expected = 4) // JOB_DONE
    assert(dut.io.jobDoneSticky.toBoolean, "job_done")
    assert(!dut.io.jobErrorSticky.toBoolean, "no job_error")

    dut.io.jobStart #= false
    dut.clockDomain.waitSampling()
    awaitSchedState(dut, expected = 0) // IDLE

    // --- OOB path: token_id = vocabSize ---
    pulseJobStart(dut, tokenId = DdrMemoryMap.vocabSize)
    dut.clockDomain.waitSampling()
    assert(dut.io.jobErrorSticky.toBoolean, "job_error on OOB")
    assert(dut.io.errorCode.toInt == HpsJobCtrl.errTokenIdOob)
    assert(dut.io.schedStateDbg.toInt == 4, "JOB_DONE on OOB")
    assert(!dut.io.memCmd.valid.toBoolean, "no MemCmd on OOB")

    dut.io.jobStart #= false
    dut.clockDomain.waitSampling()
    awaitSchedState(dut, expected = 0)

    simSuccess()
  }
}
