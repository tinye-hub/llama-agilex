package ddrAgent

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/** AXI4 parameters for DE25-Nano LPDDR4B fabric EMIF (256-bit data). */
object DdrAgentAxi {
  def dataBytesOf(cfg: Axi4Config): Int = cfg.dataWidth / 8
  val burstBytes = 256

  def burstBeatsOf(cfg: Axi4Config): Int = burstBytes / dataBytesOf(cfg)

  def config(dataWidth: Int = 256): Axi4Config = Axi4Config(
    addressWidth = 32,
    dataWidth    = dataWidth,
    idWidth      = 4,
    useId        = true,
    useRegion    = false,
    useBurst     = true,
    useLock      = false,
    useCache     = false,
    useSize      = true,
    useQos       = false,
    useLen       = true,
    useLast      = true,
    useResp      = true,
    useProt      = false,
    useStrb      = false
  )
}
