package util

import spinal.core.sim.SpinalSimConfig

import java.io.File
import java.lang.reflect.Field

/** Verilator 5.036+ / SpinalHDL sim: patch JNI wrapper before `make`. */
object VerilatorSimCompat {
  private val patchMake = new File("scripts/patch_verilator_make.sh")

  def withWDataCompat(cfg: SpinalSimConfig): SpinalSimConfig = {
    require(
      patchMake.isFile,
      s"Missing ${patchMake.getAbsolutePath} (run sbt from src/scala/)"
    )
    setMakeCmd(patchMake.getAbsolutePath)
    cfg
  }

  private def setMakeCmd(path: String): Unit = {
    try {
      val spinalEnv = Class.forName("spinal.SpinalEnv")
      val field: Field = spinalEnv.getDeclaredField("makeCmd")
      field.setAccessible(true)
      field.set(spinalEnv.getField("MODULE$").get(null), path)
    } catch {
      case _: Exception =>
        // Fallback: scripts/make on PATH via build.sbt run / envVars
    }
  }
}
