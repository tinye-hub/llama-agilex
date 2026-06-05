ThisBuild / version      := "0.1.0"
ThisBuild / scalaVersion := "2.12.18"
ThisBuild / organization := "llama.agilex"

val spinalVersion = "1.12.2"
val spinalCore    = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib     = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdsl    = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)

lazy val llamaAgilex = (project in file("."))
  .settings(
    name := "llama-agilex-scala",
    Compile / scalaSource := baseDirectory.value,
    libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdsl),
    fork := true,
    // `scripts/make` patches Spinal Verilator JNI wrapper for Verilator 5.036+ (WData typedef).
    run / envVars ++= {
      val scripts = (baseDirectory.value / "scripts").getAbsolutePath
      Map("PATH" -> s"$scripts:${sys.env.getOrElse("PATH", "")}")
    },
  )
