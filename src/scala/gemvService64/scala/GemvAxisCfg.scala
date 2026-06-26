package gemvService64

import spinal.lib.bus.amba4.axis._

/**
 * AXI4-Stream config for GEMV activation in (`actIn`) and result out (`qOut`).
 *
 * Identical shape to `RmsNormAxisCfg` (16-bit FP16, useUser=16) so the
 * RMSNorm output stream connects to `actIn` with no width adaptation, and
 * `qOut` carries a `tuser` context (design §9.4).
 */
object GemvAxisCfg {
  def apply(): Axi4StreamConfig = Axi4StreamConfig(
    dataWidth = 2,
    useKeep   = true,
    useStrb   = false,
    useLast   = true,
    useId     = false,
    useDest   = false,
    useUser   = true,
    userWidth = 16
  )
}
