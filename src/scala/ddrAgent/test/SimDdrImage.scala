package ddrAgent

import java.nio.file.{Files, Path, Paths}

/** Load a prebuilt DDR image file for simulation (mmap-style byte array). */
object SimDdrImage {

  val defaultPath: Path =
    Paths.get("tools/ddr_pack/out/ddr_image_m1.bin")

  def resolvePath(): Path = {
    sys.env.get("DDR_IMAGE") match {
      case Some(p) => Paths.get(p)
      case None =>
        val candidates = Seq(
          defaultPath,
          Paths.get("../../tools/ddr_pack/out/ddr_image_m1.bin"),
          Paths.get("../../../tools/ddr_pack/out/ddr_image_m1.bin")
        )
        candidates.find(p => Files.isRegularFile(p)).getOrElse {
          throw new IllegalArgumentException(
            s"DDR image not found. Set DDR_IMAGE or run: make -C tools/ddr_pack pack-m1\n" +
              s"Tried: ${candidates.mkString(", ")}"
          )
        }
    }
  }

  def load(path: Path = resolvePath()): Array[Byte] = {
    val bytes = Files.readAllBytes(path)
    println(s"SimDdrImage: loaded ${bytes.length} bytes from $path")
    bytes
  }

  /** Read `len` bytes from DDR image (for GEMV INT4 tile golden). */
  def readBytes(image: Array[Byte], byteAddr: Long, len: Int): Array[Byte] = {
    val base = byteAddr.toInt
    require(base >= 0 && base + len <= image.length, s"byte read OOB @ 0x${byteAddr.toHexString}")
    java.util.Arrays.copyOfRange(image, base, base + len)
  }

  /** Pack little-endian bytes into a 256-bit beat (byte0 = LSB). */
  def packAxiBeat(bytes: Array[Byte], dataWidth: Int = 256): BigInt = {
    require(bytes.length <= dataWidth / 8)
    var acc = BigInt(0)
    var i = 0
    while (i < bytes.length) {
      acc |= BigInt(bytes(i) & 0xff) << (8 * i)
      i += 1
    }
    acc
  }

  def rowFp16Bits(image: Array[Byte], byteAddr: Long, dim: Int = 2048): Array[Int] = {
    val base = byteAddr.toInt
    require(base >= 0 && base + dim * 2 <= image.length, s"row read OOB @ 0x${byteAddr.toHexString}")
    val out = new Array[Int](dim)
    var i = 0
    while (i < dim) {
      val off = base + i * 2
      out(i) = (image(off) & 0xff) | ((image(off + 1) & 0xff) << 8)
      i += 1
    }
    out
  }
}
