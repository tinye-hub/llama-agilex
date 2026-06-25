package llamaScheduler

import spinal.core._
import spinal.lib._
import ddrAgent.{DdrSinkId, MemCmd, MemCmdType, MemDone}
import common.DdrMemoryMap

/** Latched HPS job snapshot (one token inference). */
case class JobSnapshot() extends Bundle {
  val tokenId   = UInt(17 bits)
  val seqPos    = UInt(10 bits)
  val jobPhase  = UInt(2 bits)
  val promptLen = UInt(10 bits)
}

/**
 * Milestone 1 scheduler: HPS job latch, two [[MemCmd]] reads (embed + L0 norm1 gamma), wait for RMSNorm.
 */
object LlamaSchedulerM1 {
  object State extends SpinalEnum {
    val IDLE, DDR_REQ, WAIT_DDR, WAIT_RMSNORM, JOB_DONE = newElement()
  }
}

class LlamaSchedulerM1 extends Component {

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

    val busy           = out Bool()
    val jobDoneSticky  = out Bool()
    val jobErrorSticky = out Bool()
    val errorCode      = out UInt(8 bits)
    val schedStateDbg  = out UInt(4 bits)
  }

  import LlamaSchedulerM1.State

  val state = RegInit(State.IDLE)
  val snap  = Reg(JobSnapshot())

  val pendingCmds   = Reg(UInt(2 bits)) init (0)
  val memDoneCount  = Reg(UInt(2 bits)) init (0)
  val cmdPhase      = Reg(UInt(1 bits)) init (0) // 0=embed, 1=gamma
  val jobDoneReg    = Reg(Bool()) init (False)
  val jobErrorReg   = Reg(Bool()) init (False)
  val errorCodeReg  = Reg(UInt(8 bits)) init (0)

  val axisCtx = Bits(16 bits)
  axisCtx := 0
  axisCtx(14 downto 11) := B(0, 4 bits)
  axisCtx(10 downto 9)  := B(DdrMemoryMap.NormKind.norm1, 2 bits)
  axisCtx(8 downto 0)   := snap.seqPos.asBits.resized

  def mkReadCmd(sinkId: UInt, ddrAddr: UInt): MemCmd = {
    val c = MemCmd()
    c.cmdType := U(MemCmdType.read, 8 bits)
    c.sinkId  := sinkId
    c.byteLen := U(DdrMemoryMap.rowBytes, 32 bits)
    c.ddrAddr := ddrAddr
    c.tag     := U(0, 32 bits)
    c.axisCtx := axisCtx
    c
  }

  val embAddr = (U(DdrMemoryMap.embBase, 32 bits) + (snap.tokenId.resized * U(DdrMemoryMap.rowBytes, 32 bits))).resize(32)
  val gammaAddr = U(DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1), 32 bits)

  io.busy          := state =/= State.IDLE
  io.jobDoneSticky := jobDoneReg
  io.jobErrorSticky := jobErrorReg
  io.errorCode     := errorCodeReg

  val schedStateDbg = UInt(4 bits)
  switch(state) {
    is(State.IDLE)         { schedStateDbg := 0 }
    is(State.DDR_REQ)      { schedStateDbg := 1 }
    is(State.WAIT_DDR)     { schedStateDbg := 2 }
    is(State.WAIT_RMSNORM) { schedStateDbg := 3 }
    is(State.JOB_DONE)     { schedStateDbg := 4 }
  }
  io.schedStateDbg := schedStateDbg

  io.memCmd.valid := False
  io.memCmd.payload.assignDontCare()
  io.memDone.ready := False

  when(io.softResetSched) {
    state := State.IDLE
    pendingCmds := 0
    memDoneCount := 0
    cmdPhase := 0
    jobDoneReg := False
    jobErrorReg := False
    errorCodeReg := 0
  } otherwise {
    switch(state) {
      is(State.IDLE) {
        when(io.jobStart) {
          snap.tokenId   := io.tokenId
          snap.seqPos    := io.seqPos
          snap.jobPhase  := io.jobPhase
          snap.promptLen := io.promptLen
          jobDoneReg := False
          jobErrorReg := False
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
          io.memCmd.payload := mkReadCmd(U(DdrSinkId.embedRow, 8 bits), embAddr)
        } otherwise {
          io.memCmd.payload := mkReadCmd(U(DdrSinkId.rmsGamma, 8 bits), gammaAddr)
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
