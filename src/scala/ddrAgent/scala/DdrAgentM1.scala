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
  val beatBytesW = log2Up(beatBytes)
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
  val outBeat    = Reg(UInt(11 bits)) init (0)

  val rowBuf = new DdrAgentRowMem(beatBytes, rowBytes)

  val cmdPop = cmdFifo.io.pop
  cmdPop.ready := False

  // 1-cycle cmd pipe: break cmdFifo BRAM read → job register timing path.
  val cmdLoadValid = RegInit(False)
  val cmdLoad      = Reg(MemCmd())

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
      when(cmdLoadValid) {
        ddrAddr   := cmdLoad.ddrAddr
        byteLen   := cmdLoad.byteLen
        sinkId    := cmdLoad.sinkId
        tag       := cmdLoad.tag
        axisCtx   := cmdLoad.axisCtx
        bytesRead := 0
        burstAddr := cmdLoad.ddrAddr
        outBeat   := 0
        cmdLoadValid := False
        state := State.AXI_AR
      }.elsewhen(cmdPop.valid) {
        cmdPop.ready := True
        cmdLoad      := cmdPop.payload
        cmdLoadValid := True
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
      rowBuf.writeBeat(
        beatIdx = (bytesRead >> beatBytesW).resize(rowBuf.addrW),
        data    = io.axi.r.payload.data,
        enable  = io.axi.r.fire
      )
      when(io.axi.r.fire) {
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

  // Row → AXI-Stream (2048 × FP16, little-endian)
  when(state === State.IDLE) {
    outBeat := 0
  }

  val beatIdx    = rowBuf.beatIndexForStreamBeat(outBeat)
  val beatWord   = rowBuf.readBeat(beatIdx)

  val isEmbed = sinkId === U(DdrSinkId.embedRow, 8 bits)
  val isGamma = sinkId === U(DdrSinkId.rmsGamma, 8 bits)

  val streamValid = state === State.STREAM

  val streamData = rowBuf.fp16AtStreamBeat(beatWord, outBeat)

  val isLast  = outBeat === U(beatCount - 1, outBeat.getWidth bits)

  val tuser = Bits(16 bits)
  tuser := axisCtx
  tuser(15) := !isLast

  val embedOutValid = RegInit(False)
  val embedOutData  = Reg(Bits(16 bits))
  val embedOutLast  = Reg(Bool())
  val embedOutUser  = Reg(Bits(io.embedOut.payload.user.getWidth bits))
  io.embedOut.valid := embedOutValid
  io.embedOut.payload.data := embedOutData
  io.embedOut.payload.last := embedOutLast
  io.embedOut.payload.user := embedOutUser
  if (axisCfg.useKeep) io.embedOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1

  val embedInValid   = streamValid && isEmbed
  val embedOutFire   = embedOutValid && io.embedOut.ready
  val embedOutReadyR = RegNext(io.embedOut.ready, True)
  val embedStageFire = embedInValid && (!embedOutValid || embedOutReadyR)
  when(embedStageFire) {
    embedOutValid := True
    embedOutData  := streamData
    embedOutLast  := isLast
    embedOutUser  := tuser.resized
  }.elsewhen(embedOutFire) {
    embedOutValid := False
  }

  val gammaOutValid = RegInit(False)
  val gammaOutData  = Reg(Bits(16 bits))
  val gammaOutLast  = Reg(Bool())
  val gammaOutUser  = Reg(Bits(io.gammaOut.payload.user.getWidth bits))
  io.gammaOut.valid := gammaOutValid
  io.gammaOut.payload.data := gammaOutData
  io.gammaOut.payload.last := gammaOutLast
  io.gammaOut.payload.user := gammaOutUser
  if (axisCfg.useKeep) io.gammaOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1

  val gammaInValid   = streamValid && isGamma
  val gammaOutFire   = gammaOutValid && io.gammaOut.ready
  val gammaOutReadyR = RegNext(io.gammaOut.ready, True)
  val gammaStageFire = gammaInValid && (!gammaOutValid || gammaOutReadyR)
  when(gammaStageFire) {
    gammaOutValid := True
    gammaOutData  := streamData
    gammaOutLast  := isLast
    gammaOutUser  := tuser.resized
  }.elsewhen(gammaOutFire) {
    gammaOutValid := False
  }

  val rowPipeBusy = embedOutValid || gammaOutValid

  val streamFire = embedStageFire || gammaStageFire

  when(state === State.STREAM && streamValid && streamFire) {
    when(isLast) {
      state := State.DONE
    } otherwise {
      outBeat := outBeat + 1
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
    io.memDone.valid := !rowPipeBusy
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
