package rmsNorm

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import util.RmsNormAlteraIpSim

import scala.language.postfixOps

/** Stream-level simulation of [[RmsNormCore]] (no AXI), shorter path for debug. */
object RmsNormCoreSim extends App {

  val simDim = sys.env.getOrElse("RMSNORM_SIM_DIM", "16").toInt

  SimConfig
    .withWave
    .workspacePath("gen/rmsNorm_core_sim")
    .compile(
      new RmsNormCore(
        dim = simDim,
        toFp32_func = RmsNormAlteraIpSim.toFp32,
        toFp16_func = RmsNormAlteraIpSim.toFp16,
        mul_func = RmsNormAlteraIpSim.mul,
        mul_func_block = RmsNormAlteraIpSim.mulBlock,
        acc_func = RmsNormAlteraIpSim.acc,
        add_func = RmsNormAlteraIpSim.add,
        rsqrt_func = RmsNormAlteraIpSim.rsqrt
      )
    )
    .doSim { dut =>
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.waitSampling(5)

      val x = Array.tabulate(simDim)(i => (i + 1).toFloat * 0.25f)
      val g = Array.fill(simDim)(1.0f)

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

      var cnt = 0
      dut.io.dataOut.ready #= true
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
