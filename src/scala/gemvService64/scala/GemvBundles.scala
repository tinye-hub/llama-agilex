package gemvService64

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/** GEMV operation id (Scheduler → GemvService64). See gemv-m2a-design.md §9.1. */
object GemvOp {
  val W_Q = 0
  val W_K = 1
  val W_V = 2
  // reserved for later milestones: W_O, GATE, UP, DOWN ...
  val width = 4
}

/** Weight payload format. M2a only ships INT4 group-128 symmetric. */
object WeightFmt {
  val INT4_G128_SYM = 0
  val width = 3
}

/** GEMV input vector source. M2a only sources the ActBuffer (RMSNorm output). */
object InputSrc {
  val ACT_BUF = 0
  val width = 2
}

/**
 * Job descriptor: semantic addresses resolved by Scheduler + DdrMemoryMap.
 *
 * The engine treats `wBase` / `scaleBase` as opaque byte addresses and only
 * does mechanical `(m, t)` iteration on top of them — it never re-derives
 * layer/op address math (see design §3).
 */
case class GemvJob() extends Bundle {
  val op        = UInt(GemvOp.width bits)
  val layer     = UInt(4 bits)
  val mRows     = UInt(17 bits)        // output rows M
  val kCols     = UInt(17 bits)        // inner-product length K
  val wBase     = UInt(32 bits)        // weight payload start byte address
  val scaleBase = UInt(32 bits)        // scale sub-table start byte address
  val weightFmt = UInt(WeightFmt.width bits)
  val inputSrc  = UInt(InputSrc.width bits)
}

/**
 * Weight tile fetch request (GemvService64 → DdrAgent, via Top arbiter).
 *
 * `byteLen` defaults to one 256-bit beat (32 B); a4 may widen to a burst.
 */
case class TileFetchReq() extends Bundle {
  val ddrAddr = UInt(32 bits)
  val byteLen = UInt(16 bits)
  val reqTag  = UInt(8 bits)
}

/**
 * Scheduler control plane for one GEMV Job.
 *
 * `start` is a one-cycle pulse that latches `job`; `done` pulses once all
 * M rows have been emitted on `qOut`. `busy` rejects new Jobs.
 */
case class GemvCtrl() extends Bundle with IMasterSlave {
  val job   = GemvJob()
  val start = Bool()
  val done  = Bool()
  val busy  = Bool()
  val error = Bool()

  /** Master = Scheduler side (drives job/start, observes done/busy/error). */
  override def asMaster(): Unit = {
    out(job, start)
    in(done, busy, error)
  }
}
