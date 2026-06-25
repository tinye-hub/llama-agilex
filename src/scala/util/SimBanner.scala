package util

import java.io.FileOutputStream
import java.nio.charset.StandardCharsets

/**
 * Colored PASS/FAIL for Scala code paths (optional).
 *
 * For `make verilator`, use `scripts/sbt-runmain.sh` — see doc/simulation-conventions.md.
 */
object SimBanner {
  private val Green = "\u001b[32m"
  private val Red   = "\u001b[31m"
  private val Reset = "\u001b[0m"

  def pass(): Unit = emit(s"${Green}********** PASS **********${Reset}")

  def fail(): Unit = emit(s"${Red}********** FAIL **********${Reset}")

  private def emit(msg: String): Unit = {
    val bytes = (msg + "\n").getBytes(StandardCharsets.UTF_8)
    if (!writeDevTty(bytes)) {
      val fd = new FileOutputStream(java.io.FileDescriptor.out)
      fd.write(bytes)
      fd.flush()
    }
  }

  private def writeDevTty(bytes: Array[Byte]): Boolean =
    try {
      val tty = new FileOutputStream("/dev/tty")
      try {
        tty.write(bytes)
        tty.flush()
        true
      } finally {
        tty.close()
      }
    } catch {
      case _: Exception => false
    }
}
