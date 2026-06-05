package rmsNorm

import spinal.core._

/** Generate synthesis Verilog for [[RmsNormAxiTop]] into `rmsNorm/gen/verilog/`. */
object RmsNormGen extends App {
  val dim    = sys.env.getOrElse("RMSNORM_DIM", "2048").toInt
  val outDir = sys.env.getOrElse("RMSNORM_GEN_DIR", "rmsNorm/gen/verilog")

  SpinalConfig(
    targetDirectory = outDir,
    oneFilePerComponent = false
  ).generateVerilog(RmsNormAxiTop(dim = dim))

  println(s"Generated $outDir/RmsNormAxiTop.v (dim=$dim)")
}
