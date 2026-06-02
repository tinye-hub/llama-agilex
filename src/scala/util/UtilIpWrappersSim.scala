package util

import spinal.core._
import spinal.core.sim._
import spinal.lib._

import scala.language.postfixOps

/** Simulation handshake smoke test using `*_sim` stubs (no Quartus netlist). */
object UtilIpWrappersSim extends App {
  SimConfig.withWave.compile(new UtilIpWrappersSimDut).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.clockDomain.waitSampling(2)

    dut.io.a16.valid #= true
    dut.io.a16.payload #= 0x3C00
    dut.clockDomain.waitSampling(1)
    dut.io.a16.valid #= false

    dut.clockDomain.waitSampling(20)
    println("UtilIpWrappersSim finished")
    simSuccess()
  }
}

class UtilIpWrappersSimDut extends Component {
  val io = new Bundle {
    val a16 = in(Flow(Bits(16 bits)))
    val r16to32 = out(Flow(Bits(32 bits)))
  }

  io.r16to32 << RmsNormAlteraIpSim.toFp32(io.a16)
}
