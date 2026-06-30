package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Questa smoke DUT: one-shot [[fp32Exp]] and [[fp32Div]] adapters with pin-level valid.
 */
class Fp32ExpDivSmokeTop extends Component {

  val io = new Bundle {
    val expInValid  = in Bool()
    val expInData   = in Bits(32 bits)
    val expOutValid = out Bool()
    val expOutData  = out Bits(32 bits)

    val divAValid   = in Bool()
    val divAData    = in Bits(32 bits)
    val divBValid   = in Bool()
    val divBData    = in Bits(32 bits)
    val divOutValid = out Bool()
    val divOutData  = out Bits(32 bits)
  }

  val expIn = Flow(Bits(32 bits))
  expIn.valid   := io.expInValid
  expIn.payload := io.expInData
  val expOut = fp32Exp.exp(expIn)
  io.expOutValid := expOut.valid
  io.expOutData  := expOut.payload

  val divA = Flow(Bits(32 bits))
  divA.valid   := io.divAValid
  divA.payload := io.divAData
  val divB = Flow(Bits(32 bits))
  divB.valid   := io.divBValid
  divB.payload := io.divBData
  val divOut = fp32Div.div(divA, divB)
  io.divOutValid := divOut.valid
  io.divOutData  := divOut.payload
}

/** Generates `util/gen/verilog/Fp32ExpDivSmokeTop.v` for Questa IP smoke test. */
object Fp32ExpDivGen extends App {
  val outDir = sys.env.getOrElse("UTIL_GEN_DIR", "util/gen/verilog")
  SpinalConfig(targetDirectory = outDir).generateVerilog(new Fp32ExpDivSmokeTop)
  println(s"Generated $outDir/Fp32ExpDivSmokeTop.v")
}
