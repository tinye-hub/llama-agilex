package top

import spinal.core._

/** Generate synthesis Verilog for [[LlamaM2aTop]] into `top/gen/verilog/`. */
object LlamaM2aGen extends App {
  val dim    = sys.env.getOrElse("LLAMA_M2A_DIM", sys.env.getOrElse("LLAMA_M1_DIM", "2048")).toInt
  val gemvM  = sys.env.getOrElse("LLAMA_M2A_M", sys.env.getOrElse("GEMV_MAX_ROWS", "2048")).toInt
  val useSim = sys.env.getOrElse("LLAMA_M2A_SIM_IP", sys.env.getOrElse("LLAMA_M1_SIM_IP", "0")) == "1"
  val outDir = sys.env.getOrElse("LLAMA_M2A_GEN_DIR", "top/gen/verilog")

  val g = LlamaM2aGenerics(dim = dim, gemvM = gemvM, useSimIp = useSim)

  SpinalConfig(
    targetDirectory = outDir,
    oneFilePerComponent = false
  ).generateVerilog(LlamaM2aTop(g))

  println(s"Generated $outDir/LlamaM2aTop.v (dim=$dim, gemvM=$gemvM, useSimIp=$useSim)")
}
