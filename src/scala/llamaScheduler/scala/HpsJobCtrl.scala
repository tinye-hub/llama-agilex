package llamaScheduler

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite._
import ddrMemoryMap.DdrMemoryMap

/**
 * HPS MMIO register file (AXI4-Lite slave). See llama-scheduler-design.md §3.2.
 *
 * Connect to GHRD `lwhps2fpga` via Platform Designer (byte addresses 0x00..0x93).
 */
object HpsJobCtrl {
  val ctrlJobStart       = 0
  val ctrlJobAbort       = 1
  val ctrlSoftResetSched = 2

  /** Scala constant; widen to UInt in hardware with `U(HpsJobCtrl.errTokenIdOob, 8 bits)`. */
  val errTokenIdOob = 1

  def axiLiteConfig: AxiLite4Config = AxiLite4Config(
    addressWidth = 8,
    dataWidth    = 32
  )
}

class HpsJobCtrl extends Component {

  val io = new Bundle {
    val axiLite = slave(AxiLite4(HpsJobCtrl.axiLiteConfig))
    val jobStart       = out Bool()
    val jobAbort       = out Bool()
    val softResetSched = out Bool()
    val tokenId   = out UInt(17 bits)
    val seqPos    = out UInt(10 bits)
    val jobPhase  = out UInt(2 bits)
    val promptLen = out UInt(10 bits)
    val busy           = in Bool()
    val jobDoneSticky  = in Bool()
    val jobErrorSticky = in Bool()
    val errorCode      = in UInt(8 bits)
    val schedStateDbg  = in UInt(4 bits)
  }

  val busCtrl = AxiLite4SlaveFactory(io.axiLite)

  val ctrlReg = Reg(Bits(32 bits)) init (0)
  busCtrl.readAndWrite(ctrlReg, 0x00, 0)

  val tokenIdReg   = Reg(UInt(17 bits)) init (0)
  val seqPosReg    = Reg(UInt(10 bits)) init (0)
  val jobPhaseReg  = Reg(UInt(2 bits)) init (0)
  val promptLenReg = Reg(UInt(10 bits)) init (0)

  busCtrl.readAndWrite(tokenIdReg, 0x08, 0)
  busCtrl.readAndWrite(seqPosReg, 0x0C, 0)
  busCtrl.readAndWrite(jobPhaseReg, 0x10, 0)
  busCtrl.readAndWrite(promptLenReg, 0x14, 0)

  val statusReg = Bits(32 bits)
  statusReg := 0
  statusReg(0) := io.busy
  statusReg(1) := io.jobDoneSticky
  statusReg(2) := io.jobErrorSticky
  statusReg(7 downto 4) := io.schedStateDbg.asBits
  busCtrl.read(statusReg, 0x04)

  val nextTokenId = Reg(UInt(17 bits)) init (0)
  busCtrl.read(nextTokenId, 0x18)

  val errorCodeRead = RegNext(io.errorCode)
  busCtrl.read(errorCodeRead, 0x1C, 0)

  busCtrl.read(U(DdrMemoryMap.layoutMagic, 32 bits), 0x80)
  busCtrl.read(U(DdrMemoryMap.layoutVersion, 32 bits), 0x84)
  busCtrl.read(U(DdrMemoryMap.embBase, 32 bits), 0x88)
  busCtrl.read(U(DdrMemoryMap.vocabSize, 32 bits), 0x8C)
  busCtrl.read(U(DdrMemoryMap.rmsGammaBase, 32 bits), 0x90)

  val axi = io.axiLite
  val ctrlWriteFire = axi.aw.fire && (axi.aw.payload.addr === 0)
  val jobStartPulse = RegNext(ctrlWriteFire && axi.w.payload.data(0)) init (False)

  when(ctrlWriteFire && axi.w.payload.data(0)) {
    ctrlReg(0) := False
  }

  io.jobStart       := jobStartPulse
  io.jobAbort       := ctrlReg(HpsJobCtrl.ctrlJobAbort)
  io.softResetSched := ctrlReg(HpsJobCtrl.ctrlSoftResetSched)

  io.tokenId   := tokenIdReg
  io.seqPos    := seqPosReg
  io.jobPhase  := jobPhaseReg
  io.promptLen := promptLenReg
}
