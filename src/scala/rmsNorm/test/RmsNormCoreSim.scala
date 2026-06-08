package rmsNorm

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import util.{RmsNormAlteraIpSim, VerilatorSimCompat}

import scala.language.postfixOps
import scala.util.Random

/** Stream-level simulation of [[RmsNormCore]] (no AXI), shorter path for debug. */
object RmsNormCoreSim extends App {

  val simDim = sys.env.getOrElse("RMSNORM_SIM_DIM", "2048").toInt
  val xMin     = -32.0f
  val xMax     = 32.0f
  val gammaMin = 0.0f
  val gammaMax = 8.0f
  val vecSeed = sys.env.getOrElse("RMSNORM_SIM_SEED", "0xC0FFEE01").stripPrefix("0x").toLong.toInt
  val rng = new Random(vecSeed)

  def randVec(dim: Int, lo: Float, hi: Float): Array[Float] =
    Array.fill(dim)(rng.nextFloat() * (hi - lo) + lo)

  VerilatorSimCompat.withWDataCompat(
    SimConfig
      .withWave
      .workspacePath("rmsNorm/gen/sim/RmsNormCore")
  ).compile(
    RmsNormCore(
      dim = simDim,
      toFp32_func = RmsNormAlteraIpSim.toFp32,
      toFp16_func = RmsNormAlteraIpSim.toFp16,
      mul_func = RmsNormAlteraIpSim.mul,
      sqrSum_func = RmsNormAlteraIpSim.sqrSum,
      add_func = RmsNormAlteraIpSim.add,
      rsqrt_func = RmsNormAlteraIpSim.rsqrt
    )
  ).doSim { dut =>
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.waitSampling(5)

      val x = randVec(simDim, xMin, xMax)
      val g = randVec(simDim, gammaMin, gammaMax)
      println(
        f"RmsNormCoreSim random vectors seed=0x$vecSeed%08x x=[$xMin%.1f,$xMax%.1f] gamma=[$gammaMin%.1f,$gammaMax%.1f]"
      )

      fork {
        for (i <- 0 until simDim) {
          while (!dut.io.dataIn.ready.toBoolean) dut.clockDomain.waitSampling()
          dut.io.dataIn.valid #= true
          dut.io.dataIn.payload #= Fp16Sim.floatToBits(x(i))
          dut.clockDomain.waitSampling()
        }
        dut.io.dataIn.valid #= false
      }

      fork {
        for (i <- 0 until simDim) {
          while (!dut.io.weightIn.ready.toBoolean) dut.clockDomain.waitSampling()
          dut.io.weightIn.valid #= true
          dut.io.weightIn.payload #= Fp16Sim.floatToBits(g(i))
          dut.clockDomain.waitSampling()
        }
        dut.io.weightIn.valid #= false
      }

      dut.io.emitAllow #= true

      var cnt = 0
      while (cnt < simDim) {
        dut.clockDomain.waitSampling()
        if (dut.io.dataOut.valid.toBoolean) {
          cnt += 1
        }
      }
      println(s"RmsNormCoreSim dim=$simDim received $cnt beats")
      simSuccess()
    }
}
