package gemvService64

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import util.{RmsNormAlteraIpSim, VerilatorSimCompat, fp32MultAcc}

import scala.collection.mutable
import scala.language.postfixOps

/**
 * End-to-end Verilator control-flow smoke for [[GemvService64]].
 *
 * Wrapped in a harness so the 256-bit `weightBeat` payload stays internal (the
 * Verilator JNI wrapper cannot bind `VlWide` top ports); the harness presents a
 * narrow valid/ready handshake and ties the beat payload to 0.
 *
 * Exercises: actIn load → scale preload → Job start → tileFetch / weightBeat
 * handshake (behavioral DDR responder) → qOut. FP values are meaningless under
 * the sim IP stubs; this checks beat counts, tile iteration, in-flight gating,
 * `tlast`, and `ctrl.done` (FP accuracy is a Questa concern, design §15).
 */
class GemvServiceHarness(g: GemvGenerics) extends Component {
  val axisCfg = GemvAxisCfg()
  val io = new Bundle {
    val ctrl      = slave(GemvCtrl())
    val actIn     = slave(Axi4Stream(axisCfg))
    val scaleLoad = slave(Stream(Bits(g.fp16Width bits)))
    val wbValid   = in Bool ()
    val wbReady   = out Bool ()
    val tileFetch = master(Stream(TileFetchReq()))
    val qOut      = master(Axi4Stream(axisCfg))
    val dbgOverflow = out Bool ()
  }

  val svc = GemvService64(
    g,
    toFp32_func   = RmsNormAlteraIpSim.toFp32,
    toFp16_func   = RmsNormAlteraIpSim.toFp16,
    mul_func      = RmsNormAlteraIpSim.mul,
    add_func      = RmsNormAlteraIpSim.add,
    groupAcc_func = fp32MultAcc.firstAcc_sim
  )

  svc.io.ctrl.job   := io.ctrl.job
  svc.io.ctrl.start := io.ctrl.start
  io.ctrl.done  := svc.io.ctrl.done
  io.ctrl.busy  := svc.io.ctrl.busy
  io.ctrl.error := svc.io.ctrl.error

  svc.io.actIn     << io.actIn
  svc.io.scaleLoad << io.scaleLoad

  svc.io.weightBeat.valid   := io.wbValid
  svc.io.weightBeat.payload := B(0)
  io.wbReady := svc.io.weightBeat.ready

  io.tileFetch << svc.io.tileFetch
  io.qOut      << svc.io.qOut
  io.dbgOverflow := svc.io.dbgOverflow
}

object GemvService64Sim extends App {

  val simDim  = sys.env.getOrElse("GEMV_DIM", "2048").toInt
  val simRows = sys.env.getOrElse("GEMV_MAX_ROWS", "2048").toInt
  val g       = GemvGenerics(vectorDim = simDim, maxRows = scala.math.max(simRows, 1))

  val useWave = sys.env.getOrElse("GEMV_SIM_WAVE", "0") == "1"
  val baseCfg = SimConfig
    .workspacePath("gemvService64/gen/sim/GemvService64")
    .withConfig(SpinalConfig(targetDirectory = "gemvService64/gen/sim/hw"))
  val cfg = VerilatorSimCompat.withWDataCompat(
    if (useWave) baseCfg.withWave else baseCfg
  ).compile(new GemvServiceHarness(g))

  cfg.doSim { dut =>
    val tilesPerRow  = g.tilesPerRow
    val groupsPerRow = g.groupsPerRow
    val totalTiles   = simRows * tilesPerRow
    val totalScales  = simRows * groupsPerRow

    dut.io.actIn.valid #= false
    dut.io.actIn.payload.data #= 0
    dut.io.actIn.payload.last #= false
    dut.io.actIn.payload.user #= 0
    dut.io.scaleLoad.valid #= false
    dut.io.scaleLoad.payload #= 0
    dut.io.wbValid #= false
    dut.io.tileFetch.ready #= false
    dut.io.qOut.ready #= false
    dut.io.ctrl.start #= false
    dut.io.ctrl.job.op #= GemvOp.W_Q
    dut.io.ctrl.job.layer #= 0
    dut.io.ctrl.job.mRows #= simRows
    dut.io.ctrl.job.kCols #= simDim
    dut.io.ctrl.job.wBase #= 0
    dut.io.ctrl.job.scaleBase #= 0
    dut.io.ctrl.job.weightFmt #= WeightFmt.INT4_G128_SYM
    dut.io.ctrl.job.inputSrc #= InputSrc.ACT_BUF

    dut.clockDomain.forkStimulus(10)
    dut.clockDomain.waitSampling(5)

    for (k <- 0 until simDim) {
      dut.io.actIn.valid #= true
      dut.io.actIn.payload.data #= k & 0xFFFF
      dut.io.actIn.payload.last #= (k == simDim - 1)
      dut.clockDomain.waitSamplingWhere(dut.io.actIn.ready.toBoolean)
    }
    dut.io.actIn.valid #= false

    for (_ <- 0 until totalScales) {
      dut.io.scaleLoad.valid #= true
      dut.io.scaleLoad.payload #= 0x3C00
      dut.clockDomain.waitSamplingWhere(dut.io.scaleLoad.ready.toBoolean)
    }
    dut.io.scaleLoad.valid #= false
    dut.clockDomain.waitSampling(2)

    // behavioral DDR weight responder
    val reqQ = mutable.Queue[BigInt]()
    dut.io.tileFetch.ready #= true
    fork {
      while (true) {
        dut.clockDomain.waitSampling()
        if (dut.io.tileFetch.valid.toBoolean && dut.io.tileFetch.ready.toBoolean) {
          reqQ.enqueue(dut.io.tileFetch.payload.ddrAddr.toBigInt)
        }
      }
    }
    fork {
      while (true) {
        if (reqQ.nonEmpty) {
          reqQ.dequeue()
          dut.io.wbValid #= true
          dut.clockDomain.waitSamplingWhere(dut.io.wbReady.toBoolean)
          dut.io.wbValid #= false
        } else {
          dut.clockDomain.waitSampling()
        }
      }
    }

    fork {
      while (true) {
        dut.clockDomain.waitSampling()
        assert(!dut.io.dbgOverflow.toBoolean, "GemvOutputSer FIFO overflow (in-flight gating bug)")
      }
    }

    var outCnt  = 0
    var sawLast = false
    dut.io.qOut.ready #= true
    fork {
      while (true) {
        dut.clockDomain.waitSampling()
        if (dut.io.qOut.valid.toBoolean && dut.io.qOut.ready.toBoolean) {
          if (outCnt == simRows - 1) {
            assert(dut.io.qOut.payload.last.toBoolean, "last qOut beat must have tlast=1")
            sawLast = true
          } else {
            assert(!dut.io.qOut.payload.last.toBoolean, "non-final qOut beat must have tlast=0")
          }
          outCnt += 1
        }
      }
    }

    dut.io.ctrl.start #= true
    dut.clockDomain.waitSampling()
    dut.io.ctrl.start #= false

    var doneSeen  = false
    var timeout   = 0
    val maxCycles = (totalTiles + simRows) * 100 + 5000
    while (!doneSeen && timeout < maxCycles) {
      dut.clockDomain.waitSampling()
      if (dut.io.ctrl.done.toBoolean) doneSeen = true
      timeout += 1
    }

    assert(doneSeen, s"timeout waiting for ctrl.done (outCnt=$outCnt/$simRows, reqQ=${reqQ.size})")
    assert(outCnt == simRows, s"expected $simRows qOut beats, got $outCnt")
    assert(sawLast, "did not observe tlast on final qOut beat")
    println(s"GemvService64: dim=$simDim rows=$simRows tiles=$totalTiles -> $outCnt qOut beats, tlast OK, done OK")
    println("(FP golden: run make questa)")
    simSuccess()
  }
}
