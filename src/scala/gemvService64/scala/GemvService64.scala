package gemvService64

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import util.{RmsNormAlteraIp, fp32MultAcc}

import scala.language.postfixOps

object GemvService64 {
  def apply(
    g: GemvGenerics = GemvGenerics(),
    toFp32_func:   Flow[Bits] => Flow[Bits]                              = RmsNormAlteraIp.toFp32,
    toFp16_func:   Flow[Bits] => Flow[Bits]                              = RmsNormAlteraIp.toFp16,
    mul_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits]                = RmsNormAlteraIp.mul,
    add_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits]                = RmsNormAlteraIp.add,
    groupAcc_func: (Bool, Flow[Fragment[Bits]]) => Flow[Fragment[Bits]]  = fp32MultAcc.firstAcc
  ): GemvService64 =
    new GemvService64(g, toFp32_func, toFp16_func, mul_func, add_func, groupAcc_func)
}

/**
 * Common 64-wide INT4 GEMV service (design §8).
 *
 * Glues the ActBuffer (16b narrow write / 1024b wide read), ScaleRam (preloaded
 * FP16 group scales), Int4Unpack (256b beat → 64 int-FP16), GemvMacBeat
 * (64-wide MAC + tree + per-row FP32 acc) and GemvOutputSer (qOut AXIS).
 *
 * The integrated tile engine walks `(m, t)` mechanically over the Job's `wBase`
 * (request side issues `tileFetch`; compute side consumes returned `weightBeat`
 * in order). Rows in flight are bounded by `outFifoDepth` so the lossless `Flow`
 * MAC output never overflows the result FIFO.
 *
 * M2a scope: `inputSrc = ACT_BUF`, `weightFmt = INT4_G128_SYM`, `K = vectorDim`.
 */
class GemvService64(
  val g: GemvGenerics,
  toFp32_func:   Flow[Bits] => Flow[Bits],
  toFp16_func:   Flow[Bits] => Flow[Bits],
  mul_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits],
  add_func:      (Flow[Bits], Flow[Bits]) => Flow[Bits],
  groupAcc_func: (Bool, Flow[Fragment[Bits]]) => Flow[Fragment[Bits]]
) extends Component {

  val axisCfg     = GemvAxisCfg()
  val tilesPerRow = g.tilesPerRow
  val rowW        = log2Up(g.maxRows + 1)
  val tileW       = log2Up(tilesPerRow)
  val grpIdxW     = log2Up(g.maxRows * g.groupsPerRow)
  val inflightW   = log2Up(g.outFifoDepth + 1)

  val io = new Bundle {
    val ctrl       = slave(GemvCtrl())
    val actIn      = slave(Axi4Stream(axisCfg))
    val scaleLoad  = slave(Stream(Bits(g.fp16Width bits)))
    val weightBeat = slave(Stream(Bits(g.tileInt4Width bits)))
    val tileFetch  = master(Stream(TileFetchReq()))
    val qOut       = master(Axi4Stream(axisCfg))
    /** Debug: high if a row result was dropped (gating bug). Always 0 in M2a. */
    val dbgOverflow = out Bool ()
  }

  // ---------------------------------------------------------------------------
  // Sub-modules
  // ---------------------------------------------------------------------------
  val actBuf  = new GemvActBuffer(g)
  val scaleR  = new GemvScaleRam(g)
  val unpack  = new Int4Unpack(g)
  val mac     = new GemvMacBeat(g, toFp32_func, toFp16_func, mul_func, add_func, groupAcc_func)
  val outSer  = new GemvOutputSer(g)

  // 1-cycle actIn pipe: breaks rmsNorm outFifo → actBuf BRAM write timing path.
  val actStream = Stream(Bits(g.fp16Width bits))
  val actInValid = RegInit(False)
  val actInData  = Reg(Bits(g.fp16Width bits))
  io.actIn.ready := !actInValid || actStream.ready
  val actInFire   = actInValid && actStream.ready
  val actStageFire = io.actIn.valid && (!actInValid || actStream.ready)
  when(actStageFire) {
    actInValid := True
    actInData  := io.actIn.payload.data
  }.elsewhen(actInFire) {
    actInValid := False
  }
  actStream.valid   := actInValid
  actStream.payload := actInData
  actBuf.io.actIn   << actStream

  scaleR.io.loadIn  << io.scaleLoad

  // ---------------------------------------------------------------------------
  // Job registers + FSM
  // ---------------------------------------------------------------------------
  object State extends SpinalEnum {
    val IDLE, RUN, DONE = newElement()
  }
  val state = RegInit(State.IDLE)

  val jobReg = Reg(GemvJob())
  val jobM   = jobReg.mRows.resize(rowW)

  // ---------------------------------------------------------------------------
  // Request side: issue tileFetch for (mReq, tReq)
  // ---------------------------------------------------------------------------
  val mReq    = Reg(UInt(rowW bits)) init (0)
  val tReq    = Reg(UInt(tileW bits)) init (0)
  val reqDone = RegInit(False)

  val tReqLast = tReq === U(tilesPerRow - 1, tileW bits)
  val mReqLast = mReq === (jobM - 1)

  val tileAddr = (jobReg.wBase +
    (mReq.resize(32) * U(g.rowByteStride, 32 bits)) +
    (tReq.resize(32) * U(g.tileByteStride, 32 bits))).resize(32)

  io.tileFetch.valid          := (state === State.RUN) && !reqDone
  io.tileFetch.payload.ddrAddr := tileAddr
  io.tileFetch.payload.byteLen := U(g.tileByteStride, 16 bits)
  io.tileFetch.payload.reqTag  := tReq.resize(8)

  when(io.tileFetch.fire) {
    when(tReqLast) {
      tReq := 0
      when(mReqLast) {
        reqDone := True
      } otherwise {
        mReq := mReq + 1
      }
    } otherwise {
      tReq := tReq + 1
    }
  }

  // ---------------------------------------------------------------------------
  // Compute side: consume weightBeat in order, drive MAC
  // ---------------------------------------------------------------------------
  val mCmp = Reg(UInt(rowW bits)) init (0)
  val tCmp = Reg(UInt(tileW bits)) init (0)

  val tCmpLast = tCmp === U(tilesPerRow - 1, tileW bits)

  val inflight = Reg(UInt(inflightW bits)) init (0)
  val inflightFull = inflight === U(g.outFifoDepth, inflightW bits)

  // Inter-row bubble: the native-FP-DSP per-row accumulator must see at least one
  // idle cycle between a row's last tile and the next row's first tile, otherwise
  // the running sum is overwritten before it is captured (verified in Questa: a
  // back-to-back row gives a wrong result, a >=1-cycle gap is correct). Hold off
  // accepting the next first tile for `rowBubbleCycles` cycles after a last tile.
  val rowBubbleCycles = 2
  val rowBubble = Reg(UInt(log2Up(rowBubbleCycles + 1) bits)) init (0)
  when(rowBubble =/= 0) {
    rowBubble := rowBubble - 1
  }

  // Block accepting a row's *last* tile when results in flight would overflow the FIFO.
  val acceptOk = !(tCmpLast && inflightFull) && (rowBubble === 0)
  io.weightBeat.ready := (state === State.RUN) && acceptOk
  val beatFire = io.weightBeat.fire

  when(beatFire && tCmpLast) {
    rowBubble := U(rowBubbleCycles)
  }

  // ActBuffer wide read for this tile
  actBuf.io.tileSel := tCmp.resize(actBuf.wordIdxW)

  // INT4 unpack -> 64 int-FP16 weights
  unpack.io.weightBeat := io.weightBeat.payload

  // Scale: group index -> FP16 -> FP32 (latency 0 convert)
  val groupIndex = (mCmp.resize(grpIdxW) * U(g.groupsPerRow, grpIdxW bits)) +
    (tCmp >> log2Up(g.tilesPerGroup)).resize(grpIdxW)
  scaleR.io.groupIndex := groupIndex.resized

  // 1-cycle MAC beat delay: beatFire latches addr/weight; macBeatEn consumes registered actBuf read.
  val macBeatEn = RegNext(beatFire, False)
  val wWideR    = Reg(Bits(g.tileFp16Width bits))
  val scaleFp16R = Reg(Bits(g.fp16Width bits))
  val beatLastR = Reg(Bool())
  when(beatFire) {
    wWideR     := unpack.io.wWide
    scaleFp16R := scaleR.io.scaleFp16
    beatLastR  := tCmpLast
  }

  val scaleRaw = Flow(Bits(g.fp16Width bits))
  scaleRaw.valid   := macBeatEn
  scaleRaw.payload := scaleFp16R
  val scaleFp32 = toFp32_func(scaleRaw)

  mac.io.beatValid := macBeatEn
  mac.io.xWide     := actBuf.io.tileData
  mac.io.wWide     := wWideR
  mac.io.scaleFp32 := scaleFp32.payload
  mac.io.beatLast  := beatLastR

  when(beatFire) {
    when(tCmpLast) {
      tCmp := 0
      mCmp := mCmp + 1
    } otherwise {
      tCmp := tCmp + 1
    }
  }

  // ---------------------------------------------------------------------------
  // Output serializer
  // ---------------------------------------------------------------------------
  outSer.io.rowIn << mac.io.rowOut
  outSer.io.op    := jobReg.op
  outSer.io.layer := jobReg.layer
  outSer.io.mRows := jobM
  io.qOut         << outSer.io.qOut

  // in-flight rows: +1 when a row's last tile is accepted, -1 when result pops
  val inflightInc = beatFire && tCmpLast
  val inflightDec = outSer.io.popFire
  when(inflightInc && !inflightDec) { inflight := inflight + 1 }
  when(!inflightInc && inflightDec) { inflight := inflight - 1 }

  // ---------------------------------------------------------------------------
  // FSM
  // ---------------------------------------------------------------------------
  val clearPulse = False
  switch(state) {
    is(State.IDLE) {
      when(io.ctrl.start) {
        jobReg  := io.ctrl.job
        mReq    := 0
        tReq    := 0
        mCmp    := 0
        tCmp    := 0
        reqDone := False
        inflight := 0
        state   := State.RUN
      }
    }
    is(State.RUN) {
      when(outSer.io.done) {
        state := State.DONE
      }
    }
    is(State.DONE) {
      clearPulse := True
      state := State.IDLE
    }
  }

  actBuf.io.clear  := clearPulse
  scaleR.io.clear  := clearPulse
  outSer.io.clear  := clearPulse

  io.ctrl.done  := state === State.DONE
  io.ctrl.busy  := state =/= State.IDLE
  io.ctrl.error := False

  io.dbgOverflow := outSer.io.overflow
}
