package rmsNorm

import spinal.core._
import spinal.core.sim._
import util.{RmsNormAlteraIpSim, VerilatorSimCompat}

import scala.language.postfixOps
import scala.math.{abs, sqrt}
import scala.util.Random

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
  val xMin     = -32.0f
  val xMax     = 32.0f
  val gammaMin = 0.0f
  val gammaMax = 8.0f
  val vecSeed = sys.env.getOrElse("RMSNORM_SIM_SEED", "0xC0FFEE01").stripPrefix("0x").toLong.toInt
  val rng = new Random(vecSeed)

  def randVec(dim: Int, lo: Float, hi: Float): Array[Float] =
    Array.fill(dim)(rng.nextFloat() * (hi - lo) + lo)

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
      sqrSum_func = RmsNormAlteraIpSim.sqrSum,
      add_func = RmsNormAlteraIpSim.add,
      rsqrt_func = RmsNormAlteraIpSim.rsqrt
    )
  )

  cfg.doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.clockDomain.waitSampling(5)

    val x     = randVec(simDim, xMin, xMax)
    val gamma = randVec(simDim, gammaMin, gammaMax)
    println(
      f"RmsNormAxiTopSim random vectors seed=0x$vecSeed%08x x=[$xMin%.1f,$xMax%.1f] gamma=[$gammaMin%.1f,$gammaMax%.1f] " +
        f"x(0)=${x(0)}%.4f gamma(0)=${gamma(0)}%.4f"
    )
    val golden = goldenRmsNorm(x, gamma, eps)

    forkDataIn(dut, x, userContext = 0x123)
    forkWeightIn(dut, gamma)
    val received = consumeDataOut(dut, simDim)

    assert(received.length == simDim, s"expected $simDim outputs, got ${received.length}")

    val tol = 1e-3f
    var mismatches = 0
    var maxErr     = 0.0f
    for (i <- 0 until simDim) {
      val err = abs(received(i) - golden(i))
      if (err > maxErr) maxErr = err
      if (err > tol) mismatches += 1
    }

    println(f"RmsNormAxiTopSim dim=$simDim final check:")
    println(f"  tolerance:   $tol%.1e  (PASS when max abs err <= tolerance)")
    println(f"  max abs err: $maxErr%.8f")
    println(f"  mismatches:  $mismatches / $simDim  (output beats with err > tolerance)")
    if (maxErr <= tol) {
      println("\u001b[32m********** PASS **********\u001b[0m")
      simSuccess()
    } else {
      println("\u001b[31m********** FAIL **********\u001b[0m")
      simFailure(f"max abs err $maxErr%.8f > tolerance $tol%.1e ($mismatches/$simDim mismatches)")
    }
  }
}
