package attention.softmax

import attention.common._
import spinal.core._
import spinal.lib._

import scala.language.postfixOps

/**
 * Stable serial softmax on one FP16 score vector (length N from input `tlast`).
 */
class SoftmaxCore(
    g: AttentionGenerics,
    toFp32: Flow[Bits] => Flow[Bits],
    toFp16: Flow[Bits] => Flow[Bits],
    addFp32: (Flow[Bits], Flow[Bits]) => Flow[Bits],
    mulFp32: (Flow[Bits], Flow[Bits]) => Flow[Bits],
    expFp32: Flow[Bits] => Flow[Bits],
    divFp32: (Flow[Bits], Flow[Bits]) => Flow[Bits]
) extends Component {

  val expLat = SoftmaxAlteraIp.expLatency
  val divLat = SoftmaxAlteraIp.divLatency
  val addLat = SoftmaxAlteraIp.addLatency
  val mulLat = SoftmaxAlteraIp.mulLatency
  val toFp16Lat = SoftmaxAlteraIp.toFp16Latency

  val fp32One  = B(0x3f800000L, 32 bits)
  val fp32Zero = B(0x00000000L, 32 bits)

  val io = new Bundle {
    val scoresIn    = slave(Stream(Fragment(Bits(16 bits))))
    val scoresUser  = in Bits(15 bits)
    val weightsOut  = master(Stream(Fragment(Bits(16 bits))))
    val weightsUser = out Bits(15 bits)
    val busy        = out Bool()
  }

  object State extends SpinalEnum {
    val IDLE, COLLECT, EXP, DIV, EMIT = newElement()
  }
  val state = RegInit(State.IDLE)

  object ExpSt extends SpinalEnum {
    val READ, READ2, FEED_SUB, WAIT_SUB, WAIT_EXP, WAIT_ACC, WAIT_TOFP16, BUMP = newElement()
  }
  val expSt = RegInit(ExpSt.READ)

  object EmitSt extends SpinalEnum {
    val READ, READ2, FEED_MUL, WAIT_MUL, WAIT_TOFP16, BUMP = newElement()
  }
  val emitSt = RegInit(EmitSt.READ)

  // 6 bits is enough: max load is expLat-1 = 30. Narrower counter -> smaller
  // waitLeft==0 reduction, which gates the whole FSM next-state decode.
  val waitLeft = Reg(UInt(6 bits)) init (0)

  val lenReg     = Reg(UInt(g.lenWidth bits)) init (0)
  val idx        = Reg(UInt(g.idxWidth bits)) init (0)
  val maxFp16    = Reg(Bits(16 bits)) init (0)
  val maxValid   = RegInit(False)
  val sumFp32    = Reg(Bits(32 bits)) init (0)
  val invSumFp32 = Reg(Bits(32 bits)) init (0)
  val contextUser = Reg(Bits(15 bits)) init (0)
  val expHold    = Reg(Bits(32 bits)) init (0)
  val emitHold   = Reg(Bits(16 bits)) init (0)
  val emitLast   = RegInit(False)

  val buf = new SoftmaxScoreBuffer(g)
  buf.io.raddr := idx
  buf.io.wen   := False
  buf.io.waddr := idx
  buf.io.wdata := B(0, 16 bits)

  // Pipeline the M20K read data once more before fp16ToFp32 + FP DSP. This isolates
  // the M20K clock-to-output (uTco ~1.4 ns) from the conversion/route into the DSP,
  // which was the remaining setup-timing critical path. Costs 1 extra read cycle.
  val scoreRd = RegNext(buf.io.rdata)

  // Datapath fp16->fp32 (EXP subtract, EMIT multiply), fed from the registered RAM
  // read. In FEED_SUB / FEED_MUL waitLeft is always 0 (READ/READ2 never load it),
  // so no waitLeft==0 guard is needed on these operand feeds.
  val toFp32In = Flow(Bits(16 bits))
  toFp32In.valid   := False
  toFp32In.payload := 0
  when(state === State.EXP && expSt === ExpSt.FEED_SUB) {
    toFp32In.valid   := True
    toFp32In.payload := scoreRd
  }
  when(state === State.EMIT && emitSt === EmitSt.FEED_MUL) {
    toFp32In.valid   := True
    toFp32In.payload := scoreRd
  }
  val toFp32Out = toFp32(toFp32In)

  // Max tracking in the fp16 domain: per-beat path is a narrow 15-bit ordered
  // compare with NO fp16->fp32 conversion (was the setup-timing critical path).
  // The winning fp16 max is converted to fp32 once for the EXP subtract.
  when(io.scoresIn.fire) {
    when(!maxValid || Fp16Compare.gt(io.scoresIn.fragment, maxFp16)) {
      maxFp16  := io.scoresIn.fragment
      maxValid := True
    }
  }
  val maxConvIn = Flow(Bits(16 bits))
  maxConvIn.valid   := True
  maxConvIn.payload := maxFp16
  val maxFp32 = RegNext(toFp32(maxConvIn).payload) init (0)
  val negMax  = maxFp32 ^ B(0x80000000L, 32 bits)

  val subA = Flow(Bits(32 bits))
  val subB = Flow(Bits(32 bits))
  subA.valid   := False
  subA.payload := fp32Zero
  subB.valid   := False
  subB.payload := negMax
  when(state === State.EXP && expSt === ExpSt.FEED_SUB && toFp32Out.valid) {
    subA.valid   := True
    subA.payload := toFp32Out.payload
    subB.valid   := True
  }
  val subR = addFp32(subA, subB)

  val expIn = Flow(Bits(32 bits))
  expIn.valid   := False
  expIn.payload := fp32Zero
  when(state === State.EXP && expSt === ExpSt.WAIT_SUB && subR.valid) {
    expIn.valid   := True
    expIn.payload := subR.payload
  }
  val expOut = expFp32(expIn)
  when(expOut.valid) {
    expHold := expOut.payload
  }

  val accA = Flow(Bits(32 bits))
  val accB = Flow(Bits(32 bits))
  accA.valid   := False
  accA.payload := sumFp32
  accB.valid   := False
  accB.payload := fp32Zero
  when(state === State.EXP && expSt === ExpSt.WAIT_EXP && expOut.valid) {
    accA.valid   := True
    accB.valid   := True
    accB.payload := expOut.payload
  }
  val accR = addFp32(accA, accB)

  val storeFlow = Flow(Bits(32 bits))
  storeFlow.valid   := state === State.EXP && expSt === ExpSt.WAIT_TOFP16
  storeFlow.payload := expHold
  val storeFp16 = toFp16(storeFlow)

  val divA = Flow(Bits(32 bits))
  val divB = Flow(Bits(32 bits))
  divA.valid   := False
  divA.payload := fp32One
  divB.valid   := False
  divB.payload := sumFp32
  when(state === State.DIV && waitLeft === 0) {
    divA.valid := True
    divB.valid := True
  }
  val divR = divFp32(divA, divB)

  val mulA = Flow(Bits(32 bits))
  val mulB = Flow(Bits(32 bits))
  mulA.valid   := False
  mulA.payload := fp32Zero
  mulB.valid   := False
  mulB.payload := invSumFp32
  when(state === State.EMIT && emitSt === EmitSt.FEED_MUL && toFp32Out.valid) {
    mulA.valid   := True
    mulA.payload := toFp32Out.payload
    mulB.valid   := True
  }
  val mulR = mulFp32(mulA, mulB)

  val outFlow = Flow(Bits(32 bits))
  outFlow.valid   := False
  outFlow.payload := fp32Zero
  when(state === State.EMIT && emitSt === EmitSt.WAIT_MUL && mulR.valid) {
    outFlow.valid   := True
    outFlow.payload := mulR.payload
  }
  val outFp16 = toFp16(outFlow)

  io.scoresIn.ready    := False
  io.weightsOut.valid  := False
  io.weightsOut.fragment := 0
  io.weightsOut.last     := False
  io.weightsUser       := contextUser
  io.busy              := state =/= State.IDLE

  when(waitLeft =/= 0) {
    waitLeft := waitLeft - 1
  }

  switch(state) {
    is(State.IDLE) {
      io.scoresIn.ready := True
      when(io.scoresIn.fire) {
        idx         := 1
        lenReg      := 1
        maxValid    := False
        sumFp32     := fp32Zero
        contextUser := io.scoresUser
        buf.io.wen  := True
        buf.io.wdata := io.scoresIn.fragment
        when(io.scoresIn.last) {
          state := State.EXP
          idx   := 0
          expSt := ExpSt.READ
        } otherwise {
          state := State.COLLECT
        }
      }
    }

    is(State.COLLECT) {
      io.scoresIn.ready := True
      when(io.scoresIn.fire) {
        buf.io.wen   := True
        buf.io.wdata := io.scoresIn.fragment
        buf.io.waddr := idx
        idx    := idx + 1
        lenReg := lenReg + 1
        when(io.scoresIn.last) {
          state := State.EXP
          idx   := 0
          expSt := ExpSt.READ
        }
      }
    }

    is(State.EXP) {
      when(waitLeft === 0) {
        switch(expSt) {
          is(ExpSt.READ) {
            // raddr = idx already presented; wait for M20K sync-read data.
            expSt := ExpSt.READ2
          }
          is(ExpSt.READ2) {
            // wait for the scoreRd pipeline register (2nd read stage).
            expSt := ExpSt.FEED_SUB
          }
          is(ExpSt.FEED_SUB) {
            when(toFp32Out.valid) {
              expSt    := ExpSt.WAIT_SUB
              waitLeft := U(addLat - 1, 6 bits)
            }
          }
          is(ExpSt.WAIT_SUB) {
            when(subR.valid) {
              expSt    := ExpSt.WAIT_EXP
              waitLeft := U(expLat - 1, 6 bits)
            }
          }
          is(ExpSt.WAIT_EXP) {
            when(expOut.valid) {
              expHold  := expOut.payload
              expSt    := ExpSt.WAIT_ACC
              waitLeft := U(addLat - 1, 6 bits)
            }
          }
          is(ExpSt.WAIT_ACC) {
            when(accR.valid) {
              sumFp32 := accR.payload
              expSt   := ExpSt.WAIT_TOFP16
            }
          }
          is(ExpSt.WAIT_TOFP16) {
            when(storeFp16.valid) {
              buf.io.wen   := True
              buf.io.wdata := storeFp16.payload
              expSt        := ExpSt.BUMP
            }
          }
          is(ExpSt.BUMP) {
            val last = idx === (lenReg - 1).resized
            idx := idx + 1
            when(last) {
              state := State.DIV
            } otherwise {
              expSt := ExpSt.READ
            }
          }
        }
      }
    }

    is(State.DIV) {
      when(waitLeft === 0 && divR.valid) {
        invSumFp32 := divR.payload
        state      := State.EMIT
        idx        := 0
        emitSt     := EmitSt.READ
      } elsewhen(waitLeft === 0) {
        waitLeft := U(divLat - 1, 6 bits)
      }
    }

    is(State.EMIT) {
      when(waitLeft === 0) {
        switch(emitSt) {
          is(EmitSt.READ) {
            // raddr = idx already presented; wait for M20K sync-read data.
            emitSt := EmitSt.READ2
          }
          is(EmitSt.READ2) {
            // wait for the scoreRd pipeline register (2nd read stage).
            emitSt := EmitSt.FEED_MUL
          }
          is(EmitSt.FEED_MUL) {
            when(toFp32Out.valid) {
              emitSt   := EmitSt.WAIT_MUL
              waitLeft := U(mulLat - 1, 6 bits)
            }
          }
          is(EmitSt.WAIT_MUL) {
            when(mulR.valid) {
              emitSt   := EmitSt.WAIT_TOFP16
              waitLeft := U(toFp16Lat - 1, 6 bits)
            }
          }
          is(EmitSt.WAIT_TOFP16) {
            when(outFp16.valid) {
              emitHold               := outFp16.payload
              emitLast               := idx === (lenReg - 1).resized
              emitSt                 := EmitSt.BUMP
            }
          }
          is(EmitSt.BUMP) {
            io.weightsOut.valid    := True
            io.weightsOut.fragment := emitHold
            io.weightsOut.last     := emitLast
            when(io.weightsOut.fire) {
              val last = idx === (lenReg - 1).resized
              idx := idx + 1
              when(last) {
                state := State.IDLE
              } otherwise {
                emitSt := EmitSt.READ
              }
            }
          }
        }
      }
    }
  }
}
