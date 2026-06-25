package ddrAgent

import ddrMemoryMap.DdrMemoryMap
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import spinal.lib.bus.amba4.axi._
import rmsNorm.RmsNormAxisCfg

/**
 * Milestone 1 DDR agent: [[MemCmd]] read → AXI4 burst → 2048-beat AXI-Stream sink.
 *
 * Supports `EMBED_ROW` and `RMS_GAMMA` sinks (4096 B row each). Commands are queued;
 * AXI reads and stream drain run sequentially per command (parallel outstanding TBD).
 */
object DdrAgentM1 {
  object State extends SpinalEnum {
    val IDLE, AXI_AR, AXI_R, STREAM, DONE = newElement()
  }

  def apply(axiCfg: Axi4Config = DdrAgentAxi.config()): DdrAgentM1 = new DdrAgentM1(axiCfg)
}

class DdrAgentM1(axiCfg: Axi4Config = DdrAgentAxi.config()) extends Component {

  val axisCfg   = RmsNormAxisCfg()
  val axiConfig = axiCfg
  val rowBytes  = DdrMemoryMap.rowBytes.toInt
  val beatCount = DdrMemoryMap.vectorDim
  val beatBytes = DdrAgentAxi.dataBytesOf(axiConfig)
  val burstBytes = DdrAgentAxi.burstBytes
  val burstBeats = DdrAgentAxi.burstBeatsOf(axiConfig)

  val io = new Bundle {
    val memCmd   = slave(Stream(MemCmd()))
    val memDone  = master(Stream(MemDone()))
    val embedOut = master(Axi4Stream(axisCfg))
    val gammaOut = master(Axi4Stream(axisCfg))
    val axi      = master(Axi4(axiConfig))
  }

  import DdrAgentM1.State

  val cmdFifo = StreamFifo(MemCmd(), depth = 8)
  io.memCmd >> cmdFifo.io.push

  val state      = RegInit(State.IDLE)
  val ddrAddr    = Reg(UInt(32 bits))
  val byteLen    = Reg(UInt(32 bits))
  val sinkId     = Reg(UInt(8 bits))
  val tag        = Reg(UInt(32 bits))
  val axisCtx    = Reg(Bits(16 bits))

  val bytesRead  = Reg(UInt(16 bits)) init (0)
  val burstAddr  = Reg(UInt(32 bits))
  val streamBeat = Reg(UInt(11 bits)) init (0)

  val rowMem = Vec(Reg(Bits(8 bits)) init (0), rowBytes)

  val cmdPop = cmdFifo.io.pop
  cmdPop.ready := False

  // ---------------------------------------------------------------------------
  // AXI read-only master tie-offs
  // ---------------------------------------------------------------------------
  io.axi.aw.valid := False
  io.axi.aw.payload.assignDontCare()
  io.axi.w.valid  := False
  io.axi.w.payload.assignDontCare()
  io.axi.b.ready  := False

  io.axi.ar.valid       := False
  io.axi.ar.payload.assignDontCare()
  io.axi.r.ready        := False

  // ---------------------------------------------------------------------------
  // Command + read FSM
  // ---------------------------------------------------------------------------
  switch(state) {
    is(State.IDLE) {
      when(cmdPop.valid) {
        cmdPop.ready := True
        ddrAddr  := cmdPop.payload.ddrAddr
        byteLen  := cmdPop.payload.byteLen
        sinkId   := cmdPop.payload.sinkId
        tag      := cmdPop.payload.tag
        axisCtx  := cmdPop.payload.axisCtx
        bytesRead := 0
        burstAddr := cmdPop.payload.ddrAddr
        streamBeat := 0
        state := State.AXI_AR
      }
    }

    is(State.AXI_AR) {
      io.axi.ar.valid := True
      io.axi.ar.payload.addr  := burstAddr
      io.axi.ar.payload.len   := U(burstBeats - 1, 8 bits)
      io.axi.ar.payload.size  := U(log2Up(beatBytes), 3 bits)
      io.axi.ar.payload.burst := Axi4.burst.INCR
      io.axi.ar.payload.id    := 0
      when(io.axi.ar.fire) {
        state := State.AXI_R
      }
    }

    is(State.AXI_R) {
      io.axi.r.ready := True
      when(io.axi.r.fire) {
        val base = bytesRead
        for (i <- 0 until beatBytes) {
          rowMem((base + U(i, base.getWidth bits)).resized) := io.axi.r.payload.data(i * 8 + 7 downto i * 8)
        }
        val nextBytes = bytesRead + U(beatBytes, bytesRead.getWidth bits)
        bytesRead := nextBytes

        when(io.axi.r.payload.last) {
          when(nextBytes >= byteLen.resized) {
            state := State.STREAM
          } otherwise {
            burstAddr := burstAddr + U(burstBytes, 32 bits)
            state := State.AXI_AR
          }
        }
      }
    }

    is(State.STREAM) {
      // beat output handled below
    }

    is(State.DONE) {
      when(io.memDone.fire) {
        state := State.IDLE
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Row → AXI-Stream (2048 × FP16, little-endian)
  // ---------------------------------------------------------------------------
  val memReadAddr = streamBeat
  val byteLo = rowMem((memReadAddr << 1).resized)
  val byteHi = rowMem(((memReadAddr << 1) + U(1, memReadAddr.getWidth bits)).resized)

  val isEmbed = sinkId === U(DdrSinkId.embedRow, 8 bits)
  val isGamma = sinkId === U(DdrSinkId.rmsGamma, 8 bits)
  val isLast  = streamBeat === U(beatCount - 1, streamBeat.getWidth bits)

  val streamValid = state === State.STREAM
  val streamData  = byteHi ## byteLo

  val tuser = Bits(16 bits)
  tuser := axisCtx
  tuser(15) := !isLast

  io.embedOut.valid := streamValid && isEmbed
  io.embedOut.payload.data := streamData
  io.embedOut.payload.last := isLast
  io.embedOut.payload.user   := tuser.resized
  if (axisCfg.useKeep) io.embedOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1

  io.gammaOut.valid := streamValid && isGamma
  io.gammaOut.payload.data := streamData
  io.gammaOut.payload.last := isLast
  io.gammaOut.payload.user   := tuser.resized
  if (axisCfg.useKeep) io.gammaOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1

  val streamFire = (io.embedOut.fire || io.gammaOut.fire)

  when(state === State.STREAM && streamFire) {
    when(isLast) {
      state := State.DONE
    } otherwise {
      streamBeat := streamBeat + 1
    }
  }

  // ---------------------------------------------------------------------------
  // MemDone
  // ---------------------------------------------------------------------------
  io.memDone.valid := False
  io.memDone.payload.tag    := tag
  io.memDone.payload.error  := 0
  io.memDone.payload.sinkId := sinkId

  when(state === State.DONE) {
    io.memDone.valid := True
  }
}

object DdrAgentM1Gen {
  def main(args: Array[String]): Unit = {
    val targetDir = args.headOption.getOrElse("ddrAgent/gen/verilog")
    val axiWidth  = sys.env.getOrElse("DDR_AGENT_AXI_WIDTH", "256").toInt
    SpinalConfig(targetDirectory = targetDir).generateVerilog(
      DdrAgentM1(axiCfg = DdrAgentAxi.config(dataWidth = axiWidth))
    )
  }
}
