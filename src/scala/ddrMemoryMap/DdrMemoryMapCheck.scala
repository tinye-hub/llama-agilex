package ddrMemoryMap

/** `sbt "runMain ddrMemoryMap.DdrMemoryMapCheck"` — spot-check [[DdrMemoryMap]] against ddr-memory-map.md */
object DdrMemoryMapCheck extends App {
  DdrMemoryMap.sanityCheck()
  println("DdrMemoryMap.sanityCheck() passed.")
  println(f"  embSize       = 0x${DdrMemoryMap.embSize}%08X")
  println(f"  rmsGammaBase  = 0x${DdrMemoryMap.rmsGammaBase}%08X")
  println(f"  gamma L0 norm1 = 0x${DdrMemoryMap.gammaAddr(0, DdrMemoryMap.NormKind.norm1)}%08X")
  println(f"  emb tok 128255 = 0x${DdrMemoryMap.embRowBase(128255)}%08X")
}
