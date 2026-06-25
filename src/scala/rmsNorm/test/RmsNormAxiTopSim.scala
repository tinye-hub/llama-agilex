package rmsNorm

import spinal.core._
import spinal.core.sim._
import util.{RmsNormAlteraIpSim, VerilatorSimCompat}

import scala.language.postfixOps
import scala.util.Random

/**
 * Verilator smoke test for [[RmsNormAxiTop]] with [[util.RmsNormAlteraIpSim]] timing stubs.
 *
 * Verifies AXI-Stream handshake: dim beats in on dataIn/weightIn, dim beats out on dataOut
 * with `tlast` on the final beat.
 *
 * FP numerical accuracy is tested with Questa (`make questa`); stubs output 0 by design.
 */
object RmsNormAxiTopSim extends App {

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

  def consumeDataOut(dut: RmsNormAxiTop, dim: Int): Int = {
    var cnt       = 0
    var timeout   = 0
    var sawLast   = false
    val maxCycles = dim * 800
    dut.io.dataOut.ready #= true
    while (cnt < dim && timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      timeout += 1
      if (dut.io.dataOut.valid.toBoolean) {
        if (cnt == dim - 1) {
          assert(dut.io.dataOut.payload.last.toBoolean, "final output beat must have tlast=1")
          sawLast = true
        }
        cnt += 1
      }
    }
    assert(cnt == dim, s"timeout waiting for $dim output beats (got $cnt)")
    assert(sawLast, "did not observe tlast on final output beat")
    cnt
  }

  val simDim = sys.env.getOrElse("RMSNORM_SIM_DIM", "2048").toInt
  val xMin     = -32.0f
  val xMax     = 32.0f
  val gammaMin = 0.0f
  val gammaMax = 8.0f
  val vecSeed = {
    val s = sys.env.getOrElse("RMSNORM_SIM_SEED", "0xC0FFEE01").trim
    val hex = if (s.startsWith("0x") || s.startsWith("0X")) s.drop(2) else s
    java.lang.Long.parseLong(hex, 16).toInt
  }
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

    forkDataIn(dut, x, userContext = 0x123)
    forkWeightIn(dut, gamma)
    val beats = consumeDataOut(dut, simDim)

    println(f"RmsNormAxiTopSim dim=$simDim control-flow check: $beats/$simDim output beats, tlast OK")
    println("(FP golden: run make questa)")
    simSuccess()
  }
}
