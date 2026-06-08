package rmsNorm

/** Elaboration-time vector length for [[RmsNormCore]] / [[RmsNormAxiTop]]. */
case class RmsNormGenerics(
  dim:       Int = 2048,
  /** Depth of activation / gamma [[spinal.lib.StreamFifo]] (same-clock, inferred RAM). */
  fifoDepth: Int = 2048
)
