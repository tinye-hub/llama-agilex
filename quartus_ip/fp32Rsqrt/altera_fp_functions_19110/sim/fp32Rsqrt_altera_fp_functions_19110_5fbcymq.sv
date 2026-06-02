// ------------------------------------------------------------------------- 
// High Level Design Compiler for Altera(R) FPGAs Version 25.1.1 (Release Build #64f96064e9)
// Quartus Prime development tool and MATLAB/Simulink Interface
// 
// Legal Notice: Copyright 2025 Altera Corporation.  All rights reserved.
// Your use of Altera Corporation's  design tools,  logic functions and other
// software and  tools, and  its AMPP partner logic functions, and any output
// files any  of the  foregoing (including  device programming  or simulation
// files), and  any associated  documentation  or  information  are expressly
// subject to the terms and  conditions  of the  Altera FPGA Software License
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement,  including,  without limitation,  that  your use is for
// the  sole  purpose of  programming  logic devices  manufactured by  Altera
// and  sold by Altera  or its authorized  distributors. Please refer  to the
// applicable agreement for further details.
// ---------------------------------------------------------------------------

// SystemVerilog created from fp32Rsqrt_altera_fp_functions_19110_5fbcymq
// SystemVerilog created on Mon Jun  1 10:05:28 2026


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module fp32Rsqrt_altera_fp_functions_19110_5fbcymq (
    input wire [31:0] a,
    input wire [0:0] en,
    output wire [31:0] q,
    input wire clk,
    input wire areset
    );

    wire [0:0] GND_q;
    wire [0:0] VCC_q;
    wire [7:0] cstAllOWE_uid6_fpInvSqrtTest_q;
    wire [22:0] cstAllZWF_uid7_fpInvSqrtTest_q;
    wire [22:0] cstNaNWF_uid8_fpInvSqrtTest_q;
    wire [7:0] cstAllZWE_uid9_fpInvSqrtTest_q;
    wire [7:0] cst3BiasM1o2M1_uid10_fpInvSqrtTest_q;
    wire [7:0] cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
    wire [7:0] exp_x_uid16_fpInvSqrtTest_b;
    wire [22:0] frac_x_uid17_fpInvSqrtTest_b;
    wire [0:0] excZ_x_uid18_fpInvSqrtTest_q;
    wire [0:0] expXIsMax_uid19_fpInvSqrtTest_q;
    wire [0:0] fracXIsZero_uid20_fpInvSqrtTest_q;
    wire [0:0] fracXIsNotZero_uid21_fpInvSqrtTest_q;
    wire [0:0] excI_x_uid22_fpInvSqrtTest_q;
    wire [0:0] excN_x_uid23_fpInvSqrtTest_q;
    wire [0:0] signX_uid28_fpInvSqrtTest_b;
    wire [0:0] evenOddExp_uid30_fpInvSqrtTest_in;
    wire [0:0] evenOddExp_uid30_fpInvSqrtTest_b;
    wire [23:0] addrYFull_uid31_fpInvSqrtTest_q;
    wire [8:0] yAddr_uid33_fpInvSqrtTest_b;
    wire [14:0] yPPolyEval_uid34_fpInvSqrtTest_in;
    wire [14:0] yPPolyEval_uid34_fpInvSqrtTest_b;
    wire [29:0] fxpInvSqrtRes_uid36_fpInvSqrtTest_in;
    wire [23:0] fxpInvSqrtRes_uid36_fpInvSqrtTest_b;
    wire [1:0] concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q;
    wire [1:0] cstSel_uid40_fpInvSqrtTest_s;
    reg [7:0] cstSel_uid40_fpInvSqrtTest_q;
    wire [6:0] expRExt_uid41_fpInvSqrtTest_b;
    wire [8:0] expRExt_uid42_fpInvSqrtTest_a;
    wire [8:0] expRExt_uid42_fpInvSqrtTest_b;
    logic [8:0] expRExt_uid42_fpInvSqrtTest_o;
    wire [8:0] expRExt_uid42_fpInvSqrtTest_q;
    wire [7:0] expR_uid43_fpInvSqrtTest_in;
    wire [7:0] expR_uid43_fpInvSqrtTest_b;
    wire [22:0] fxpInverseResFrac_uid44_fpInvSqrtTest_in;
    wire [22:0] fxpInverseResFrac_uid44_fpInvSqrtTest_b;
    wire [0:0] invSignX_uid45_fpInvSqrtTest_q;
    wire [0:0] excRZero_uid46_fpInvSqrtTest_q;
    wire [0:0] invExcXZ_uid47_fpInvSqrtTest_q;
    wire [0:0] xRegNeg_uid48_fpInvSqrtTest_q;
    wire [0:0] xNOxRNeg_uid49_fpInvSqrtTest_q;
    wire [2:0] excRConc_uid50_fpInvSqrtTest_q;
    reg [1:0] outMuxSelEnc_uid51_fpInvSqrtTest_q;
    wire [1:0] fracRPostExc_uid53_fpInvSqrtTest_s;
    reg [22:0] fracRPostExc_uid53_fpInvSqrtTest_q;
    wire [1:0] expRPostExc_uid54_fpInvSqrtTest_s;
    reg [7:0] expRPostExc_uid54_fpInvSqrtTest_q;
    wire [0:0] signR_uid55_fpInvSqrtTest_qi;
    reg [0:0] signR_uid55_fpInvSqrtTest_q;
    wire [31:0] R_uid56_fpInvSqrtTest_q;
    wire [11:0] yT1_uid70_invPolyEval_b;
    wire [0:0] lowRangeB_uid72_invPolyEval_in;
    wire [0:0] lowRangeB_uid72_invPolyEval_b;
    wire [11:0] highBBits_uid73_invPolyEval_b;
    wire [21:0] s1sumAHighB_uid74_invPolyEval_a;
    wire [21:0] s1sumAHighB_uid74_invPolyEval_b;
    logic [21:0] s1sumAHighB_uid74_invPolyEval_o;
    wire [21:0] s1sumAHighB_uid74_invPolyEval_q;
    wire [22:0] s1_uid75_invPolyEval_q;
    wire [1:0] lowRangeB_uid78_invPolyEval_in;
    wire [1:0] lowRangeB_uid78_invPolyEval_b;
    wire [21:0] highBBits_uid79_invPolyEval_b;
    wire [30:0] s2sumAHighB_uid80_invPolyEval_a;
    wire [30:0] s2sumAHighB_uid80_invPolyEval_b;
    logic [30:0] s2sumAHighB_uid80_invPolyEval_o;
    wire [30:0] s2sumAHighB_uid80_invPolyEval_q;
    wire [32:0] s2_uid81_invPolyEval_q;
    wire [12:0] osig_uid84_pT1_uid71_invPolyEval_b;
    wire [23:0] osig_uid87_pT2_uid77_invPolyEval_b;
    wire memoryC0_uid58_invSqrtTables_lutmem_reset0;
    wire memoryC0_uid58_invSqrtTables_lutmem_ena_NotRstA;
    wire [29:0] memoryC0_uid58_invSqrtTables_lutmem_ia;
    wire [8:0] memoryC0_uid58_invSqrtTables_lutmem_aa;
    wire [8:0] memoryC0_uid58_invSqrtTables_lutmem_ab;
    wire [29:0] memoryC0_uid58_invSqrtTables_lutmem_ir;
    wire [29:0] memoryC0_uid58_invSqrtTables_lutmem_r;
    wire memoryC1_uid61_invSqrtTables_lutmem_reset0;
    wire memoryC1_uid61_invSqrtTables_lutmem_ena_NotRstA;
    wire [20:0] memoryC1_uid61_invSqrtTables_lutmem_ia;
    wire [8:0] memoryC1_uid61_invSqrtTables_lutmem_aa;
    wire [8:0] memoryC1_uid61_invSqrtTables_lutmem_ab;
    wire [20:0] memoryC1_uid61_invSqrtTables_lutmem_ir;
    wire [20:0] memoryC1_uid61_invSqrtTables_lutmem_r;
    wire memoryC2_uid64_invSqrtTables_lutmem_reset0;
    wire memoryC2_uid64_invSqrtTables_lutmem_ena_NotRstA;
    wire [11:0] memoryC2_uid64_invSqrtTables_lutmem_ia;
    wire [8:0] memoryC2_uid64_invSqrtTables_lutmem_aa;
    wire [8:0] memoryC2_uid64_invSqrtTables_lutmem_ab;
    wire [11:0] memoryC2_uid64_invSqrtTables_lutmem_ir;
    wire [11:0] memoryC2_uid64_invSqrtTables_lutmem_r;
    wire prodXY_uid83_pT1_uid71_invPolyEval_cma_reset;
    wire [11:0] prodXY_uid83_pT1_uid71_invPolyEval_cma_a0;
    wire [11:0] prodXY_uid83_pT1_uid71_invPolyEval_cma_c0;
    wire [23:0] prodXY_uid83_pT1_uid71_invPolyEval_cma_s0;
    wire [23:0] prodXY_uid83_pT1_uid71_invPolyEval_cma_qq0;
    reg [23:0] prodXY_uid83_pT1_uid71_invPolyEval_cma_q;
    wire prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0;
    wire prodXY_uid83_pT1_uid71_invPolyEval_cma_ena1;
    wire prodXY_uid83_pT1_uid71_invPolyEval_cma_ena2;
    wire prodXY_uid86_pT2_uid77_invPolyEval_cma_reset;
    wire [14:0] prodXY_uid86_pT2_uid77_invPolyEval_cma_a0;
    wire [22:0] prodXY_uid86_pT2_uid77_invPolyEval_cma_c0;
    wire [37:0] prodXY_uid86_pT2_uid77_invPolyEval_cma_s0;
    wire [37:0] prodXY_uid86_pT2_uid77_invPolyEval_cma_qq0;
    reg [37:0] prodXY_uid86_pT2_uid77_invPolyEval_cma_q;
    wire prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0;
    wire prodXY_uid86_pT2_uid77_invPolyEval_cma_ena1;
    wire prodXY_uid86_pT2_uid77_invPolyEval_cma_ena2;
    reg [22:0] redist0_s1_uid75_invPolyEval_q_1_q;
    reg [0:0] redist1_signR_uid55_fpInvSqrtTest_q_14_q;
    reg [1:0] redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q;
    reg [22:0] redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q;
    reg [6:0] redist5_expRExt_uid41_fpInvSqrtTest_b_1_q;
    reg [1:0] redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_q;
    reg [14:0] redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q;
    reg [14:0] redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_delay_0;
    reg [8:0] redist9_yAddr_uid33_fpInvSqrtTest_b_5_q;
    reg [8:0] redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_0;
    reg [8:0] redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_1;
    reg [8:0] redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_2;
    reg [8:0] redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_3;
    reg [7:0] redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_q;
    wire redist4_expR_uid43_fpInvSqrtTest_b_13_mem_reset0;
    wire redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ena_OrRstB;
    wire [7:0] redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ia;
    wire [3:0] redist4_expR_uid43_fpInvSqrtTest_b_13_mem_aa;
    wire [3:0] redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ab;
    wire [7:0] redist4_expR_uid43_fpInvSqrtTest_b_13_mem_iq;
    wire [7:0] redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q;
    wire [3:0] redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q;
    (* preserve_syn_only *) reg [3:0] redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i;
    (* preserve_syn_only *) reg redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq;
    wire [0:0] redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s;
    reg [3:0] redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q;
    reg [3:0] redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q;
    wire redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_reset0;
    wire redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ena_OrRstB;
    wire [14:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ia;
    wire [2:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_aa;
    wire [2:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ab;
    wire [14:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_iq;
    wire [14:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_q;
    wire [2:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i;
    (* preserve_syn_only *) reg redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq;
    wire [0:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s;
    reg [2:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q;
    reg [2:0] redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q;
    wire redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_reset0;
    wire redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ena_OrRstB;
    wire [8:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ia;
    wire [2:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_aa;
    wire [2:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ab;
    wire [8:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_iq;
    wire [8:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_q;
    wire [2:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i;
    (* preserve_syn_only *) reg redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq;
    wire [0:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s;
    reg [2:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q;
    reg [2:0] redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q;


    // signX_uid28_fpInvSqrtTest(BITSELECT,27)@0
    assign signX_uid28_fpInvSqrtTest_b = a[31:31];

    // cstAllZWE_uid9_fpInvSqrtTest(CONSTANT,8)
    assign cstAllZWE_uid9_fpInvSqrtTest_q = 8'b00000000;

    // exp_x_uid16_fpInvSqrtTest(BITSELECT,15)@0
    assign exp_x_uid16_fpInvSqrtTest_b = $signed(a[30:23]);

    // excZ_x_uid18_fpInvSqrtTest(LOGICAL,17)@0
    assign excZ_x_uid18_fpInvSqrtTest_q = exp_x_uid16_fpInvSqrtTest_b == cstAllZWE_uid9_fpInvSqrtTest_q ? 1'b1 : 1'b0;

    // signR_uid55_fpInvSqrtTest(LOGICAL,54)@0 + 1
    assign signR_uid55_fpInvSqrtTest_qi = excZ_x_uid18_fpInvSqrtTest_q & signX_uid28_fpInvSqrtTest_b;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    signR_uid55_fpInvSqrtTest_delay ( .xin(signR_uid55_fpInvSqrtTest_qi), .xout(signR_uid55_fpInvSqrtTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist1_signR_uid55_fpInvSqrtTest_q_14(DELAY,94)
    dspba_delay_ver #( .width(1), .depth(13), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist1_signR_uid55_fpInvSqrtTest_q_14 ( .xin(signR_uid55_fpInvSqrtTest_q), .xout(redist1_signR_uid55_fpInvSqrtTest_q_14_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // cstAllOWE_uid6_fpInvSqrtTest(CONSTANT,5)
    assign cstAllOWE_uid6_fpInvSqrtTest_q = 8'b11111111;

    // redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt(COUNTER,106)
    // low=0, high=10, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i <= 4'd0;
            redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i == 4'd9)
            begin
                redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq <= 1'b0;
            end
            if (redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq == 1'b1)
            begin
                redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i <= $unsigned(redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i) + $unsigned(4'd6);
            end
            else
            begin
                redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i <= $unsigned(redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i) + $unsigned(4'd1);
            end
        end
    end
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q = $signed(redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i[3:0]);

    // redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux(MUX,107)
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s = en;
    always_comb 
    begin
        unique case (redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s)
            1'b0 : redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q = redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q;
            1'b1 : redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q = redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q;
            default : redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q = 4'b0;
        endcase
    end

    // VCC(CONSTANT,1)
    assign VCC_q = 1'b1;

    // expRExt_uid41_fpInvSqrtTest(BITSELECT,40)@0
    assign expRExt_uid41_fpInvSqrtTest_b = $signed(exp_x_uid16_fpInvSqrtTest_b[7:1]);

    // redist5_expRExt_uid41_fpInvSqrtTest_b_1(DELAY,98)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist5_expRExt_uid41_fpInvSqrtTest_b_1_q <= expRExt_uid41_fpInvSqrtTest_b;
        end
    end

    // cst3BiasM1o2M1_uid10_fpInvSqrtTest(CONSTANT,9)
    assign cst3BiasM1o2M1_uid10_fpInvSqrtTest_q = 8'b10111101;

    // cst3BiasP1o2M1_uid11_fpInvSqrtTest(CONSTANT,10)
    assign cst3BiasP1o2M1_uid11_fpInvSqrtTest_q = 8'b10111110;

    // frac_x_uid17_fpInvSqrtTest(BITSELECT,16)@0
    assign frac_x_uid17_fpInvSqrtTest_b = $signed(a[22:0]);

    // cstAllZWF_uid7_fpInvSqrtTest(CONSTANT,6)
    assign cstAllZWF_uid7_fpInvSqrtTest_q = 23'b00000000000000000000000;

    // fracXIsZero_uid20_fpInvSqrtTest(LOGICAL,19)@0
    assign fracXIsZero_uid20_fpInvSqrtTest_q = cstAllZWF_uid7_fpInvSqrtTest_q == frac_x_uid17_fpInvSqrtTest_b ? 1'b1 : 1'b0;

    // evenOddExp_uid30_fpInvSqrtTest(BITSELECT,29)@0
    assign evenOddExp_uid30_fpInvSqrtTest_in = $unsigned(exp_x_uid16_fpInvSqrtTest_b[0:0]);
    assign evenOddExp_uid30_fpInvSqrtTest_b = evenOddExp_uid30_fpInvSqrtTest_in[0:0];

    // concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest(BITJOIN,38)@0
    assign concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q = {fracXIsZero_uid20_fpInvSqrtTest_q, evenOddExp_uid30_fpInvSqrtTest_b};

    // redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1(DELAY,99)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_q <= concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q;
        end
    end

    // cstSel_uid40_fpInvSqrtTest(MUX,39)@1
    assign cstSel_uid40_fpInvSqrtTest_s = redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_q;
    always_comb 
    begin
        unique case (cstSel_uid40_fpInvSqrtTest_s)
            2'b00 : cstSel_uid40_fpInvSqrtTest_q = cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            2'b01 : cstSel_uid40_fpInvSqrtTest_q = cst3BiasM1o2M1_uid10_fpInvSqrtTest_q;
            2'b10 : cstSel_uid40_fpInvSqrtTest_q = cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            2'b11 : cstSel_uid40_fpInvSqrtTest_q = cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            default : cstSel_uid40_fpInvSqrtTest_q = 8'b0;
        endcase
    end

    // expRExt_uid42_fpInvSqrtTest(SUB,41)@1
    assign expRExt_uid42_fpInvSqrtTest_a = $unsigned({1'b0, cstSel_uid40_fpInvSqrtTest_q});
    assign expRExt_uid42_fpInvSqrtTest_b = $unsigned({2'b00, redist5_expRExt_uid41_fpInvSqrtTest_b_1_q});
    assign expRExt_uid42_fpInvSqrtTest_o = $unsigned($signed(expRExt_uid42_fpInvSqrtTest_a) - $signed(expRExt_uid42_fpInvSqrtTest_b));
    assign expRExt_uid42_fpInvSqrtTest_q = $signed(expRExt_uid42_fpInvSqrtTest_o[8:0]);

    // expR_uid43_fpInvSqrtTest(BITSELECT,42)@1
    assign expR_uid43_fpInvSqrtTest_in = expRExt_uid42_fpInvSqrtTest_q[7:0];
    assign expR_uid43_fpInvSqrtTest_b = $signed(expR_uid43_fpInvSqrtTest_in[7:0]);

    // redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0(DELAY,104)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_q <= expR_uid43_fpInvSqrtTest_b;
        end
    end

    // redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr(REG,108)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q <= 4'b1010;
        end
        else
        begin
            redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q <= redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q;
        end
    end

    // redist4_expR_uid43_fpInvSqrtTest_b_13_mem(DUALMEM,105)
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ia = $unsigned(redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_q);
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_mem_aa = redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q;
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ab = redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q;
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(8),
        .widthad_a(4),
        .numwords_a(11),
        .width_b(8),
        .widthad_b(4),
        .numwords_b(11),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .address_reg_b("CLOCK0"),
        .indata_reg_b("CLOCK0"),
        .rdcontrol_reg_b("CLOCK0"),
        .byteena_reg_b("CLOCK0"),
        .outdata_reg_b("CLOCK1"),
        .outdata_sclr_b("NONE"),
        .clock_enable_input_a("NORMAL"),
        .clock_enable_input_b("NORMAL"),
        .clock_enable_output_b("NORMAL"),
        .read_during_write_mode_mixed_ports("DONT_CARE"),
        .power_up_uninitialized("TRUE"),
        .intended_device_family("Agilex 5")
    ) redist4_expR_uid43_fpInvSqrtTest_b_13_mem_dmem (
        .clocken1(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_aa),
        .data_a(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ia),
        .wren_a(en[0]),
        .address_b(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ab),
        .q_b(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_iq),
        .wren_b(),
        .rden_a(),
        .rden_b(),
        .data_b(),
        .clocken2(),
        .clocken3(),
        .aclr0(),
        .aclr1(),
        .addressstall_a(),
        .addressstall_b(),
        .byteena_a(),
        .byteena_b(),
        .eccencbypass(),
        .eccencparity(),
        .sclr(),
        .address2_a(),
        .address2_b(),
        .q_a(),
        .eccstatus()
    );
    assign redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q = $signed(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_iq[7:0]);

    // invExcXZ_uid47_fpInvSqrtTest(LOGICAL,46)@0
    assign invExcXZ_uid47_fpInvSqrtTest_q = $signed(~ (excZ_x_uid18_fpInvSqrtTest_q));

    // xRegNeg_uid48_fpInvSqrtTest(LOGICAL,47)@0
    assign xRegNeg_uid48_fpInvSqrtTest_q = $signed(invExcXZ_uid47_fpInvSqrtTest_q & signX_uid28_fpInvSqrtTest_b);

    // fracXIsNotZero_uid21_fpInvSqrtTest(LOGICAL,20)@0
    assign fracXIsNotZero_uid21_fpInvSqrtTest_q = $signed(~ (fracXIsZero_uid20_fpInvSqrtTest_q));

    // expXIsMax_uid19_fpInvSqrtTest(LOGICAL,18)@0
    assign expXIsMax_uid19_fpInvSqrtTest_q = exp_x_uid16_fpInvSqrtTest_b == cstAllOWE_uid6_fpInvSqrtTest_q ? 1'b1 : 1'b0;

    // excN_x_uid23_fpInvSqrtTest(LOGICAL,22)@0
    assign excN_x_uid23_fpInvSqrtTest_q = $signed(expXIsMax_uid19_fpInvSqrtTest_q & fracXIsNotZero_uid21_fpInvSqrtTest_q);

    // xNOxRNeg_uid49_fpInvSqrtTest(LOGICAL,48)@0
    assign xNOxRNeg_uid49_fpInvSqrtTest_q = $signed(excN_x_uid23_fpInvSqrtTest_q | xRegNeg_uid48_fpInvSqrtTest_q);

    // excI_x_uid22_fpInvSqrtTest(LOGICAL,21)@0
    assign excI_x_uid22_fpInvSqrtTest_q = $signed(expXIsMax_uid19_fpInvSqrtTest_q & fracXIsZero_uid20_fpInvSqrtTest_q);

    // invSignX_uid45_fpInvSqrtTest(LOGICAL,44)@0
    assign invSignX_uid45_fpInvSqrtTest_q = $signed(~ (signX_uid28_fpInvSqrtTest_b));

    // excRZero_uid46_fpInvSqrtTest(LOGICAL,45)@0
    assign excRZero_uid46_fpInvSqrtTest_q = $signed(invSignX_uid45_fpInvSqrtTest_q & excI_x_uid22_fpInvSqrtTest_q);

    // excRConc_uid50_fpInvSqrtTest(BITJOIN,49)@0
    assign excRConc_uid50_fpInvSqrtTest_q = {xNOxRNeg_uid49_fpInvSqrtTest_q, excZ_x_uid18_fpInvSqrtTest_q, excRZero_uid46_fpInvSqrtTest_q};

    // outMuxSelEnc_uid51_fpInvSqrtTest(LOOKUP,50)@0 + 1
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b01;
        end
        else if (en == 1'b1)
        begin
            unique case (excRConc_uid50_fpInvSqrtTest_q)
                3'b000 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b01;
                3'b001 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b00;
                3'b010 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b10;
                3'b011 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b00;
                3'b100 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b11;
                3'b101 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b00;
                3'b110 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b10;
                3'b111 : outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'b01;
                default : begin
                              // unreachable
                              outMuxSelEnc_uid51_fpInvSqrtTest_q <= 2'bxx;
                          end
            endcase
        end
    end

    // redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14(DELAY,95)
    dspba_delay_ver #( .width(2), .depth(13), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14 ( .xin(outMuxSelEnc_uid51_fpInvSqrtTest_q), .xout(redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // expRPostExc_uid54_fpInvSqrtTest(MUX,53)@14
    assign expRPostExc_uid54_fpInvSqrtTest_s = redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q;
    always_comb 
    begin
        unique case (expRPostExc_uid54_fpInvSqrtTest_s)
            2'b00 : expRPostExc_uid54_fpInvSqrtTest_q = cstAllZWE_uid9_fpInvSqrtTest_q;
            2'b01 : expRPostExc_uid54_fpInvSqrtTest_q = redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q;
            2'b10 : expRPostExc_uid54_fpInvSqrtTest_q = cstAllOWE_uid6_fpInvSqrtTest_q;
            2'b11 : expRPostExc_uid54_fpInvSqrtTest_q = cstAllOWE_uid6_fpInvSqrtTest_q;
            default : expRPostExc_uid54_fpInvSqrtTest_q = 8'b0;
        endcase
    end

    // cstNaNWF_uid8_fpInvSqrtTest(CONSTANT,7)
    assign cstNaNWF_uid8_fpInvSqrtTest_q = 23'b00000000000000000000001;

    // addrYFull_uid31_fpInvSqrtTest(BITJOIN,30)@0
    assign addrYFull_uid31_fpInvSqrtTest_q = {evenOddExp_uid30_fpInvSqrtTest_b, frac_x_uid17_fpInvSqrtTest_b};

    // yAddr_uid33_fpInvSqrtTest(BITSELECT,32)@0
    assign yAddr_uid33_fpInvSqrtTest_b = $signed(addrYFull_uid31_fpInvSqrtTest_q[23:15]);

    // memoryC2_uid64_invSqrtTables_lutmem(DUALMEM,90)@0 + 2
    assign memoryC2_uid64_invSqrtTables_lutmem_aa = yAddr_uid33_fpInvSqrtTest_b;
    assign memoryC2_uid64_invSqrtTables_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign memoryC2_uid64_invSqrtTables_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(12),
        .widthad_a(9),
        .numwords_a(512),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC2_uid64_invSqrtTables_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) memoryC2_uid64_invSqrtTables_lutmem_dmem (
        .clocken0(memoryC2_uid64_invSqrtTables_lutmem_ena_NotRstA),
        .sclr(memoryC2_uid64_invSqrtTables_lutmem_reset0),
        .clock0(clk),
        .address_a(memoryC2_uid64_invSqrtTables_lutmem_aa),
        .q_a(memoryC2_uid64_invSqrtTables_lutmem_ir),
        .wren_a(),
        .wren_b(),
        .rden_a(),
        .rden_b(),
        .data_a(),
        .data_b(),
        .address_b(),
        .clock1(),
        .clocken1(),
        .clocken2(),
        .clocken3(),
        .aclr0(),
        .aclr1(),
        .addressstall_a(),
        .addressstall_b(),
        .byteena_a(),
        .byteena_b(),
        .eccencbypass(),
        .eccencparity(),
        .address2_a(),
        .address2_b(),
        .q_b(),
        .eccstatus()
    );
    assign memoryC2_uid64_invSqrtTables_lutmem_r = $signed(memoryC2_uid64_invSqrtTables_lutmem_ir[11:0]);

    // yPPolyEval_uid34_fpInvSqrtTest(BITSELECT,33)@0
    assign yPPolyEval_uid34_fpInvSqrtTest_in = frac_x_uid17_fpInvSqrtTest_b[14:0];
    assign yPPolyEval_uid34_fpInvSqrtTest_b = $signed(yPPolyEval_uid34_fpInvSqrtTest_in[14:0]);

    // redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2(DELAY,100)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_delay_0 <= $unsigned(yPPolyEval_uid34_fpInvSqrtTest_b);
            redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q <= $signed(redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_delay_0);
        end
    end

    // yT1_uid70_invPolyEval(BITSELECT,69)@2
    assign yT1_uid70_invPolyEval_b = $signed(redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q[14:3]);

    // prodXY_uid83_pT1_uid71_invPolyEval_cma(CHAINMULTADD,91)@2 + 5
    // in b@5
    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_reset = areset;
    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0 = en[0] | prodXY_uid83_pT1_uid71_invPolyEval_cma_reset;
    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_ena1 = prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0;
    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_ena2 = prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0;

    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_a0 = yT1_uid70_invPolyEval_b;
    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_c0 = $unsigned(memoryC2_uid64_invSqrtTables_lutmem_r);
    tennm_mac #(
        .operation_mode("m18x18_full"),
        .clear_type("sclr"),
        .ay_scan_in_clken("0"),
        .ay_scan_in_width(12),
        .ax_clken("0"),
        .ax_width(12),
        .signed_may("false"),
        .signed_max("true"),
        .input_pipeline_clken("2"),
        .second_pipeline_clken("2"),
        .output_clken("1"),
        .result_a_width(24)
    ) prodXY_uid83_pT1_uid71_invPolyEval_cma_DSP0 (
        .clk(clk),
        .ena({ prodXY_uid83_pT1_uid71_invPolyEval_cma_ena2, prodXY_uid83_pT1_uid71_invPolyEval_cma_ena1, prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0 }),
        .clr({ prodXY_uid83_pT1_uid71_invPolyEval_cma_reset, prodXY_uid83_pT1_uid71_invPolyEval_cma_reset }),
        .ay(prodXY_uid83_pT1_uid71_invPolyEval_cma_a0),
        .ax(prodXY_uid83_pT1_uid71_invPolyEval_cma_c0),
        .resulta(prodXY_uid83_pT1_uid71_invPolyEval_cma_s0),
        .accumulate(),
        .loadconst(),
        .negate(),
        .sub(),
        .az(),
        .coefsela(),
        .bx(),
        .by(),
        .bz(),
        .coefselb(),
        .cx(),
        .cy(),
        .dx(),
        .dy(),
        .ex(),
        .ey(),
        .fx(),
        .fy(),
        .scanin(),
        .scanout(),
        .chainin(),
        .chainout(),
        .disable_scanin(),
        .disable_chainout(),
        .resultb(),
        .dfxlfsrena(),
        .dfxmisrena()
    );
    dspba_delay_ver #( .width(24), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    prodXY_uid83_pT1_uid71_invPolyEval_cma_delay0 ( .xin(prodXY_uid83_pT1_uid71_invPolyEval_cma_s0), .xout(prodXY_uid83_pT1_uid71_invPolyEval_cma_qq0), .ena(en[0]), .clk(clk), .aclr(areset) );
    assign prodXY_uid83_pT1_uid71_invPolyEval_cma_q = $unsigned(prodXY_uid83_pT1_uid71_invPolyEval_cma_qq0[23:0]);

    // osig_uid84_pT1_uid71_invPolyEval(BITSELECT,83)@7
    assign osig_uid84_pT1_uid71_invPolyEval_b = prodXY_uid83_pT1_uid71_invPolyEval_cma_q[23:11];

    // highBBits_uid73_invPolyEval(BITSELECT,72)@7
    assign highBBits_uid73_invPolyEval_b = osig_uid84_pT1_uid71_invPolyEval_b[12:1];

    // redist9_yAddr_uid33_fpInvSqrtTest_b_5(DELAY,102)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_0 <= $unsigned(yAddr_uid33_fpInvSqrtTest_b);
            redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_1 <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_0;
            redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_2 <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_1;
            redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_3 <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_2;
            redist9_yAddr_uid33_fpInvSqrtTest_b_5_q <= $signed(redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_3);
        end
    end

    // memoryC1_uid61_invSqrtTables_lutmem(DUALMEM,89)@5 + 2
    assign memoryC1_uid61_invSqrtTables_lutmem_aa = redist9_yAddr_uid33_fpInvSqrtTest_b_5_q;
    assign memoryC1_uid61_invSqrtTables_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign memoryC1_uid61_invSqrtTables_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(21),
        .widthad_a(9),
        .numwords_a(512),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC1_uid61_invSqrtTables_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) memoryC1_uid61_invSqrtTables_lutmem_dmem (
        .clocken0(memoryC1_uid61_invSqrtTables_lutmem_ena_NotRstA),
        .sclr(memoryC1_uid61_invSqrtTables_lutmem_reset0),
        .clock0(clk),
        .address_a(memoryC1_uid61_invSqrtTables_lutmem_aa),
        .q_a(memoryC1_uid61_invSqrtTables_lutmem_ir),
        .wren_a(),
        .wren_b(),
        .rden_a(),
        .rden_b(),
        .data_a(),
        .data_b(),
        .address_b(),
        .clock1(),
        .clocken1(),
        .clocken2(),
        .clocken3(),
        .aclr0(),
        .aclr1(),
        .addressstall_a(),
        .addressstall_b(),
        .byteena_a(),
        .byteena_b(),
        .eccencbypass(),
        .eccencparity(),
        .address2_a(),
        .address2_b(),
        .q_b(),
        .eccstatus()
    );
    assign memoryC1_uid61_invSqrtTables_lutmem_r = $signed(memoryC1_uid61_invSqrtTables_lutmem_ir[20:0]);

    // s1sumAHighB_uid74_invPolyEval(ADD,73)@7
    assign s1sumAHighB_uid74_invPolyEval_a = $unsigned({{1{memoryC1_uid61_invSqrtTables_lutmem_r[20]}}, memoryC1_uid61_invSqrtTables_lutmem_r});
    assign s1sumAHighB_uid74_invPolyEval_b = $unsigned({{10{highBBits_uid73_invPolyEval_b[11]}}, highBBits_uid73_invPolyEval_b});
    assign s1sumAHighB_uid74_invPolyEval_o = $unsigned($signed(s1sumAHighB_uid74_invPolyEval_a) + $signed(s1sumAHighB_uid74_invPolyEval_b));
    assign s1sumAHighB_uid74_invPolyEval_q = $signed(s1sumAHighB_uid74_invPolyEval_o[21:0]);

    // lowRangeB_uid72_invPolyEval(BITSELECT,71)@7
    assign lowRangeB_uid72_invPolyEval_in = osig_uid84_pT1_uid71_invPolyEval_b[0:0];
    assign lowRangeB_uid72_invPolyEval_b = $signed(lowRangeB_uid72_invPolyEval_in[0:0]);

    // s1_uid75_invPolyEval(BITJOIN,74)@7
    assign s1_uid75_invPolyEval_q = {s1sumAHighB_uid74_invPolyEval_q, lowRangeB_uid72_invPolyEval_b};

    // redist0_s1_uid75_invPolyEval_q_1(DELAY,93)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist0_s1_uid75_invPolyEval_q_1_q <= s1_uid75_invPolyEval_q;
        end
    end

    // redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt(COUNTER,110)
    // low=0, high=4, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i <= 3'd0;
            redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i == 3'd3)
            begin
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq <= 1'b0;
            end
            if (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq == 1'b1)
            begin
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i <= $unsigned(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i) + $unsigned(3'd4);
            end
            else
            begin
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i <= $unsigned(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q = $signed(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i[2:0]);

    // redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux(MUX,111)
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s = en;
    always_comb 
    begin
        unique case (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s)
            1'b0 : redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q = redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q;
            1'b1 : redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q = redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q;
            default : redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q = 3'b0;
        endcase
    end

    // redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr(REG,112)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q <= 3'b100;
        end
        else
        begin
            redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q;
        end
    end

    // redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem(DUALMEM,109)
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ia = $unsigned(redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q);
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_aa = redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q;
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ab = redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q;
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(15),
        .widthad_a(3),
        .numwords_a(5),
        .width_b(15),
        .widthad_b(3),
        .numwords_b(5),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .address_reg_b("CLOCK0"),
        .indata_reg_b("CLOCK0"),
        .rdcontrol_reg_b("CLOCK0"),
        .byteena_reg_b("CLOCK0"),
        .outdata_reg_b("CLOCK1"),
        .outdata_sclr_b("NONE"),
        .clock_enable_input_a("NORMAL"),
        .clock_enable_input_b("NORMAL"),
        .clock_enable_output_b("NORMAL"),
        .read_during_write_mode_mixed_ports("DONT_CARE"),
        .power_up_uninitialized("TRUE"),
        .intended_device_family("Agilex 5")
    ) redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_dmem (
        .clocken1(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_aa),
        .data_a(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ia),
        .wren_a(en[0]),
        .address_b(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ab),
        .q_b(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_iq),
        .wren_b(),
        .rden_a(),
        .rden_b(),
        .data_b(),
        .clocken2(),
        .clocken3(),
        .aclr0(),
        .aclr1(),
        .addressstall_a(),
        .addressstall_b(),
        .byteena_a(),
        .byteena_b(),
        .eccencbypass(),
        .eccencparity(),
        .sclr(),
        .address2_a(),
        .address2_b(),
        .q_a(),
        .eccstatus()
    );
    assign redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_q = $signed(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_iq[14:0]);

    // GND(CONSTANT,0)
    assign GND_q = 1'b0;

    // prodXY_uid86_pT2_uid77_invPolyEval_cma(CHAINMULTADD,92)@8 + 5
    // in b@11
    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_reset = areset;
    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0 = en[0] | prodXY_uid86_pT2_uid77_invPolyEval_cma_reset;
    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_ena1 = prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0;
    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_ena2 = prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0;

    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_a0 = redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_q;
    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_c0 = $unsigned(redist0_s1_uid75_invPolyEval_q_1_q);
    tennm_mac #(
        .operation_mode("m27x27"),
        .clear_type("sclr"),
        .use_chainadder("false"),
        .ay_scan_in_clken("0"),
        .ay_scan_in_width(15),
        .ax_clken("0"),
        .ax_width(23),
        .signed_may("false"),
        .signed_max("true"),
        .input_pipeline_clken("2"),
        .second_pipeline_clken("2"),
        .output_clken("1"),
        .result_a_width(38)
    ) prodXY_uid86_pT2_uid77_invPolyEval_cma_DSP0 (
        .clk(clk),
        .ena({ prodXY_uid86_pT2_uid77_invPolyEval_cma_ena2, prodXY_uid86_pT2_uid77_invPolyEval_cma_ena1, prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0 }),
        .clr({ prodXY_uid86_pT2_uid77_invPolyEval_cma_reset, prodXY_uid86_pT2_uid77_invPolyEval_cma_reset }),
        .ay(prodXY_uid86_pT2_uid77_invPolyEval_cma_a0),
        .ax(prodXY_uid86_pT2_uid77_invPolyEval_cma_c0),
        .resulta(prodXY_uid86_pT2_uid77_invPolyEval_cma_s0),
        .accumulate(),
        .loadconst(),
        .negate(),
        .sub(),
        .az(),
        .coefsela(),
        .bx(),
        .by(),
        .bz(),
        .coefselb(),
        .cx(),
        .cy(),
        .dx(),
        .dy(),
        .ex(),
        .ey(),
        .fx(),
        .fy(),
        .scanin(),
        .scanout(),
        .chainin(),
        .chainout(),
        .disable_scanin(),
        .disable_chainout(),
        .resultb(),
        .dfxlfsrena(),
        .dfxmisrena()
    );
    dspba_delay_ver #( .width(38), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    prodXY_uid86_pT2_uid77_invPolyEval_cma_delay0 ( .xin(prodXY_uid86_pT2_uid77_invPolyEval_cma_s0), .xout(prodXY_uid86_pT2_uid77_invPolyEval_cma_qq0), .ena(en[0]), .clk(clk), .aclr(areset) );
    assign prodXY_uid86_pT2_uid77_invPolyEval_cma_q = $unsigned(prodXY_uid86_pT2_uid77_invPolyEval_cma_qq0[37:0]);

    // osig_uid87_pT2_uid77_invPolyEval(BITSELECT,86)@13
    assign osig_uid87_pT2_uid77_invPolyEval_b = prodXY_uid86_pT2_uid77_invPolyEval_cma_q[37:14];

    // highBBits_uid79_invPolyEval(BITSELECT,78)@13
    assign highBBits_uid79_invPolyEval_b = osig_uid87_pT2_uid77_invPolyEval_b[23:2];

    // redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt(COUNTER,114)
    // low=0, high=4, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i <= 3'd0;
            redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i == 3'd3)
            begin
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq <= 1'b0;
            end
            if (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq == 1'b1)
            begin
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i <= $unsigned(redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i) + $unsigned(3'd4);
            end
            else
            begin
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i <= $unsigned(redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q = $signed(redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i[2:0]);

    // redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux(MUX,115)
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s = en;
    always_comb 
    begin
        unique case (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s)
            1'b0 : redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q = redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q;
            1'b1 : redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q = redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q;
            default : redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q = 3'b0;
        endcase
    end

    // redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr(REG,116)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q <= 3'b100;
        end
        else
        begin
            redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q;
        end
    end

    // redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem(DUALMEM,113)
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ia = $unsigned(redist9_yAddr_uid33_fpInvSqrtTest_b_5_q);
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_aa = redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q;
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ab = redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q;
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(9),
        .widthad_a(3),
        .numwords_a(5),
        .width_b(9),
        .widthad_b(3),
        .numwords_b(5),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .address_reg_b("CLOCK0"),
        .indata_reg_b("CLOCK0"),
        .rdcontrol_reg_b("CLOCK0"),
        .byteena_reg_b("CLOCK0"),
        .outdata_reg_b("CLOCK1"),
        .outdata_sclr_b("NONE"),
        .clock_enable_input_a("NORMAL"),
        .clock_enable_input_b("NORMAL"),
        .clock_enable_output_b("NORMAL"),
        .read_during_write_mode_mixed_ports("DONT_CARE"),
        .power_up_uninitialized("TRUE"),
        .intended_device_family("Agilex 5")
    ) redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_dmem (
        .clocken1(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_aa),
        .data_a(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ia),
        .wren_a(en[0]),
        .address_b(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ab),
        .q_b(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_iq),
        .wren_b(),
        .rden_a(),
        .rden_b(),
        .data_b(),
        .clocken2(),
        .clocken3(),
        .aclr0(),
        .aclr1(),
        .addressstall_a(),
        .addressstall_b(),
        .byteena_a(),
        .byteena_b(),
        .eccencbypass(),
        .eccencparity(),
        .sclr(),
        .address2_a(),
        .address2_b(),
        .q_a(),
        .eccstatus()
    );
    assign redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_q = $signed(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_iq[8:0]);

    // memoryC0_uid58_invSqrtTables_lutmem(DUALMEM,88)@11 + 2
    assign memoryC0_uid58_invSqrtTables_lutmem_aa = redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_q;
    assign memoryC0_uid58_invSqrtTables_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign memoryC0_uid58_invSqrtTables_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(30),
        .widthad_a(9),
        .numwords_a(512),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC0_uid58_invSqrtTables_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) memoryC0_uid58_invSqrtTables_lutmem_dmem (
        .clocken0(memoryC0_uid58_invSqrtTables_lutmem_ena_NotRstA),
        .sclr(memoryC0_uid58_invSqrtTables_lutmem_reset0),
        .clock0(clk),
        .address_a(memoryC0_uid58_invSqrtTables_lutmem_aa),
        .q_a(memoryC0_uid58_invSqrtTables_lutmem_ir),
        .wren_a(),
        .wren_b(),
        .rden_a(),
        .rden_b(),
        .data_a(),
        .data_b(),
        .address_b(),
        .clock1(),
        .clocken1(),
        .clocken2(),
        .clocken3(),
        .aclr0(),
        .aclr1(),
        .addressstall_a(),
        .addressstall_b(),
        .byteena_a(),
        .byteena_b(),
        .eccencbypass(),
        .eccencparity(),
        .address2_a(),
        .address2_b(),
        .q_b(),
        .eccstatus()
    );
    assign memoryC0_uid58_invSqrtTables_lutmem_r = $signed(memoryC0_uid58_invSqrtTables_lutmem_ir[29:0]);

    // s2sumAHighB_uid80_invPolyEval(ADD,79)@13
    assign s2sumAHighB_uid80_invPolyEval_a = $unsigned({{1{memoryC0_uid58_invSqrtTables_lutmem_r[29]}}, memoryC0_uid58_invSqrtTables_lutmem_r});
    assign s2sumAHighB_uid80_invPolyEval_b = $unsigned({{9{highBBits_uid79_invPolyEval_b[21]}}, highBBits_uid79_invPolyEval_b});
    assign s2sumAHighB_uid80_invPolyEval_o = $unsigned($signed(s2sumAHighB_uid80_invPolyEval_a) + $signed(s2sumAHighB_uid80_invPolyEval_b));
    assign s2sumAHighB_uid80_invPolyEval_q = $signed(s2sumAHighB_uid80_invPolyEval_o[30:0]);

    // lowRangeB_uid78_invPolyEval(BITSELECT,77)@13
    assign lowRangeB_uid78_invPolyEval_in = osig_uid87_pT2_uid77_invPolyEval_b[1:0];
    assign lowRangeB_uid78_invPolyEval_b = $signed(lowRangeB_uid78_invPolyEval_in[1:0]);

    // s2_uid81_invPolyEval(BITJOIN,80)@13
    assign s2_uid81_invPolyEval_q = {s2sumAHighB_uid80_invPolyEval_q, lowRangeB_uid78_invPolyEval_b};

    // fxpInvSqrtRes_uid36_fpInvSqrtTest(BITSELECT,35)@13
    assign fxpInvSqrtRes_uid36_fpInvSqrtTest_in = s2_uid81_invPolyEval_q[29:0];
    assign fxpInvSqrtRes_uid36_fpInvSqrtTest_b = $signed(fxpInvSqrtRes_uid36_fpInvSqrtTest_in[29:6]);

    // fxpInverseResFrac_uid44_fpInvSqrtTest(BITSELECT,43)@13
    assign fxpInverseResFrac_uid44_fpInvSqrtTest_in = fxpInvSqrtRes_uid36_fpInvSqrtTest_b[22:0];
    assign fxpInverseResFrac_uid44_fpInvSqrtTest_b = $signed(fxpInverseResFrac_uid44_fpInvSqrtTest_in[22:0]);

    // redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1(DELAY,96)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q <= fxpInverseResFrac_uid44_fpInvSqrtTest_b;
        end
    end

    // fracRPostExc_uid53_fpInvSqrtTest(MUX,52)@14
    assign fracRPostExc_uid53_fpInvSqrtTest_s = redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q;
    always_comb 
    begin
        unique case (fracRPostExc_uid53_fpInvSqrtTest_s)
            2'b00 : fracRPostExc_uid53_fpInvSqrtTest_q = cstAllZWF_uid7_fpInvSqrtTest_q;
            2'b01 : fracRPostExc_uid53_fpInvSqrtTest_q = redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q;
            2'b10 : fracRPostExc_uid53_fpInvSqrtTest_q = cstAllZWF_uid7_fpInvSqrtTest_q;
            2'b11 : fracRPostExc_uid53_fpInvSqrtTest_q = cstNaNWF_uid8_fpInvSqrtTest_q;
            default : fracRPostExc_uid53_fpInvSqrtTest_q = 23'b0;
        endcase
    end

    // R_uid56_fpInvSqrtTest(BITJOIN,55)@14
    assign R_uid56_fpInvSqrtTest_q = {redist1_signR_uid55_fpInvSqrtTest_q_14_q, expRPostExc_uid54_fpInvSqrtTest_q, fracRPostExc_uid53_fpInvSqrtTest_q};

    // xOut(GPOUT,4)@14
    assign q = R_uid56_fpInvSqrtTest_q;

endmodule
