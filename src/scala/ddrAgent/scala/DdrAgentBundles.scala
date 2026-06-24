package ddrAgent

import spinal.core._
import spinal.lib._

/** DDR read / write command (Scheduler → DdrAgent). See ddr-agent-design.md */
case class MemCmd() extends Bundle {
  val cmdType = UInt(8 bits)  // 0=READ, 1=WRITE
  val sinkId  = UInt(8 bits)
  val byteLen = UInt(32 bits)
  val ddrAddr = UInt(32 bits)
  val tag     = UInt(32 bits)
  val axisCtx = Bits(16 bits)
}

case class MemDone() extends Bundle {
  val tag    = UInt(32 bits)
  val error  = UInt(8 bits)
  val sinkId = UInt(8 bits)
}

object DdrSinkId {
  val embedRow   = 0
  val rmsGamma   = 1
  val gemvWeight = 2
}

object MemCmdType {
  val read  = 0
  val write = 1
}
