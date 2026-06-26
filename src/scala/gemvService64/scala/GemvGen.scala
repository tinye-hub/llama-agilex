package gemvService64

import spinal.core._

/** Generate synthesis Verilog for GemvService64 into `gemvService64/gen/verilog/`. */
object GemvServiceGen extends App {
  val dim    = sys.env.getOrElse("GEMV_DIM", "2048").toInt
  val maxM   = sys.env.getOrElse("GEMV_MAX_ROWS", "2048").toInt
  val outDir = sys.env.getOrElse("GEMV_GEN_DIR", "gemvService64/gen/verilog")

  val g = GemvGenerics(vectorDim = dim, maxRows = maxM)

  SpinalConfig(
    targetDirectory = outDir,
    oneFilePerComponent = false
  ).generateVerilog(GemvService64(g))

  println(s"Generated $outDir/GemvService64.v (dim=$dim, maxRows=$maxM)")
}

/** Generate the a1 MAC core in isolation (control-flow / resource bring-up). */
object GemvMacBeatGen extends App {
  val outDir = sys.env.getOrElse("GEMV_GEN_DIR", "gemvService64/gen/verilog")
  SpinalConfig(targetDirectory = outDir, oneFilePerComponent = false)
    .generateVerilog(GemvMacBeat(GemvGenerics()))
  println(s"Generated $outDir/GemvMacBeat.v")
}
