package llamaScheduler

import ddrAgent.{DdrSinkId, MemCmd, MemCmdType, MemDone}
import ddrMemoryMap.DdrMemoryMap
import gemvService64.{GemvCtrl, GemvOp, InputSrc, WeightFmt}
import spinal.core._
import spinal.lib._
import top.LlamaM2aGenerics

/**
 * Milestone 2a scheduler: M1 embed + gamma + RMSNorm, then W_Q scale preload + GEMV.
 */
object LlamaSchedulerM2a {
  object State extends SpinalEnum {
    val IDLE, DDR_REQ, WAIT_DDR, WAIT_RMSNORM, SCALE_REQ, WAIT_SCALE, WAIT_GEMV, JOB_DONE = newElement()
  }
}

class LlamaSchedulerM2a(g: LlamaM2aGenerics) extends Component {

  val rowBytes    = DdrMemoryMap.rowBytes.toInt
  val scaleChunks = g.scaleChunks
  val scaleBytes  = g.scaleBytesTotal
  val chunkCntW   = log2Up(scaleChunks + 1)

  val io = new Bundle {
    val jobStart       = in Bool()
    val jobAbort       = in Bool()
    val softResetSched = in Bool()
    val tokenId        = in UInt(17 bits)
    val seqPos         = in UInt(10 bits)
    val jobPhase       = in UInt(2 bits)
    val promptLen      = in UInt(10 bits)

    val memCmd  = master(Stream(MemCmd()))
    val memDone = slave(Stream(MemDone()))

    val rmsNormOutLast = in Bool()

    val gemv = master(GemvCtrl())

    val busy           = out Bool()
    val jobDoneSticky  = out Bool()
    val jobErrorSticky = out Bool()
    val errorCode      = out UInt(8 bits)
    val schedStateDbg  = out UInt(4 bits)
  }

  import LlamaSchedulerM2a.State

  val state = RegInit(State.IDLE)
  val snap  = Reg(JobSnapshot())

  val pendingCmds   = Reg(UInt(2 bits)) init (0)
  val memDoneCount  = Reg(UInt(2 bits)) init (0)
  val cmdPhase      = Reg(UInt(1 bits)) init (0)
  val scaleChunkIdx = Reg(UInt(chunkCntW bits)) init (0)
  val gemvStartReg  = Reg(Bool()) init (False)

  val jobDoneReg   = Reg(Bool()) init (False)
  val jobErrorReg  = Reg(Bool()) init (False)
  val errorCodeReg = Reg(UInt(8 bits)) init (0)

  val axisCtx = Bits(16 bits)
  axisCtx := 0
  axisCtx(14 downto 11) := B(0, 4 bits)
  axisCtx(10 downto 9)  := B(DdrMemoryMap.NormKind.norm1, 2 bits)
  axisCtx(8 downto 0)   := snap.seqPos.asBits.resized

  def mkReadCmd(sinkId: UInt, ddrAddr: UInt, len: UInt): MemCmd = {
    val c = MemCmd()
    c.cmdType := U(MemCmdType.read, 8 bits)
    c.sinkId  := sinkId
    c.byteLen := len
    c.ddrAddr := ddrAddr
    c.tag     := U(0, 32 bits)
    c.axisCtx := axisCtx
    c
  }

  val embAddr = (U(DdrMemoryMap.embBase, 32 bits) + (snap.tokenId.resized * U(DdrMemoryMap.rowBytes, 32 bits))).resize(32)
  val gammaAddr = U(DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1), 32 bits)

  val scaleBase = U(DdrMemoryMap.attnWqScaleBase(0), 32 bits)
  val scaleChunkAddr = (scaleBase + (scaleChunkIdx.resized * U(rowBytes, 32 bits))).resize(32)

  val scaleChunkLen = {
    val isLast = scaleChunkIdx === U(scaleChunks - 1, chunkCntW bits)
    val lastBytes = U(scaleBytes - (scaleChunks - 1).toLong * rowBytes, 32 bits)
    Mux(isLast, lastBytes, U(rowBytes, 32 bits))
  }

  io.busy           := state =/= State.IDLE
  io.jobDoneSticky  := jobDoneReg
  io.jobErrorSticky := jobErrorReg
  io.errorCode      := errorCodeReg

  val schedStateDbg = UInt(4 bits)
  switch(state) {
    is(State.IDLE)         { schedStateDbg := 0 }
    is(State.DDR_REQ)      { schedStateDbg := 1 }
    is(State.WAIT_DDR)     { schedStateDbg := 2 }
    is(State.WAIT_RMSNORM) { schedStateDbg := 3 }
    is(State.SCALE_REQ)    { schedStateDbg := 5 }
    is(State.WAIT_SCALE)   { schedStateDbg := 6 }
    is(State.WAIT_GEMV)    { schedStateDbg := 7 }
    is(State.JOB_DONE)     { schedStateDbg := 4 }
  }
  io.schedStateDbg := schedStateDbg

  io.memCmd.valid := False
  io.memCmd.payload.assignDontCare()
  io.memDone.ready := False

  io.gemv.job.op        := U(GemvOp.W_Q, io.gemv.job.op.getWidth bits)
  io.gemv.job.layer     := U(0, io.gemv.job.layer.getWidth bits)
  io.gemv.job.mRows     := U(g.gemvM, io.gemv.job.mRows.getWidth bits)
  io.gemv.job.kCols     := U(g.dim, io.gemv.job.kCols.getWidth bits)
  io.gemv.job.wBase     := U(DdrMemoryMap.wQ(0), io.gemv.job.wBase.getWidth bits)
  io.gemv.job.scaleBase := scaleBase
  io.gemv.job.weightFmt := U(WeightFmt.INT4_G128_SYM, io.gemv.job.weightFmt.getWidth bits)
  io.gemv.job.inputSrc  := U(InputSrc.ACT_BUF, io.gemv.job.inputSrc.getWidth bits)
  io.gemv.start         := gemvStartReg

  when(io.softResetSched) {
    state := State.IDLE
    pendingCmds := 0
    memDoneCount := 0
    cmdPhase := 0
    scaleChunkIdx := 0
    gemvStartReg := False
    jobDoneReg := False
    jobErrorReg := False
    errorCodeReg := 0
  } otherwise {
    gemvStartReg := False

    switch(state) {
      is(State.IDLE) {
        when(io.jobStart) {
          snap.tokenId   := io.tokenId
          snap.seqPos    := io.seqPos
          snap.jobPhase  := io.jobPhase
          snap.promptLen := io.promptLen
          jobDoneReg := False
          jobErrorReg := False
          scaleChunkIdx := 0
          when(io.tokenId >= DdrMemoryMap.vocabSize) {
            state := State.JOB_DONE
            jobErrorReg := True
            errorCodeReg := U(HpsJobCtrl.errTokenIdOob, 8 bits)
          } otherwise {
            state := State.DDR_REQ
            pendingCmds := 2
            memDoneCount := 0
            cmdPhase := 0
          }
        }
      }

      is(State.DDR_REQ) {
        io.memCmd.valid := True
        when(cmdPhase === 0) {
          io.memCmd.payload := mkReadCmd(U(DdrSinkId.embedRow, 8 bits), embAddr, U(rowBytes, 32 bits))
        } otherwise {
          io.memCmd.payload := mkReadCmd(U(DdrSinkId.rmsGamma, 8 bits), gammaAddr, U(rowBytes, 32 bits))
        }
        when(io.memCmd.fire) {
          when(cmdPhase === 0) {
            cmdPhase := 1
          } otherwise {
            state := State.WAIT_DDR
          }
        }
      }

      is(State.WAIT_DDR) {
        io.memDone.ready := True
        when(io.memDone.fire) {
          val nextDone = memDoneCount + 1
          memDoneCount := nextDone
          when(nextDone === pendingCmds) {
            state := State.WAIT_RMSNORM
          }
        }
      }

      is(State.WAIT_RMSNORM) {
        when(io.rmsNormOutLast) {
          state := State.SCALE_REQ
        }
        when(io.jobAbort) {
          state := State.IDLE
        }
      }

      is(State.SCALE_REQ) {
        io.memCmd.valid := True
        io.memCmd.payload := mkReadCmd(
          U(DdrSinkId.scalePreload, 8 bits),
          scaleChunkAddr,
          scaleChunkLen
        )
        when(io.memCmd.fire) {
          state := State.WAIT_SCALE
        }
      }

      is(State.WAIT_SCALE) {
        io.memDone.ready := True
        when(io.memDone.fire) {
          val nextIdx = scaleChunkIdx + 1
          scaleChunkIdx := nextIdx
          when(nextIdx === U(scaleChunks, chunkCntW bits)) {
            gemvStartReg := True
            state := State.WAIT_GEMV
          } otherwise {
            state := State.SCALE_REQ
          }
        }
      }

      is(State.WAIT_GEMV) {
        // Drain MemDone for each GEMV_WEIGHT tile read (DdrAgent stays in DONE until this fires).
        io.memDone.ready := True
        when(io.gemv.done) {
          state := State.JOB_DONE
          jobDoneReg := True
        }
        when(io.jobAbort) {
          state := State.IDLE
        }
      }

      is(State.JOB_DONE) {
        when(!io.jobStart) {
          state := State.IDLE
        }
      }
    }
  }
}
