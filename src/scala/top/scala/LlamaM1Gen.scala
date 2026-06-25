package top

import spinal.core._

/** Generate synthesis Verilog for [[LlamaM1Top]] into `top/gen/verilog/`. */
object LlamaM1Gen extends App {
  val dim    = sys.env.getOrElse("LLAMA_M1_DIM", "2048").toInt
  val useSim = sys.env.getOrElse("LLAMA_M1_SIM_IP", "0") == "1"
  val outDir = sys.env.getOrElse("LLAMA_M1_GEN_DIR", "top/gen/verilog")

  val g = LlamaM1Generics(dim = dim, useSimIp = useSim)

  SpinalConfig(
    targetDirectory = outDir,
    oneFilePerComponent = false
  ).generateVerilog(LlamaM1Top(g))

  println(s"Generated $outDir/LlamaM1Top.v (dim=$dim, useSimIp=$useSim)")
}
