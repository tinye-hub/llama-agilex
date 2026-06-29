package gemvService64

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Activation buffer: **16-bit narrow write**, **1024-bit wide read** (design §2.6.2).
 *
 * Write side accepts the RMSNorm output stream one FP16 per beat (`vectorDim`
 * beats per vector). 64 consecutive lanes are packed into one 1024-bit wide
 * word and stored in a `tilesPerRow`-deep RAM (method B: write-wide via a lane
 * collector — same idea as llama-fpga `Serial2Parallel`). The MAC reads one
 * wide word per macBeat with `tileSel = t`.
 *
 * Wide-word BRAM writes are registered one cycle after lane assembly (timing).
 *
 * Lane mapping: lane `j` (= `x[t*64 + j]`) occupies bits `[j*16 +: 16]` of the
 * wide word — low index in low bits, matching the INT4 nibble unpack order.
 *
 * M2a contract: the full vector is written (`loaded` high) before `gemvStart`;
 * there is no concurrent read/write hazard.
 */
class GemvActBuffer(g: GemvGenerics) extends Component {

  val bankLen   = g.bankLen
  val wordCount = g.tilesPerRow
  val wordWidth = g.tileFp16Width
  val laneIdxW  = log2Up(bankLen)
  val wordIdxW  = log2Up(wordCount)

  val io = new Bundle {
    /** Narrow FP16 write stream (RMSNorm output). */
    val actIn   = slave(Stream(Bits(g.fp16Width bits)))
    /** Wide-read tile select, `0 .. tilesPerRow-1`. */
    val tileSel = in UInt (wordIdxW bits)
    /** Wide read data: 64 × FP16 (registered BRAM output). */
    val tileData = out Bits (wordWidth bits)
    /** High once the full vector (all wide words) has been written. */
    val loaded = out Bool ()
    /** Pulse when the last wide word is committed to BRAM (1 cycle after last lane beat). */
    val lastWrite = out Bool ()
    /** Reset write progress / `loaded` to accept a fresh vector. */
    val clear = in Bool ()
  }

  val mem = Mem(Bits(wordWidth bits), wordCount)

  val laneBuf = Vec(Reg(Bits(g.fp16Width bits)) init (0), bankLen)
  val laneIdx = Reg(UInt(laneIdxW bits)) init (0)
  val wordIdx = Reg(UInt(wordIdxW bits)) init (0)
  val loaded  = RegInit(False)

  io.actIn.ready := !loaded

  val laneLast = laneIdx === U(bankLen - 1, laneIdxW bits)
  val wordLast = wordIdx === U(wordCount - 1, wordIdxW bits)

  // Assemble the wide word being completed this beat: stored lanes + incoming lane.
  val wordNext = Bits(wordWidth bits)
  for (j <- 0 until bankLen) {
    wordNext(j * g.fp16Width, g.fp16Width bits) := Mux(laneIdx === U(j, laneIdxW bits), io.actIn.payload, laneBuf(j))
  }

  val doWordWrite = io.actIn.fire && laneLast

  // 1-cycle write pipe: laneIdx/laneBuf → wordNext assembly → BRAM (timing).
  val wrEn   = RegInit(False)
  val wrAddr = Reg(UInt(wordIdxW bits))
  val wrData = Reg(Bits(wordWidth bits))
  val wrLast = Reg(Bool())
  when(doWordWrite) {
    wrAddr := wordIdx
    wrData := wordNext
    wrLast := wordLast
    wrEn   := True
  } otherwise {
    wrEn := False
  }
  mem.write(
    address = wrAddr,
    data    = wrData,
    enable  = wrEn
  )

  when(io.actIn.fire) {
    laneBuf(laneIdx) := io.actIn.payload
    when(laneLast) {
      laneIdx := 0
      when(wordLast) {
        wordIdx := 0
      } otherwise {
        wordIdx := wordIdx + 1
      }
    } otherwise {
      laneIdx := laneIdx + 1
    }
  }

  when(wrEn && wrLast) {
    loaded := True
  }

  when(io.clear) {
    laneIdx := 0
    wordIdx := 0
    loaded  := False
  }

  // Registered read port: BRAM Tco → tileOut; MAC samples on macBeatEn (1 cycle after beatFire).
  val tileOut = Reg(Bits(wordWidth bits))
  tileOut := mem.readAsync(io.tileSel)
  io.tileData := tileOut
  io.loaded    := loaded
  io.lastWrite := wrEn && wrLast
}
