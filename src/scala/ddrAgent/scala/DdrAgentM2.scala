package ddrAgent

import ddrMemoryMap.DdrMemoryMap
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import spinal.lib.bus.amba4.axi._
import rmsNorm.RmsNormAxisCfg

/**
 * Milestone 2a DDR agent: [[DdrAgentM1]] row sinks + `GEMV_WEIGHT` tile reads.
 *
 * `EMBED_ROW` / `RMS_GAMMA` behave as M1 (4096 B row → 2048 FP16 AXI-Stream beats).
 * `GEMV_WEIGHT` reads `byteLen` bytes (typically 32 B = one 256-bit INT4 tile) and
 * emits a single `weightBeat` on the 256-bit AXI data width.
 * `SCALE_PRELOAD` streams `byteLen` bytes as FP16 beats on `scaleOut`.
 */
object DdrAgentM2 {
  object State extends SpinalEnum {
    val IDLE, AXI_AR, AXI_R, STREAM, DONE = newElement()
  }

  def apply(axiCfg: Axi4Config = DdrAgentAxi.config()): DdrAgentM2 = new DdrAgentM2(axiCfg)
}

class DdrAgentM2(axiCfg: Axi4Config = DdrAgentAxi.config()) extends Component {

  val axisCfg     = RmsNormAxisCfg()
  val axiConfig   = axiCfg
  val rowBytes    = DdrMemoryMap.rowBytes.toInt
  val beatCount   = DdrMemoryMap.vectorDim
  val beatBytes   = DdrAgentAxi.dataBytesOf(axiConfig)
  val burstBytes  = DdrAgentAxi.burstBytes
  val burstBeats  = DdrAgentAxi.burstBeatsOf(axiConfig)
  val beatBytesW  = log2Up(beatBytes)

  val io = new Bundle {
    val memCmd     = slave(Stream(MemCmd()))
    val memDone    = master(Stream(MemDone()))
    val embedOut   = master(Axi4Stream(axisCfg))
    val gammaOut   = master(Axi4Stream(axisCfg))
    val scaleOut   = master(Stream(Bits(16 bits)))
    val weightBeat = master(Stream(Bits(axiConfig.dataWidth bits)))
    val axi        = master(Axi4(axiConfig))
  }

  import DdrAgentM2.State

  val cmdFifo = StreamFifo(MemCmd(), depth = 8)
  io.memCmd >> cmdFifo.io.push

  val state      = RegInit(State.IDLE)
  val ddrAddr    = Reg(UInt(32 bits))
  val byteLen    = Reg(UInt(32 bits))
  val sinkId     = Reg(UInt(8 bits))
  val tag        = Reg(UInt(32 bits))
  val axisCtx    = Reg(Bits(16 bits))

  val bytesRead  = Reg(UInt(32 bits)) init (0)
  val burstAddr  = Reg(UInt(32 bits))
  val outBeat    = Reg(UInt(11 bits)) init (0)

  val rowBuf = new DdrAgentRowMem(beatBytes, rowBytes)

  val cmdPop = cmdFifo.io.pop
  cmdPop.ready := False

  io.axi.aw.valid := False
  io.axi.aw.payload.assignDontCare()
  io.axi.w.valid  := False
  io.axi.w.payload.assignDontCare()
  io.axi.b.ready  := False

  io.axi.ar.valid       := False
  io.axi.ar.payload.assignDontCare()
  io.axi.r.ready        := False

  val isEmbed = sinkId === U(DdrSinkId.embedRow, 8 bits)
  val isGamma = sinkId === U(DdrSinkId.rmsGamma, 8 bits)
  val isGemv  = sinkId === U(DdrSinkId.gemvWeight, 8 bits)
  val isScale = sinkId === U(DdrSinkId.scalePreload, 8 bits)

  val bytesRemaining = (byteLen - bytesRead).resized
  val beatsNeeded    = ((bytesRemaining + U(beatBytes - 1, 32 bits)) |>> beatBytesW).resized
  val beatsThisAr    = Mux(beatsNeeded > U(burstBeats, beatsNeeded.getWidth bits),
    U(burstBeats, beatsNeeded.getWidth bits),
    beatsNeeded
  )
  val arLen = (beatsThisAr - U(1, beatsThisAr.getWidth bits)).resized

  switch(state) {
    is(State.IDLE) {
      when(cmdPop.valid) {
        cmdPop.ready := True
        ddrAddr    := cmdPop.payload.ddrAddr
        byteLen    := cmdPop.payload.byteLen
        sinkId     := cmdPop.payload.sinkId
        tag        := cmdPop.payload.tag
        axisCtx    := cmdPop.payload.axisCtx
        bytesRead  := 0
        burstAddr  := cmdPop.payload.ddrAddr
        outBeat    := 0
        state := State.AXI_AR
      }
    }

    is(State.AXI_AR) {
      io.axi.ar.valid := True
      io.axi.ar.payload.addr  := burstAddr
      io.axi.ar.payload.len   := arLen.resize(8 bits)
      io.axi.ar.payload.size  := U(beatBytesW, 3 bits)
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
          when(nextBytes >= byteLen) {
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

  // Row → stream / weightBeat
  when(state === State.IDLE) {
    outBeat := 0
  }

  val beatWord = rowBuf.readBeat(U(0, rowBuf.addrW bits))

  val streamValidRow = state === State.STREAM && (isEmbed || isGamma || isScale)

  val streamBeatIdx = Mux(isGemv, U(0, outBeat.getWidth bits), outBeat)
  val streamWord    = Mux(isGemv, beatWord, rowBuf.readBeat(rowBuf.beatIndexForStreamBeat(outBeat)))
  val streamData    = rowBuf.fp16AtStreamBeat(streamWord, streamBeatIdx)

  val streamBeatsTotal = (byteLen |>> 1).resize(outBeat.getWidth bits)
  val isLast           = outBeat === (streamBeatsTotal - U(1, streamBeatsTotal.getWidth bits))

  val tuser = Bits(16 bits)
  tuser := axisCtx
  tuser(15) := !isLast

  io.embedOut.valid := streamValidRow && isEmbed
  io.embedOut.payload.data := streamData
  io.embedOut.payload.last := isLast
  io.embedOut.payload.user := tuser.resized
  if (axisCfg.useKeep) io.embedOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1

  io.gammaOut.valid := streamValidRow && isGamma
  io.gammaOut.payload.data := streamData
  io.gammaOut.payload.last := isLast
  io.gammaOut.payload.user := tuser.resized
  if (axisCfg.useKeep) io.gammaOut.payload.keep := (1 << axisCfg.dataWidth / 8) - 1

  io.scaleOut.valid   := streamValidRow && isScale
  io.scaleOut.payload := streamData

  val gemvValid = state === State.STREAM && isGemv

  io.weightBeat.valid   := gemvValid
  io.weightBeat.payload := beatWord

  val streamFireRow  = io.embedOut.fire || io.gammaOut.fire || io.scaleOut.fire
  val streamFireGemv = io.weightBeat.fire

  when(state === State.STREAM) {
    when(isGemv && streamFireGemv) {
      state := State.DONE
    } elsewhen(streamValidRow && streamFireRow) {
      when(isLast) {
        state := State.DONE
      } otherwise {
        outBeat := outBeat + 1
      }
    }
  }

  io.memDone.valid := False
  io.memDone.payload.tag    := tag
  io.memDone.payload.error  := 0
  io.memDone.payload.sinkId := sinkId

  when(state === State.DONE) {
    io.memDone.valid := True
  }
}

object DdrAgentM2Gen {
  def main(args: Array[String]): Unit = {
    val targetDir = args.headOption.getOrElse("ddrAgent/gen/verilog")
    val axiWidth  = sys.env.getOrElse("DDR_AGENT_AXI_WIDTH", "256").toInt
    SpinalConfig(targetDirectory = targetDir).generateVerilog(
      DdrAgentM2(axiCfg = DdrAgentAxi.config(dataWidth = axiWidth))
    )
  }
}
