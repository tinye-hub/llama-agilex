package rmsNorm

import spinal.core._
import spinal.core.sim._
import util.{RmsNormAlteraIpSim, VerilatorSimCompat}

import scala.language.postfixOps
import scala.math.{abs, sqrt}

/**
 * Simulation for [[RmsNormAxiTop]] using latency stubs ([[util.RmsNormAlteraIpSim]]).
 *
 * Default `simDim = 2048` (Llama 3.2 1B vector length).
 */
object RmsNormAxiTopSim extends App {

  def goldenRmsNorm(x: Array[Float], gamma: Array[Float], eps: Double): Array[Float] = {
    val d     = x.length
    val sum   = x.map(v => v.toDouble * v).sum
    val scale = (1.0 / sqrt(sum / d + eps)).toFloat
    x.zip(gamma).map { case (xi, gi) => xi * scale * gi }
  }

  def forkDataIn(dut: RmsNormAxiTop, values: Array[Float], userContext: Int): Unit = {
    val dim = values.length
    fork {
      for (i <- 0 until dim) {
        while (!dut.io.dataIn.ready.toBoolean) dut.clockDomain.waitSampling()
        val isLast  = i == dim - 1
        val userVal = if (i == 0) userContext else 0
        dut.io.dataIn.valid #= true
        dut.io.dataIn.payload.data #= Fp16Sim.floatToBits(values(i))
        dut.io.dataIn.payload.last #= isLast
        dut.io.dataIn.payload.user #= userVal
        dut.clockDomain.waitSampling()
      }
      dut.io.dataIn.valid #= false
    }
  }

  def forkWeightIn(dut: RmsNormAxiTop, values: Array[Float]): Unit = {
    val dim = values.length
    fork {
      for (i <- 0 until dim) {
        while (!dut.io.weightIn.ready.toBoolean) dut.clockDomain.waitSampling()
        val isLast = i == dim - 1
        dut.io.weightIn.valid #= true
        dut.io.weightIn.payload.data #= Fp16Sim.floatToBits(values(i))
        dut.io.weightIn.payload.last #= isLast
        dut.io.weightIn.payload.user #= 0
        dut.clockDomain.waitSampling()
      }
      dut.io.weightIn.valid #= false
    }
  }

  def consumeDataOut(dut: RmsNormAxiTop, dim: Int): Array[Float] = {
    val out       = scala.collection.mutable.ArrayBuffer[Float]()
    var cnt       = 0
    var timeout   = 0
    val maxCycles = dim * 800
    dut.io.dataOut.ready #= true
    while (cnt < dim && timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if (dut.io.dataOut.valid.toBoolean) {
        out += Fp16Sim.bitsToFloat(dut.io.dataOut.payload.data.toInt)
        cnt += 1
      }
    }
    assert(cnt == dim, s"timeout waiting for $dim output beats (got $cnt)")
    out.toArray
  }

  val simDim = sys.env.getOrElse("RMSNORM_SIM_DIM", "2048").toInt
  val eps    = 1e-5

  val cfg = VerilatorSimCompat.withWDataCompat(
    SimConfig
      .withWave
      .workspacePath("rmsNorm/gen/sim/RmsNormAxiTop")
      .withConfig(SpinalConfig(targetDirectory = "rmsNorm/gen/sim/hw"))
  ).compile(
    RmsNormAxiTop(
      dim = simDim,
      toFp32_func = RmsNormAlteraIpSim.toFp32,
      toFp16_func = RmsNormAlteraIpSim.toFp16,
      mul_func = RmsNormAlteraIpSim.mul,
      mul_func_block = RmsNormAlteraIpSim.mulBlock,
      sqrSum_func = RmsNormAlteraIpSim.sqrSum,
      add_func = RmsNormAlteraIpSim.add,
      rsqrt_func = RmsNormAlteraIpSim.rsqrt
    )
  )

  cfg.doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.clockDomain.waitSampling(5)

    val x      = Array.tabulate(simDim)(i => (i + 1).toFloat * 0.25f)
    val gamma  = Array.tabulate(simDim)(i => 0.5f + (i + 1) * 0.125f)
    val golden = goldenRmsNorm(x, gamma, eps)

    forkDataIn(dut, x, userContext = 0x123)
    forkWeightIn(dut, gamma)
    val received = consumeDataOut(dut, simDim)

    assert(received.length == simDim, s"expected $simDim outputs, got ${received.length}")
    val maxErr = received.zip(golden).map { case (a, b) => abs(a - b) }.max
    println(f"RmsNormAxiTopSim dim=$simDim max abs err vs float ref = $maxErr%.6f")
  }
}
