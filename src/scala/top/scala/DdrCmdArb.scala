package top

import ddrAgent.{DdrSinkId, MemCmd, MemCmdType}
import gemvService64.TileFetchReq
import spinal.core._
import spinal.lib._

/** Convert `GemvService64.tileFetch` into `MemCmd(GEMV_WEIGHT)` for [[DdrAgentM2]]. */
class DdrTileFetchBridge extends Component {
  val io = new Bundle {
    val tileFetch = slave(Stream(TileFetchReq()))
    val memCmd    = master(Stream(MemCmd()))
  }

  io.memCmd.valid := io.tileFetch.valid
  io.tileFetch.ready := io.memCmd.ready

  io.memCmd.payload.cmdType := U(MemCmdType.read, 8 bits)
  io.memCmd.payload.sinkId  := U(DdrSinkId.gemvWeight, 8 bits)
  io.memCmd.payload.byteLen := io.tileFetch.payload.byteLen.resized
  io.memCmd.payload.ddrAddr := io.tileFetch.payload.ddrAddr
  io.memCmd.payload.tag     := io.tileFetch.payload.reqTag.resized
  io.memCmd.payload.axisCtx := B(0, 16 bits)
}

/** Priority arbiter: port 0 (Scheduler) wins over port 1 (GEMV tileFetch). */
class DdrMemCmdArb extends Component {
  val io = new Bundle {
    val schedCmd = slave(Stream(MemCmd()))
    val gemvCmd  = slave(Stream(MemCmd()))
    val memCmd   = master(Stream(MemCmd()))
  }

  val arb = StreamArbiterFactory.lowerFirst.build(MemCmd(), portCount = 2)
  io.schedCmd >> arb.io.inputs(0)
  io.gemvCmd  >> arb.io.inputs(1)
  arb.io.output >> io.memCmd
}
