package top

import spinal.core._

/** Milestone 1 top-level elaboration parameters. */
case class LlamaM1Generics(
  dim:          Int     = 2048,
  /** When true, use [[util.RmsNormAlteraIpSim]] instead of Quartus IP black boxes. */
  useSimIp:     Boolean = false,
  /** AXI4 data width for [[ddrAgent.DdrAgentM1]] (256 for fabric EMIF, 64 for fast Verilator sim). */
  axiDataWidth: Int     = 256
)
