package top

import ddrMemoryMap.DdrMemoryMap
import ddrAgent.SimDdrImage
import llamaScheduler.HpsJobCtrl
import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
import spinal.lib.bus.amba4.axilite.sim.AxiLite4Driver
import util.VerilatorSimCompat

import scala.language.postfixOps

/**
 * M1 graduation test (Verilator, control-flow only).
 *
 * Verifies: AXI4-Lite job_start → Scheduler FSM → DdrAgent AXI read → RmsNormAxiTop pipeline →
 * 2048 rmsNormOut beats → job_done.
 *
 * NOTE: FP numerical accuracy is tested with Questa (`make questa`).
 * Verilator (`make verilator`) uses timing-only stubs; colored PASS/FAIL comes from
 * scripts/sbt-runmain.sh — see doc/simulation-conventions.md.
 *
 * Preload: `tools/ddr_pack/out/ddr_image_m1.bin` (or DDR_IMAGE env).
 */
object LlamaM1TopSim extends App {

  val regCtrl    = 0x00
  val regStatus  = 0x04
  val regTokenId = 0x08
  val regSeqPos  = 0x0C

  def axilWrite(hps: AxiLite4Driver, addr: Int, data: Int): Unit =
    hps.write(addr, data & 0xffffffffL)

  def axilRead(hps: AxiLite4Driver, addr: Int): Int =
    hps.read(addr).toInt

  def startJob(hps: AxiLite4Driver, tokenId: Int, seqPos: Int): Unit = {
    axilWrite(hps, regTokenId, tokenId)
    axilWrite(hps, regSeqPos, seqPos)
    axilWrite(hps, regCtrl, 1 << HpsJobCtrl.ctrlJobStart)
  }

  def awaitJobDone(hps: AxiLite4Driver, dut: LlamaM1Top, maxCycles: Int = 3000000): Unit = {
    var timeout = 0
    while (timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      timeout += 1
      val st = axilRead(hps, regStatus)
      if ((st & 0x2) != 0) return
    }
    assert(false, s"timeout waiting job_done after $maxCycles cycles")
  }

  /** Drain up to dim beats from rmsNormOut, stopping on tlast. Returns beat count. */
  def drainRmsNormOut(dut: LlamaM1Top, dim: Int): Int = {
    var beats     = 0
    var sawLast   = false
    var timeout   = 0
    val maxCycles = dim * 1000
    dut.io.rmsNormOut.ready #= true
    while (!sawLast && timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if (dut.io.rmsNormOut.valid.toBoolean) {
        beats += 1
        sawLast = dut.io.rmsNormOut.payload.last.toBoolean
      }
    }
    dut.io.rmsNormOut.ready #= false
    assert(sawLast, s"timeout waiting for rmsNormOut tlast after $timeout cycles (got $beats beats)")
    beats
  }

  val image    = SimDdrImage.load()
  val dim      = DdrMemoryMap.vectorDim
  val rowBytes = DdrMemoryMap.rowBytes.toInt

  val embedAddr = DdrMemoryMap.embRowBase(0)
  val gammaAddr = DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1)

  val g = LlamaM1Generics(dim = dim, useSimIp = true, axiDataWidth = 64)

  val cfg = VerilatorSimCompat.withWDataCompat(
    SimConfig
      .withWave
      .workspacePath("top/gen/sim/LlamaM1Top")
      .withConfig(SpinalConfig(targetDirectory = "top/gen/sim/hw"))
  ).compile(LlamaM1Top(g))

  cfg.doSim { dut =>
    dut.io.rmsNormOut.ready #= false
    dut.clockDomain.forkStimulus(10)

    val hps = AxiLite4Driver(dut.io.hps, dut.clockDomain)
    hps.reset()

    val mem = AxiMemorySim(dut.io.ddrAxi, dut.clockDomain, AxiMemorySimConfig())
    mem.start()
    mem.memory.writeArray(embedAddr, image.slice(embedAddr.toInt, embedAddr.toInt + rowBytes))
    mem.memory.writeArray(gammaAddr, image.slice(gammaAddr.toInt, gammaAddr.toInt + rowBytes))

    dut.clockDomain.waitSampling(10)

    // --- Test 1: happy path token_id=0, seq_pos=7 ---
    dut.io.rmsNormOut.ready #= true
    startJob(hps, tokenId = 0, seqPos = 7)

    val beats = drainRmsNormOut(dut, dim)
    assert(beats == dim, s"expected $dim output beats, got $beats")

    awaitJobDone(hps, dut)

    val st = axilRead(hps, regStatus)
    assert((st & 0x4) == 0, f"unexpected job_error on happy path (status=0x$st%08x)")
    println(f"LlamaM1TopSim test1 PASS: $beats beats received, job_done=1, job_error=0")

    // --- Test 2: OOB token_id = vocabSize (should error, no DDR read, no output) ---
    axilWrite(hps, regCtrl, 1 << HpsJobCtrl.ctrlSoftResetSched)
    dut.clockDomain.waitSampling(5)

    dut.io.rmsNormOut.ready #= true
    startJob(hps, tokenId = DdrMemoryMap.vocabSize, seqPos = 0)

    dut.clockDomain.waitSampling(20)

    val st2 = axilRead(hps, regStatus)
    assert((st2 & 0x4) != 0, f"expected job_error on OOB (status=0x$st2%08x)")

    val errCode = axilRead(hps, 0x1C)
    assert(errCode == HpsJobCtrl.errTokenIdOob, s"expected errCode=${HpsJobCtrl.errTokenIdOob}, got $errCode")
    assert(!dut.io.rmsNormOut.valid.toBoolean, "unexpected rmsNormOut.valid on OOB path")
    println(f"LlamaM1TopSim test2 PASS: OOB job_error=1, errorCode=$errCode")

    simSuccess()
  }
}
