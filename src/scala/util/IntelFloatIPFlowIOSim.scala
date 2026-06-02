package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Latency stub for simulation (no Quartus BlackBox).
 * Mirrors [[XilinxFloatIPFlowIOSim]].
 */
class IntelFloatIPFlowIOSim(
  val latency:      Int,
  val numOfOperand: Int,
  val inputWidth:   Int,
  val outputWidth:  Int,
  val isAcc:        Boolean = false
) extends Component {

  val io = new Bundle {
    val a = if (!isAcc && numOfOperand >= 1) slave(Flow(Bits(inputWidth bits))) else null
    val b = if (!isAcc && numOfOperand >= 2) slave(Flow(Bits(inputWidth bits))) else null
    val r = if (!isAcc) master(Flow(Bits(outputWidth bits))) else null

    val accIn  = if (isAcc) slave(Flow(Fragment(Bits(inputWidth bits)))) else null
    val accOut = if (isAcc) master(Flow(Fragment(Bits(outputWidth bits)))) else null
  }

  if (!isAcc && numOfOperand == 1) {
    io.r.valid := Delay(io.a.valid, latency, init = False)
    io.r.payload.clearAll()
  }
  if (!isAcc && numOfOperand == 2) {
    io.r.valid := Delay(io.a.valid && io.b.valid, latency, init = False)
    io.r.payload.clearAll()
  }
  if (isAcc) {
    io.accOut.valid := Delay(io.accIn.valid, latency, init = False)
    io.accOut.last  := Delay(io.accIn.last & io.accIn.valid, latency, init = False)
    io.accOut.fragment.clearAll()
  }
}

/** Stream multiply sim — delays `a.valid && b.valid` by latency. */
class IntelFloatIPStreamMulSim(val latency: Int) extends Component {
  val io = new Bundle {
    val a = slave(Stream(Bits(32 bits)))
    val b = slave(Stream(Bits(32 bits)))
    val r = master(Stream(Bits(32 bits)))
  }

  val fire = RegNext(io.a.valid && io.b.valid && io.a.ready && io.b.ready, False)
  io.a.ready := !io.r.valid || io.r.ready
  io.b.ready := io.a.ready
  io.r.valid   := Delay(fire, latency, init = False)
  io.r.payload.clearAll()
}
