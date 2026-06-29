package ddrAgent

import ddrMemoryMap.DdrMemoryMap
import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
import gemvService64.GemvGenerics
import util.VerilatorSimCompat

import scala.collection.mutable
import scala.language.postfixOps

/**
 * Verilator sim: [[DdrAgentM2]] — M1 row sinks + GEMV_WEIGHT 32 B tile reads.
 *
 * Preload: `tools/ddr_pack/out/ddr_fixture.bin` (or `DDR_IMAGE` env).
 * Run: `make verilator-m2a`
 */
object DdrAgentM2aSim extends App {

  val tileBytes = GemvGenerics().tileByteStride
  val axiWidth  = 256

  def pushMemCmd(
      dut: DdrAgentM2,
      sinkId: Int,
      ddrAddr: Long,
      byteLen: Long,
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
      dut: DdrAgentM2,
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

  def drainWeightBeat(dut: DdrAgentM2): BigInt = {
    dut.io.weightBeat.ready #= true
    var got = false
    var timeout = 0
    var beat = BigInt(0)
    while (!got && timeout < 50000) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if (dut.io.weightBeat.valid.toBoolean && dut.io.weightBeat.ready.toBoolean) {
        beat = dut.io.weightBeat.payload.toBigInt
        got = true
      }
    }
    dut.io.weightBeat.ready #= false
    assert(got, s"timeout waiting weightBeat (timeout=$timeout)")
    beat
  }

  def awaitMemDone(dut: DdrAgentM2, expectedSink: Int): Unit = {
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

  val simBase = SimConfig
    .workspacePath("ddrAgent/gen/sim/DdrAgentM2")
    .withConfig(SpinalConfig(targetDirectory = "ddrAgent/gen/sim/hw"))
  val cfg = VerilatorSimCompat.withWDataCompat(
    if (sys.env.getOrElse("VERILATOR_WAVE", "0") == "1") simBase.withWave else simBase
  ).compile(DdrAgentM2(axiCfg = DdrAgentAxi.config(dataWidth = axiWidth)))

  val rowBytes  = DdrMemoryMap.rowBytes.toInt
  val embedAddr = DdrMemoryMap.embRowBase(0)
  val gammaAddr = DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1)
  val wqBase    = DdrMemoryMap.wQ(0)
  val tileCount = 4

  cfg.doSim { dut =>
    dut.io.memCmd.valid #= false
    dut.io.memCmd.payload.cmdType #= MemCmdType.read
    dut.io.memCmd.payload.sinkId #= 0
    dut.io.memCmd.payload.byteLen #= 0
    dut.io.memCmd.payload.ddrAddr #= 0
    dut.io.memCmd.payload.tag #= 0
    dut.io.memCmd.payload.axisCtx #= 0
    dut.io.embedOut.ready #= false
    dut.io.gammaOut.ready #= false
    dut.io.weightBeat.ready #= false
    dut.io.memDone.ready #= false

    dut.clockDomain.forkStimulus(10)

    val mem = AxiMemorySim(dut.io.axi, dut.clockDomain, AxiMemorySimConfig())
    mem.start()
    mem.memory.writeArray(embedAddr, image.slice(embedAddr.toInt, embedAddr.toInt + rowBytes))
    mem.memory.writeArray(gammaAddr, image.slice(gammaAddr.toInt, gammaAddr.toInt + rowBytes))
    mem.memory.writeArray(wqBase, image.slice(wqBase.toInt, wqBase.toInt + tileCount * tileBytes))

    dut.io.embedOut.ready #= true
    dut.io.gammaOut.ready #= true

    dut.clockDomain.waitSampling(10)

    pushMemCmd(dut, DdrSinkId.embedRow, embedAddr, rowBytes, tag = 1, axisCtx = 0x0001)
    val recvEmbed = drainAxis(dut, "embed", dim)
    awaitMemDone(dut, DdrSinkId.embedRow)

    pushMemCmd(dut, DdrSinkId.rmsGamma, gammaAddr, rowBytes, tag = 2)
    val recvGamma = drainAxis(dut, "gamma", dim)
    awaitMemDone(dut, DdrSinkId.rmsGamma)

    var t = 0
    while (t < tileCount) {
      val addr = wqBase + t * tileBytes
      val golden = SimDdrImage.packAxiBeat(SimDdrImage.readBytes(image, addr, tileBytes), axiWidth)
      pushMemCmd(dut, DdrSinkId.gemvWeight, addr, tileBytes, tag = 10 + t)
      val got = drainWeightBeat(dut)
      awaitMemDone(dut, DdrSinkId.gemvWeight)
      assert(got == golden, f"tile $t @ 0x${addr}%x: got 0x${got.toString(16)} != golden 0x${golden.toString(16)}")
      t += 1
    }

    def check(got: Array[Int], golden: Array[Int], name: String): Unit = {
      var mism = 0
      var j = 0
      while (j < dim) {
        if (got(j) != golden(j)) mism += 1
        j += 1
      }
      println(f"DdrAgentM2aSim $name: mismatches=$mism/$dim")
      assert(mism == 0, s"$name: $mism FP16 bit mismatches vs DDR image")
    }

    check(recvEmbed, goldenEmbed, "embed")
    check(recvGamma, goldenGamma, "gamma")
    println(f"DdrAgentM2aSim gemv tiles: $tileCount/$tileCount OK")

    simSuccess()
  }
}
