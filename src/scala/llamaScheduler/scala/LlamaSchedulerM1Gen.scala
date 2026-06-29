package llamaScheduler

import spinal.core._

object LlamaSchedulerM1Gen {
  def main(args: Array[String]): Unit = {
    val targetDir = args.headOption.getOrElse("llamaScheduler/gen/verilog")
    SpinalConfig(targetDirectory = targetDir).generateVerilog(new LlamaSchedulerM1())
  }
}
