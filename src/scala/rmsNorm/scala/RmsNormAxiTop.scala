package rmsNorm

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axis._
import util.RmsNormAlteraIp

import scala.language.postfixOps

object RmsNormAxisCfg {
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

object RmsNormAxiTop {
  def apply(
    dim: Int,
    toFp32_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.toFp32,
    toFp16_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.toFp16,
    mul_func: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RmsNormAlteraIp.mul,
    sqrSum_func: Flow[Fragment[Bits]] => Flow[Fragment[Bits]] = RmsNormAlteraIp.sqrSum,
    add_func: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RmsNormAlteraIp.add,
    rsqrt_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.rsqrt
  ): RmsNormAxiTop =
    new RmsNormAxiTop(RmsNormGenerics(dim), toFp32_func, toFp16_func, mul_func, sqrSum_func, add_func, rsqrt_func)
}

/**
 * AXI4-Stream wrapper around [[RmsNormCore]]; vector length is [[RmsNormGenerics.dim]].
 */
class RmsNormAxiTop(
  val g: RmsNormGenerics,
  toFp32_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.toFp32,
  toFp16_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.toFp16,
  mul_func: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RmsNormAlteraIp.mul,
  sqrSum_func: Flow[Fragment[Bits]] => Flow[Fragment[Bits]] = RmsNormAlteraIp.sqrSum,
  add_func: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RmsNormAlteraIp.add,
  rsqrt_func: Flow[Bits] => Flow[Bits] = RmsNormAlteraIp.rsqrt
) extends Component {

  val axisCfg = RmsNormAxisCfg()
  val dim     = g.dim

  val io = new Bundle {
    val dataIn   = slave(Axi4Stream(axisCfg))
    val weightIn = slave(Axi4Stream(axisCfg))
    val dataOut  = master(Axi4Stream(axisCfg))
  }

  val core = new RmsNormCore(g, toFp32_func, toFp16_func, mul_func, sqrSum_func, add_func, rsqrt_func)

  // 1-cycle input pipes: break ddrAgent → collect/sqrSum and gamma → weight timing paths.
  val dataStream = Stream(Bits(16 bits))
  val dataInValid = RegInit(False)
  val dataInData  = Reg(Bits(16 bits))
  io.dataIn.ready := !dataInValid || dataStream.ready
  val dataInFire   = dataInValid && dataStream.ready
  val dataStageFire = io.dataIn.valid && (!dataInValid || dataStream.ready)
  when(dataStageFire) {
    dataInValid := True
    dataInData  := io.dataIn.payload.data
  }.elsewhen(dataInFire) {
    dataInValid := False
  }
  dataStream.valid   := dataInValid
  dataStream.payload := dataInData

  val weightStream = Stream(Bits(16 bits))
  val weightInValid = RegInit(False)
  val weightInData  = Reg(Bits(16 bits))
  io.weightIn.ready := !weightInValid || weightStream.ready
  val weightInFire   = weightInValid && weightStream.ready
  val weightStageFire = io.weightIn.valid && (!weightInValid || weightStream.ready)
  when(weightStageFire) {
    weightInValid := True
    weightInData  := io.weightIn.payload.data
  }.elsewhen(weightInFire) {
    weightInValid := False
  }
  weightStream.valid   := weightInValid
  weightStream.payload := weightInData

  core.io.dataIn   << dataStream
  core.io.weightIn << weightStream

  val outFifoDepth = 16
  val outFifoOccWidth = log2Up(outFifoDepth + 1)
  val outFifo = StreamFifo(
    dataType = Bits(16 bits),
    depth    = outFifoDepth
  )

  val outFifoEmpty = outFifo.io.occupancy === U(0, outFifoOccWidth bits)
  core.io.emitAllow := outFifoEmpty && io.dataOut.ready

  val outPush = Stream(Bits(16 bits))
  outPush.valid   := core.io.dataOut.valid
  outPush.payload := core.io.dataOut.payload
  outFifo.io.push << outPush

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
  val outLast    = outBeatCnt === U(dim - 1, log2Up(dim + 1) bits)
  when(outFifo.io.pop.fire) {
    outBeatCnt := outBeatCnt + 1
    when(outLast) {
      outBeatCnt := 0
    }
  }

  val outUser16 = Bits(16 bits)
  outUser16(14 downto 0) := contextUser
  outUser16(15)          := !outLast

  io.dataOut.valid := outFifo.io.pop.valid
  io.dataOut.payload.data := outFifo.io.pop.payload
  io.dataOut.payload.keep.setAll()
  io.dataOut.payload.last := outLast
  io.dataOut.payload.user := outUser16.resized
  outFifo.io.pop.ready := io.dataOut.ready
}
