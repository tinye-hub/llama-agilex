package ddrAgent

import common.DdrMemoryMap
import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
import rmsNorm.Fp16Sim
import util.VerilatorSimCompat

import scala.collection.mutable
import scala.language.postfixOps

/**
 * Verilator sim: [[DdrAgentM1]] + file-backed AXI4 DDR slave.
 *
 * Preload: `tools/ddr_pack/out/ddr_image_m1.bin` (or `DDR_IMAGE` env).
 */
object DdrAgentM1Sim extends App {

  def pushMemCmd(
      dut: DdrAgentM1,
      sinkId: Int,
      ddrAddr: Long,
      byteLen: Long = DdrMemoryMap.rowBytes,
      tag: Int = 0,
      axisCtx: Int = 0
  ): Unit = {
    dut.io.memCmd.valid #= true
    dut.io.memCmd.payload.cmdType #= MemCmdType.read
    dut.io.memCmd.payload.sinkId #= sinkId
    dut.io.memCmd.payload.byteLen #= byteLen
    dut.io.memCmd.payload.ddrAddr #= ddrAddr
    dut.io.memCmd.payload.tag #= tag
    dut.io.memCmd.payload.axisCtx #= axisCtx
    while (!dut.io.memCmd.ready.toBoolean) dut.clockDomain.waitSampling()
    dut.clockDomain.waitSampling()
    dut.io.memCmd.valid #= false
  }

  def drainAxis(
      dut: DdrAgentM1,
      which: String,
      expectedBeats: Int
  ): Array[Int] = {
    val out = mutable.ArrayBuffer[Int]()
    val getValid = which match {
      case "embed" => () => dut.io.embedOut.valid.toBoolean
      case "gamma" => () => dut.io.gammaOut.valid.toBoolean
      case other   => throw new IllegalArgumentException(s"unknown stream $other")
    }
    val getData = which match {
      case "embed" => () => dut.io.embedOut.payload.data.toInt
      case "gamma" => () => dut.io.gammaOut.payload.data.toInt
    }
    val setReady = (v: Boolean) =>
      which match {
        case "embed" => dut.io.embedOut.ready #= v
        case "gamma" => dut.io.gammaOut.ready #= v
      }

    setReady(true)
    var beats = 0
    var timeout = 0
    val maxCycles = expectedBeats * 200
    while (beats < expectedBeats && timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if ((which == "embed" && getValid() && dut.io.embedOut.ready.toBoolean) ||
          (which == "gamma" && getValid() && dut.io.gammaOut.ready.toBoolean)) {
        out += getData() & 0xffff
        beats += 1
      }
    }
    setReady(false)
    assert(beats == expectedBeats, s"$which: expected $expectedBeats beats, got $beats (timeout=$timeout)")
    out.toArray
  }

  def awaitMemDone(dut: DdrAgentM1, expectedSink: Int): Unit = {
    var got = false
    var timeout = 0
    dut.io.memDone.ready #= true
    while (!got && timeout < 500000) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if (dut.io.memDone.valid.toBoolean) {
        assert(dut.io.memDone.payload.sinkId.toInt == expectedSink,
          s"MemDone sink ${dut.io.memDone.payload.sinkId.toInt} != $expectedSink")
        got = true
      }
    }
    dut.io.memDone.ready #= false
    assert(got, s"timeout waiting MemDone sink=$expectedSink")
  }

  val image = SimDdrImage.load()
  val dim   = DdrMemoryMap.vectorDim

  val goldenEmbed = SimDdrImage.rowFp16Bits(image, DdrMemoryMap.embRowBase(0), dim)
  val goldenGamma = SimDdrImage.rowFp16Bits(image, DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1), dim)

  val cfg = VerilatorSimCompat.withWDataCompat(
    SimConfig
      .withWave
      .workspacePath("ddrAgent/gen/sim/DdrAgentM1")
      .withConfig(SpinalConfig(targetDirectory = "ddrAgent/gen/sim/hw"))
  ).compile(DdrAgentM1(axiCfg = DdrAgentAxi.config(dataWidth = 64)))

  val rowBytes  = DdrMemoryMap.rowBytes.toInt
  val embedAddr = DdrMemoryMap.embRowBase(0)
  val gammaAddr = DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1)

  cfg.doSim { dut =>
    // Initialize ALL DUT inputs before the clock runs. Otherwise Verilator drives
    // memCmd.valid with a random value at t=0, the cmd FIFO latches a garbage command,
    // and the DUT issues an AXI read to a bogus address (root cause of the flaky sim).
    dut.io.memCmd.valid #= false
    dut.io.memCmd.payload.cmdType #= MemCmdType.read
    dut.io.memCmd.payload.sinkId #= 0
    dut.io.memCmd.payload.byteLen #= 0
    dut.io.memCmd.payload.ddrAddr #= 0
    dut.io.memCmd.payload.tag #= 0
    dut.io.memCmd.payload.axisCtx #= 0
    dut.io.embedOut.ready #= false
    dut.io.gammaOut.ready #= false
    dut.io.memDone.ready  #= false

    dut.clockDomain.forkStimulus(10)

    // Official SpinalHDL AXI4 read slave model (deterministic, no hand-rolled fork race).
    val mem = AxiMemorySim(dut.io.axi, dut.clockDomain, AxiMemorySimConfig())
    mem.start()
    mem.memory.writeArray(embedAddr, image.slice(embedAddr.toInt, embedAddr.toInt + rowBytes))
    mem.memory.writeArray(gammaAddr, image.slice(gammaAddr.toInt, gammaAddr.toInt + rowBytes))

    dut.io.embedOut.ready #= true
    dut.io.gammaOut.ready #= true

    dut.clockDomain.waitSampling(10)

    pushMemCmd(dut, DdrSinkId.embedRow, embedAddr, tag = 1, axisCtx = 0x0001)
    val recvEmbed = drainAxis(dut, "embed", dim)
    awaitMemDone(dut, DdrSinkId.embedRow)

    pushMemCmd(dut, DdrSinkId.rmsGamma, gammaAddr, tag = 2)
    val recvGamma = drainAxis(dut, "gamma", dim)
    awaitMemDone(dut, DdrSinkId.rmsGamma)

    def check(got: Array[Int], golden: Array[Int], name: String): Unit = {
      var mism = 0
      var maxErr = 0.0f
      var j = 0
      while (j < dim) {
        val g = Fp16Sim.bitsToFloat(golden(j))
        val r = Fp16Sim.bitsToFloat(got(j))
        val err = math.abs(r - g)
        if (err > maxErr) maxErr = err
        if (got(j) != golden(j)) mism += 1
        j += 1
      }
      println(f"DdrAgentM1Sim $name: mismatches=$mism/$dim maxFpErr=$maxErr%.6f")
      assert(mism == 0, s"$name: $mism FP16 bit mismatches vs DDR image")
    }

    check(recvEmbed, goldenEmbed, "embed")
    check(recvGamma, goldenGamma, "gamma")

    println("\u001b[32m********** PASS **********\u001b[0m")
    simSuccess()
  }
}
