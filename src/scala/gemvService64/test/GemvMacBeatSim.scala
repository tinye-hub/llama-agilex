package gemvService64

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import util.{RmsNormAlteraIpSim, VerilatorSimCompat, fp32MultAcc}

import scala.language.postfixOps

/**
 * a1 Verilator smoke: [[GemvActBuffer]] data path + [[GemvMacBeat]] control flow.
 *
 * Both DUTs are wrapped in thin harnesses so no top-level port exceeds 64 bits
 * (the SpinalHDL Verilator JNI wrapper cannot bind `VlWide` signals). The
 * 1024-bit activation / weight words stay internal.
 *
 * - ActBuffer is pure logic → real data check (lane mapping, wide read).
 * - MacBeat uses [[RmsNormAlteraIpSim]] timing stubs → control-flow only
 *   (one `rowOut` beat per row); FP values are tested under Questa.
 */

/** Narrow-port harness exposing one ActBuffer lane at a time. */
class ActBufHarness(g: GemvGenerics) extends Component {
  val io = new Bundle {
    val actIn    = slave(Stream(Bits(g.fp16Width bits)))
    val tileSel  = in UInt (log2Up(g.tilesPerRow) bits)
    val laneSel  = in UInt (log2Up(g.bankLen) bits)
    val laneData = out Bits (g.fp16Width bits)
    val loaded   = out Bool ()
    val clear    = in Bool ()
  }
  val ab = new GemvActBuffer(g)
  ab.io.actIn   << io.actIn
  ab.io.tileSel := io.tileSel.resized
  ab.io.clear   := io.clear
  io.loaded     := ab.io.loaded
  io.laneData   := ab.io.tileData.subdivideIn(g.fp16Width bits)(io.laneSel)
}

/** Narrow-port harness for MacBeat (wide operands tied internally). */
class MacBeatHarness(g: GemvGenerics) extends Component {
  val io = new Bundle {
    val beatValid = in Bool ()
    val beatLast  = in Bool ()
    val rowValid  = out Bool ()
    val rowData   = out Bits (g.fp16Width bits)
  }
  val mac = GemvMacBeat(
    g,
    toFp32_func   = RmsNormAlteraIpSim.toFp32,
    toFp16_func   = RmsNormAlteraIpSim.toFp16,
    mul_func      = RmsNormAlteraIpSim.mul,
    add_func      = RmsNormAlteraIpSim.add,
    groupAcc_func = fp32MultAcc.firstAcc_sim
  )
  mac.io.beatValid := io.beatValid
  mac.io.beatLast  := io.beatLast
  mac.io.xWide     := B(0)
  mac.io.wWide     := B(0)
  mac.io.scaleFp32 := B(0x3F800000L, 32 bits)
  io.rowValid      := mac.io.rowOut.valid
  io.rowData       := mac.io.rowOut.payload
}

object GemvMacBeatSim extends App {

  val simDim  = sys.env.getOrElse("GEMV_DIM", "2048").toInt
  val simRows = sys.env.getOrElse("GEMV_MAX_ROWS", "2048").toInt
  val g       = GemvGenerics(vectorDim = simDim, maxRows = scala.math.max(simRows, 1))

  // --- Part 1: GemvActBuffer narrow write / wide read data correctness ---
  {
    val cfg = VerilatorSimCompat.withWDataCompat(
      SimConfig
        .withWave
        .workspacePath("gemvService64/gen/sim/GemvActBuffer")
        .withConfig(SpinalConfig(targetDirectory = "gemvService64/gen/sim/hw"))
    ).compile(new ActBufHarness(g))

    cfg.doSim { dut =>
      dut.io.actIn.valid #= false
      dut.io.tileSel #= 0
      dut.io.laneSel #= 0
      dut.io.clear #= false
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.waitSampling(3)

      for (k <- 0 until simDim) {
        dut.io.actIn.valid #= true
        dut.io.actIn.payload #= k & 0xFFFF
        dut.clockDomain.waitSamplingWhere(dut.io.actIn.ready.toBoolean)
      }
      dut.io.actIn.valid #= false
      dut.clockDomain.waitSampling(2)
      assert(dut.io.loaded.toBoolean, "ActBuffer should be loaded after dim beats")

      val tiles = simDim / g.bankLen
      for (t <- 0 until tiles; j <- 0 until g.bankLen) {
        dut.io.tileSel #= t
        dut.io.laneSel #= j
        dut.clockDomain.waitSampling()
        val lane = dut.io.laneData.toInt
        val exp  = (t * g.bankLen + j) & 0xFFFF
        assert(lane == exp, s"tile $t lane $j: got $lane expected $exp")
      }
      println(s"GemvActBuffer: $tiles tiles × ${g.bankLen} lanes wide-read OK")
      simSuccess()
    }
  }

  // --- Part 2: GemvMacBeat control flow (one rowOut per row) ---
  {
    val cfg = VerilatorSimCompat.withWDataCompat(
      SimConfig
        .withWave
        .workspacePath("gemvService64/gen/sim/GemvMacBeat")
        .withConfig(SpinalConfig(targetDirectory = "gemvService64/gen/sim/hw"))
    ).compile(new MacBeatHarness(g))

    cfg.doSim { dut =>
      val rows  = 4
      val tiles = g.tilesPerRow

      dut.io.beatValid #= false
      dut.io.beatLast #= false
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.waitSampling(3)

      var rowOutCnt = 0
      fork {
        while (true) {
          dut.clockDomain.waitSampling()
          if (dut.io.rowValid.toBoolean) rowOutCnt += 1
        }
      }

      for (_ <- 0 until rows; t <- 0 until tiles) {
        dut.io.beatValid #= true
        dut.io.beatLast #= (t == tiles - 1)
        dut.clockDomain.waitSampling()
      }
      dut.io.beatValid #= false
      dut.io.beatLast #= false
      dut.clockDomain.waitSampling(200)

      assert(rowOutCnt == rows, s"expected $rows rowOut beats, got $rowOutCnt")
      println(s"GemvMacBeat: $rowOutCnt/$rows row results emitted (control-flow OK; FP via questa)")
      simSuccess()
    }
  }
}
