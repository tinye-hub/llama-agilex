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
  val ipName:  String,
  val latency: Int
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
    io.r.valid   := Delay(fire, latency, init = False)
    io.r.payload := Delay(ip.io.fp32_result, latency)
  }
}

/**
 * Serial sum of FP32 values using [[IntelFpMultAccBlackBox]] accumulate mode.
 *
 * Each beat adds `accIn.fragment` via `result = prev + fragment * 1.0` after the first beat.
 * Matches Xilinx `fp32acc22.acc` `Flow[Fragment]` contract used in RMSNormFp32.
 */
class FpMultAccSerialAccAdapter(
  val ipName:  String,
  val latency: Int
) extends Component {

  val io = new Bundle {
    val accIn  = slave(Flow(Fragment(Bits(32 bits))))
    val accOut = master(Flow(Fragment(Bits(32 bits))))
  }

  val ip = new IntelFpMultAccBlackBox(ipName)
  ip.io.ena         := B(7, 3 bits)
  ip.io.fp32_mult_a := io.accIn.fragment
  ip.io.fp32_mult_b := B(0x3F800000, 32 bits) // FP32 1.0

  val isFirst = RegInit(True)
  when(io.accIn.fire) {
    when(io.accIn.last) {
      isFirst := True
    } otherwise {
      isFirst := False
    }
  }

  ip.io.accumulate := !isFirst

  if (latency == 0) {
    io.accOut.valid   := io.accIn.valid
    io.accOut.last    := io.accIn.last
    io.accOut.fragment := ip.io.fp32_result
  } else {
    io.accOut.valid    := Delay(io.accIn.valid, latency, init = False)
    io.accOut.last     := Delay(io.accIn.last & io.accIn.valid, latency, init = False)
    io.accOut.fragment := Delay(ip.io.fp32_result, latency)
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
