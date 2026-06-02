package rmsNorm

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import util.RmsNormAlteraIp

import scala.language.postfixOps

object RmsNormAxisCfg {
  /** `dataWidth` is in bytes (Spinal convention): 2 bytes = one FP16 beat. */
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

/**
 * AXI4-Stream wrapper around [[RmsNormCore]] (Llama 3.2 1B default dim = 2048).
 */
class RmsNormAxiTop(
  val dim: Int,
  toFp32_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.toFp32,
  toFp16_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.toFp16,
  mul_func: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RmsNormAlteraIp.mul,
  mul_func_block: (Stream[Bits], Stream[Bits]) => Stream[Bits] = RmsNormAlteraIp.mulBlock,
  acc_func: Flow[Fragment[Bits]] => Flow[Fragment[Bits]] = RmsNormAlteraIp.acc,
  add_func: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RmsNormAlteraIp.add,
  rsqrt_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.rsqrt
) extends Component {

  val axisCfg = RmsNormAxisCfg()

  val io = new Bundle {
    val dataIn   = slave(Axi4Stream(axisCfg))
    val weightIn = slave(Axi4Stream(axisCfg))
    val dataOut  = master(Axi4Stream(axisCfg))
  }

  val core = new RmsNormCore(
    dim,
    toFp32_func, toFp16_func, mul_func, mul_func_block, acc_func, add_func, rsqrt_func
  )

  val dataStream = Stream(Bits(16 bits))
  dataStream.valid   := io.dataIn.valid
  dataStream.payload := io.dataIn.payload.data
  io.dataIn.ready    := dataStream.ready

  val weightStream = Stream(Bits(16 bits))
  weightStream.valid   := io.weightIn.valid
  weightStream.payload := io.weightIn.payload.data
  io.weightIn.ready    := weightStream.ready

  core.io.dataIn   << dataStream
  core.io.weightIn << weightStream

  val outStream = Stream(Bits(16 bits))
  outStream << core.io.dataOut

  val contextUser = Reg(Bits(15 bits)) init (0)
  val inBeatCnt   = Reg(UInt(log2Up(dim + 1) bits)) init (0)
  when(io.dataIn.fire) {
    when(inBeatCnt === 0) {
      contextUser := io.dataIn.payload.user(14 downto 0)
    }
    inBeatCnt := inBeatCnt + 1
    when(io.dataIn.payload.last) {
      inBeatCnt := 0
    }
  }

  val outBeatCnt = Reg(UInt(log2Up(dim + 1) bits)) init (0)
  val outLast    = outBeatCnt === dim - 1
  when(io.dataOut.fire) {
    outBeatCnt := outBeatCnt + 1
    when(outLast) {
      outBeatCnt := 0
    }
  }

  val outUser16 = Bits(16 bits)
  outUser16(14 downto 0) := contextUser
  outUser16(15)          := !outLast

  io.dataOut.valid := outStream.valid
  io.dataOut.payload.data := outStream.payload
  io.dataOut.payload.keep.setAll()
  io.dataOut.payload.last := outLast
  io.dataOut.payload.user := outUser16.resized
  outStream.ready := io.dataOut.ready
}
