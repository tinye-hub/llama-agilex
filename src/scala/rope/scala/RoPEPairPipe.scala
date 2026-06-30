package rope

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/** One RoPE pair: (y0,y1) = rotate((x0,x1), cos, sin). */
class RoPEPairPipe(
    mulFp16: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RoPEAlteraIp.mulFp16Fn,
    addFp16: (Flow[Bits], Flow[Bits]) => Flow[Bits] = RoPEAlteraIp.addFp16Fn
) extends Component {

  val io = new Bundle {
    val start = in Bool()
    val x0    = in Bits (16 bits)
    val x1    = in Bits (16 bits)
    val cos   = in Bits (16 bits)
    val sin   = in Bits (16 bits)
    val y0    = out Bits (16 bits)
    val y1    = out Bits (16 bits)
    val done  = out Bool()
  }

  val busy = Reg(Bool()) init (False)
  val fire = Reg(Bool()) init (False)
  val x0h  = Reg(Bits(16 bits))
  val x1h  = Reg(Bits(16 bits))
  val cosh = Reg(Bits(16 bits))
  val sinh = Reg(Bits(16 bits))
  val y0Hold = Reg(Bits(16 bits))
  val y1Hold = Reg(Bits(16 bits))

  when(io.start && !busy) {
    fire := True
    busy := True
    x0h  := io.x0
    x1h  := io.x1
    cosh := io.cos
    sinh := io.sin
  } otherwise {
    fire := False
  }

  val negX1 = Bits(16 bits)
  negX1 := (~x1h.msb ## x1h.dropHigh(1))

  val x0f = Flow(Bits(16 bits))
  val x1f = Flow(Bits(16 bits))
  val cosf = Flow(Bits(16 bits))
  val sinf = Flow(Bits(16 bits))
  x0f.valid   := fire
  x0f.payload := x0h
  x1f.valid   := fire
  x1f.payload := x1h
  cosf.valid  := fire
  cosf.payload := cosh
  sinf.valid  := fire
  sinf.payload := sinh

  val negX1f = Flow(Bits(16 bits))
  negX1f.valid   := fire
  negX1f.payload := negX1

  val x0Cos = mulFp16(x0f, cosf)
  val x1Sin = mulFp16(negX1f, sinf)
  val x0Sin = mulFp16(x0f, sinf)
  val x1Cos = mulFp16(x1f, cosf)

  val y0f = addFp16(x0Cos, x1Sin)
  val y1f = addFp16(x0Sin, x1Cos)

  val resultValid = y0f.valid && y1f.valid && busy
  val donePulse   = resultValid

  when(donePulse) {
    y0Hold := y0f.payload
    y1Hold := y1f.payload
    busy   := False
  }

  io.y0   := y0f.payload
  io.y1   := y1f.payload
  io.done := donePulse
}
