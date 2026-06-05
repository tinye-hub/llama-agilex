package util

import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Wraps [[IntelFpFunctionsBlackBox]] with Spinal `Flow` valid/payload semantics.
 */
class FpFunctionsUnaryAdapter(
  val ipName:      String,
  val latency:     Int,
  val inputWidth:  Int,
  val outputWidth: Int
) extends Component {

  val io = new Bundle {
    val a = slave(Flow(Bits(inputWidth bits)))
    val r = master(Flow(Bits(outputWidth bits)))
  }

  val ip = new IntelFpFunctionsBlackBox(ipName, inputWidth, outputWidth)
  ip.io.en     := io.a.valid.asBits
  ip.io.a      := io.a.payload

  if (latency == 0) {
    io.r.valid   := io.a.valid
    io.r.payload := ip.io.q
  } else {
    io.r.valid   := Delay(io.a.valid, latency, init = False)
    io.r.payload := Delay(ip.io.q, latency)
  }
}

/**
 * FP32 multiply via [[IntelFpMultAccBlackBox]] with `accumulate = 0`.
 */
class FpMultAccMulAdapter(
  val ipName:       String,
  val latency:      Int,
  val ipResultShim: Int = 0
) extends Component {

  val io = new Bundle {
    val a = slave(Flow(Bits(32 bits)))
    val b = slave(Flow(Bits(32 bits)))
    val r = master(Flow(Bits(32 bits)))
  }

  val ip = new IntelFpMultAccBlackBox(ipName)
  ip.io.ena         := B(7, 3 bits)
  ip.io.accumulate  := False
  ip.io.fp32_mult_a := io.a.payload
  ip.io.fp32_mult_b := io.b.payload

  val fire = io.a.valid && io.b.valid
  if (latency == 0) {
    io.r.valid   := fire
    io.r.payload := ip.io.fp32_result
  } else {
    io.r.valid := Delay(fire, latency, init = False)
    if (ipResultShim == 0) {
      io.r.payload := ip.io.fp32_result
    } else {
      io.r.payload := Delay(ip.io.fp32_result, ipResultShim)
    }
  }
}

/**
 * Serial sum of squares on one [[IntelFpMultAccBlackBox]]: `sum += x*x`.
 *
 * Uses native FP DSP [multiply-with-accumulation](https://docs.altera.com/r/docs/813968/25.1/variable-precision-dsp-blocks-user-guide-agilextm-5-fpgas-and-socs/native-floating-point-dsp-agilextm-fpga-ip-supported-operational-modes):
 * first beat `accumulate=0` → `x*x`; later beats `accumulate=1` → `x*x + result(t-1)`.
 */
class FpMultAccSqrSumAdapter(
  val ipName:       String,
  val latency:      Int,
  val ipResultShim: Int = 0
) extends Component {

  val io = new Bundle {
    val accIn  = slave(Flow(Fragment(Bits(32 bits))))
    val accOut = master(Flow(Fragment(Bits(32 bits))))
  }

  val ip = new IntelFpMultAccBlackBox(ipName)
  ip.io.ena := B(7, 3 bits)
  // IP runs every cycle (ena tied high); when !valid, feed 0 so 0*0 adds nothing to the acc chain.
  val accOperand = Mux(io.accIn.valid, io.accIn.fragment, B(0, 32 bits))
  ip.io.fp32_mult_a := accOperand
  ip.io.fp32_mult_b := accOperand

  val isFirst = RegInit(True)
  // Keep accumulate=1 on the last input beat; reset isFirst only after the MAC pipeline drains.
  when(io.accIn.fire && !io.accIn.last) {
    isFirst := False
  }
  if (latency == 0) {
    when(io.accIn.fire && io.accIn.last) {
      isFirst := True
    }
  } else {
    when(Delay(io.accIn.fire && io.accIn.last, latency, init = False)) {
      isFirst := True
    }
  }

  ip.io.accumulate := !isFirst

  if (latency == 0) {
    io.accOut.valid    := io.accIn.valid
    io.accOut.last     := io.accIn.last
    io.accOut.fragment := ip.io.fp32_result
  } else {
    io.accOut.valid := Delay(io.accIn.valid, latency, init = False)
    io.accOut.last  := Delay(io.accIn.last & io.accIn.valid, latency, init = False)
    if (ipResultShim == 0) {
      io.accOut.fragment := ip.io.fp32_result
    } else {
      io.accOut.fragment := Delay(ip.io.fp32_result, ipResultShim)
    }
  }
}

/**
 * Serial sum of FP32 values using [[IntelFpMultAccBlackBox]] accumulate mode.
 *
 * Each beat adds `accIn.fragment` via `result = prev + fragment * 1.0` after the first beat.
 * Matches Xilinx `fp32acc22.acc` `Flow[Fragment]` contract used in RMSNormFp32.
 */
class FpMultAccSerialAccAdapter(
  val ipName:       String,
  val latency:      Int,
  val ipResultShim: Int = 0
) extends Component {

  val io = new Bundle {
    val accIn  = slave(Flow(Fragment(Bits(32 bits))))
    val accOut = master(Flow(Fragment(Bits(32 bits))))
  }

  val ip = new IntelFpMultAccBlackBox(ipName)
  ip.io.ena := B(7, 3 bits)
  val fp32One = B(0x3F800000, 32 bits) // 1.0
  val accOperand = Mux(io.accIn.valid, io.accIn.fragment, B(0, 32 bits))
  ip.io.fp32_mult_a := accOperand
  ip.io.fp32_mult_b := Mux(io.accIn.valid, fp32One, B(0, 32 bits))

  val isFirst = RegInit(True)
  when(io.accIn.fire && !io.accIn.last) {
    isFirst := False
  }
  if (latency == 0) {
    when(io.accIn.fire && io.accIn.last) {
      isFirst := True
    }
  } else {
    when(Delay(io.accIn.fire && io.accIn.last, latency, init = False)) {
      isFirst := True
    }
  }

  ip.io.accumulate := !isFirst

  if (latency == 0) {
    io.accOut.valid   := io.accIn.valid
    io.accOut.last    := io.accIn.last
    io.accOut.fragment := ip.io.fp32_result
  } else {
    io.accOut.valid := Delay(io.accIn.valid, latency, init = False)
    io.accOut.last  := Delay(io.accIn.last & io.accIn.valid, latency, init = False)
    if (ipResultShim == 0) {
      io.accOut.fragment := ip.io.fp32_result
    } else {
      io.accOut.fragment := Delay(ip.io.fp32_result, ipResultShim)
    }
  }
}

/**
 * FP32 add via [[IntelFpAddBlackBox]].
 */
class FpAddAdapter(
  val ipName:  String,
  val latency: Int
) extends Component {

  val io = new Bundle {
    val a = slave(Flow(Bits(32 bits)))
    val b = slave(Flow(Bits(32 bits)))
    val r = master(Flow(Bits(32 bits)))
  }

  val ip = new IntelFpAddBlackBox(ipName)
  ip.io.ena          := B(7, 3 bits)
  ip.io.fp32_adder_a := io.a.payload
  ip.io.fp32_adder_b := io.b.payload

  val fire = io.a.valid && io.b.valid
  if (latency == 0) {
    io.r.valid   := fire
    io.r.payload := ip.io.fp32_result
  } else {
    io.r.valid   := Delay(fire, latency, init = False)
    io.r.payload := Delay(ip.io.fp32_result, latency)
  }
}
