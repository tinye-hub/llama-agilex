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

// SystemVerilog created from fp16ToFp32_altera_fp_functions_19110_jikm5oq
// SystemVerilog created on Mon Jun  1 12:09:10 2026


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module fp16ToFp32_altera_fp_functions_19110_jikm5oq (
    input wire [15:0] a,
    input wire [0:0] en,
    output wire [31:0] q,
    input wire clk,
    input wire areset
    );

    wire [0:0] GND_q;
    wire [4:0] cstAllOWE_uid7_fpToFPTest_q;
    wire [9:0] cstZeroWF_uid8_fpToFPTest_q;
    wire [4:0] cstAllZWE_uid9_fpToFPTest_q;
    wire [4:0] exp_x_uid10_fpToFPTest_b;
    wire [9:0] frac_x_uid11_fpToFPTest_b;
    wire [0:0] excZ_x_uid12_fpToFPTest_q;
    wire [0:0] expXIsMax_uid13_fpToFPTest_q;
    wire [0:0] fracXIsZero_uid14_fpToFPTest_q;
    wire [0:0] fracXIsNotZero_uid15_fpToFPTest_q;
    wire [0:0] excI_x_uid16_fpToFPTest_q;
    wire [0:0] excN_x_uid17_fpToFPTest_q;
    wire [0:0] invExpXIsMax_uid18_fpToFPTest_q;
    wire [0:0] InvExpXIsZero_uid19_fpToFPTest_q;
    wire [0:0] excR_x_uid20_fpToFPTest_q;
    wire [12:0] zP_uid23_fpToFPTest_q;
    wire [22:0] fracR_uid24_fpToFPTest_q;
    wire [7:0] expR_uid26_fpToFPTest_in;
    wire [7:0] expR_uid26_fpToFPTest_b;
    wire [11:0] expUdf_uid27_fpToFPTest_a;
    wire [11:0] expUdf_uid27_fpToFPTest_b;
    logic [11:0] expUdf_uid27_fpToFPTest_o;
    wire [0:0] expUdf_uid27_fpToFPTest_n;
    wire [7:0] expWEOutAllO_uid28_fpToFPTest_q;
    wire [11:0] expOvf_uid29_fpToFPTest_a;
    wire [11:0] expOvf_uid29_fpToFPTest_b;
    logic [11:0] expOvf_uid29_fpToFPTest_o;
    wire [0:0] expOvf_uid29_fpToFPTest_n;
    wire [0:0] inRegAndUdf_uid30_fpToFPTest_q;
    wire [0:0] excRZero_uid31_fpToFPTest_q;
    wire [0:0] inRegAndOvf_uid32_fpToFPTest_q;
    wire [0:0] excRInf_uid33_fpToFPTest_q;
    wire [2:0] concExc_uid34_fpToFPTest_q;
    reg [1:0] excREnc_uid35_fpToFPTest_q;
    wire [22:0] oneFracRPostExc2_uid36_fpToFPTest_q;
    wire [22:0] zeroFracRPostExc_uid37_fpToFPTest_q;
    wire [1:0] fracRPostExc_uid39_fpToFPTest_s;
    reg [22:0] fracRPostExc_uid39_fpToFPTest_q;
    wire [7:0] zeroExpRPostExc_uid42_fpToFPTest_q;
    wire [1:0] expRPostExc_uid43_fpToFPTest_s;
    reg [7:0] expRPostExc_uid43_fpToFPTest_q;
    wire [0:0] signX_uid44_fpToFPTest_b;
    wire [31:0] fpRes_uid45_fpToFPTest_q;
    wire [6:0] expRExt_uid25_fpToFPTest_MSBs_sums_a;
    wire [6:0] expRExt_uid25_fpToFPTest_MSBs_sums_b;
    logic [6:0] expRExt_uid25_fpToFPTest_MSBs_sums_o;
    wire [5:0] expRExt_uid25_fpToFPTest_MSBs_sums_q;
    wire [9:0] expRExt_uid25_fpToFPTest_split_join_q;
    wire [4:0] expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q;
    wire [0:0] expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_b;
    wire [3:0] expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_c;


    // signX_uid44_fpToFPTest(BITSELECT,43)@0
    assign signX_uid44_fpToFPTest_b = a[15:15];

    // expWEOutAllO_uid28_fpToFPTest(CONSTANT,27)
    assign expWEOutAllO_uid28_fpToFPTest_q = 8'b11111111;

    // expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const(CONSTANT,51)
    assign expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q = 5'b00111;

    // expRExt_uid25_fpToFPTest_MSBs_sums(ADD,49)@0
    assign expRExt_uid25_fpToFPTest_MSBs_sums_a = $unsigned({{2{expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q[4]}}, expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q});
    assign expRExt_uid25_fpToFPTest_MSBs_sums_b = $unsigned({6'b000000, expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_b});
    assign expRExt_uid25_fpToFPTest_MSBs_sums_o = $unsigned($signed(expRExt_uid25_fpToFPTest_MSBs_sums_a) + $signed(expRExt_uid25_fpToFPTest_MSBs_sums_b));
    assign expRExt_uid25_fpToFPTest_MSBs_sums_q = $signed(expRExt_uid25_fpToFPTest_MSBs_sums_o[5:0]);

    // exp_x_uid10_fpToFPTest(BITSELECT,9)@0
    assign exp_x_uid10_fpToFPTest_b = $signed(a[14:10]);

    // expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged(BITSELECT,52)@0
    assign expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_b = $signed(exp_x_uid10_fpToFPTest_b[4:4]);
    assign expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_c = $signed(exp_x_uid10_fpToFPTest_b[3:0]);

    // expRExt_uid25_fpToFPTest_split_join(BITJOIN,50)@0
    assign expRExt_uid25_fpToFPTest_split_join_q = {expRExt_uid25_fpToFPTest_MSBs_sums_q, expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_c};

    // expR_uid26_fpToFPTest(BITSELECT,25)@0
    assign expR_uid26_fpToFPTest_in = expRExt_uid25_fpToFPTest_split_join_q[7:0];
    assign expR_uid26_fpToFPTest_b = $signed(expR_uid26_fpToFPTest_in[7:0]);

    // zeroExpRPostExc_uid42_fpToFPTest(CONSTANT,41)
    assign zeroExpRPostExc_uid42_fpToFPTest_q = 8'b00000000;

    // frac_x_uid11_fpToFPTest(BITSELECT,10)@0
    assign frac_x_uid11_fpToFPTest_b = $signed(a[9:0]);

    // cstZeroWF_uid8_fpToFPTest(CONSTANT,7)
    assign cstZeroWF_uid8_fpToFPTest_q = 10'b0000000000;

    // fracXIsZero_uid14_fpToFPTest(LOGICAL,13)@0
    assign fracXIsZero_uid14_fpToFPTest_q = cstZeroWF_uid8_fpToFPTest_q == frac_x_uid11_fpToFPTest_b ? 1'b1 : 1'b0;

    // fracXIsNotZero_uid15_fpToFPTest(LOGICAL,14)@0
    assign fracXIsNotZero_uid15_fpToFPTest_q = $signed(~ (fracXIsZero_uid14_fpToFPTest_q));

    // cstAllOWE_uid7_fpToFPTest(CONSTANT,6)
    assign cstAllOWE_uid7_fpToFPTest_q = 5'b11111;

    // expXIsMax_uid13_fpToFPTest(LOGICAL,12)@0
    assign expXIsMax_uid13_fpToFPTest_q = exp_x_uid10_fpToFPTest_b == cstAllOWE_uid7_fpToFPTest_q ? 1'b1 : 1'b0;

    // excN_x_uid17_fpToFPTest(LOGICAL,16)@0
    assign excN_x_uid17_fpToFPTest_q = $signed(expXIsMax_uid13_fpToFPTest_q & fracXIsNotZero_uid15_fpToFPTest_q);

    // GND(CONSTANT,0)
    assign GND_q = 1'b0;

    // expOvf_uid29_fpToFPTest(COMPARE,28)@0
    assign expOvf_uid29_fpToFPTest_a = $unsigned({{2{expRExt_uid25_fpToFPTest_split_join_q[9]}}, expRExt_uid25_fpToFPTest_split_join_q});
    assign expOvf_uid29_fpToFPTest_b = $unsigned({4'b0000, expWEOutAllO_uid28_fpToFPTest_q});
    assign expOvf_uid29_fpToFPTest_o = $unsigned($signed(expOvf_uid29_fpToFPTest_a) - $signed(expOvf_uid29_fpToFPTest_b));
    assign expOvf_uid29_fpToFPTest_n[0] = ~ (expOvf_uid29_fpToFPTest_o[11]);

    // invExpXIsMax_uid18_fpToFPTest(LOGICAL,17)@0
    assign invExpXIsMax_uid18_fpToFPTest_q = $signed(~ (expXIsMax_uid13_fpToFPTest_q));

    // cstAllZWE_uid9_fpToFPTest(CONSTANT,8)
    assign cstAllZWE_uid9_fpToFPTest_q = 5'b00000;

    // excZ_x_uid12_fpToFPTest(LOGICAL,11)@0
    assign excZ_x_uid12_fpToFPTest_q = exp_x_uid10_fpToFPTest_b == cstAllZWE_uid9_fpToFPTest_q ? 1'b1 : 1'b0;

    // InvExpXIsZero_uid19_fpToFPTest(LOGICAL,18)@0
    assign InvExpXIsZero_uid19_fpToFPTest_q = $signed(~ (excZ_x_uid12_fpToFPTest_q));

    // excR_x_uid20_fpToFPTest(LOGICAL,19)@0
    assign excR_x_uid20_fpToFPTest_q = $signed(InvExpXIsZero_uid19_fpToFPTest_q & invExpXIsMax_uid18_fpToFPTest_q);

    // inRegAndOvf_uid32_fpToFPTest(LOGICAL,31)@0
    assign inRegAndOvf_uid32_fpToFPTest_q = $signed(excR_x_uid20_fpToFPTest_q & expOvf_uid29_fpToFPTest_n);

    // excI_x_uid16_fpToFPTest(LOGICAL,15)@0
    assign excI_x_uid16_fpToFPTest_q = $signed(expXIsMax_uid13_fpToFPTest_q & fracXIsZero_uid14_fpToFPTest_q);

    // excRInf_uid33_fpToFPTest(LOGICAL,32)@0
    assign excRInf_uid33_fpToFPTest_q = $signed(excI_x_uid16_fpToFPTest_q | inRegAndOvf_uid32_fpToFPTest_q);

    // expUdf_uid27_fpToFPTest(COMPARE,26)@0
    assign expUdf_uid27_fpToFPTest_a = $unsigned({11'b00000000000, GND_q});
    assign expUdf_uid27_fpToFPTest_b = $unsigned({{2{expRExt_uid25_fpToFPTest_split_join_q[9]}}, expRExt_uid25_fpToFPTest_split_join_q});
    assign expUdf_uid27_fpToFPTest_o = $unsigned($signed(expUdf_uid27_fpToFPTest_a) - $signed(expUdf_uid27_fpToFPTest_b));
    assign expUdf_uid27_fpToFPTest_n[0] = ~ (expUdf_uid27_fpToFPTest_o[11]);

    // inRegAndUdf_uid30_fpToFPTest(LOGICAL,29)@0
    assign inRegAndUdf_uid30_fpToFPTest_q = $signed(excR_x_uid20_fpToFPTest_q & expUdf_uid27_fpToFPTest_n);

    // excRZero_uid31_fpToFPTest(LOGICAL,30)@0
    assign excRZero_uid31_fpToFPTest_q = $signed(excZ_x_uid12_fpToFPTest_q | inRegAndUdf_uid30_fpToFPTest_q);

    // concExc_uid34_fpToFPTest(BITJOIN,33)@0
    assign concExc_uid34_fpToFPTest_q = {excN_x_uid17_fpToFPTest_q, excRInf_uid33_fpToFPTest_q, excRZero_uid31_fpToFPTest_q};

    // excREnc_uid35_fpToFPTest(LOOKUP,34)@0
    always_comb 
    begin
        // Begin reserved scope level
        unique case (concExc_uid34_fpToFPTest_q)
            3'b000 : excREnc_uid35_fpToFPTest_q = 2'b01;
            3'b001 : excREnc_uid35_fpToFPTest_q = 2'b00;
            3'b010 : excREnc_uid35_fpToFPTest_q = 2'b10;
            3'b011 : excREnc_uid35_fpToFPTest_q = 2'b00;
            3'b100 : excREnc_uid35_fpToFPTest_q = 2'b11;
            3'b101 : excREnc_uid35_fpToFPTest_q = 2'b00;
            3'b110 : excREnc_uid35_fpToFPTest_q = 2'b00;
            3'b111 : excREnc_uid35_fpToFPTest_q = 2'b00;
            default : begin
                          // unreachable
                          excREnc_uid35_fpToFPTest_q = 2'bxx;
                      end
        endcase
        // End reserved scope level
    end

    // expRPostExc_uid43_fpToFPTest(MUX,42)@0
    assign expRPostExc_uid43_fpToFPTest_s = excREnc_uid35_fpToFPTest_q;
    always_comb 
    begin
        unique case (expRPostExc_uid43_fpToFPTest_s)
            2'b00 : expRPostExc_uid43_fpToFPTest_q = zeroExpRPostExc_uid42_fpToFPTest_q;
            2'b01 : expRPostExc_uid43_fpToFPTest_q = expR_uid26_fpToFPTest_b;
            2'b10 : expRPostExc_uid43_fpToFPTest_q = expWEOutAllO_uid28_fpToFPTest_q;
            2'b11 : expRPostExc_uid43_fpToFPTest_q = expWEOutAllO_uid28_fpToFPTest_q;
            default : expRPostExc_uid43_fpToFPTest_q = 8'b0;
        endcase
    end

    // oneFracRPostExc2_uid36_fpToFPTest(CONSTANT,35)
    assign oneFracRPostExc2_uid36_fpToFPTest_q = 23'b00000000000000000000001;

    // zP_uid23_fpToFPTest(CONSTANT,22)
    assign zP_uid23_fpToFPTest_q = 13'b0000000000000;

    // fracR_uid24_fpToFPTest(BITJOIN,23)@0
    assign fracR_uid24_fpToFPTest_q = {frac_x_uid11_fpToFPTest_b, zP_uid23_fpToFPTest_q};

    // zeroFracRPostExc_uid37_fpToFPTest(CONSTANT,36)
    assign zeroFracRPostExc_uid37_fpToFPTest_q = 23'b00000000000000000000000;

    // fracRPostExc_uid39_fpToFPTest(MUX,38)@0
    assign fracRPostExc_uid39_fpToFPTest_s = excREnc_uid35_fpToFPTest_q;
    always_comb 
    begin
        unique case (fracRPostExc_uid39_fpToFPTest_s)
            2'b00 : fracRPostExc_uid39_fpToFPTest_q = zeroFracRPostExc_uid37_fpToFPTest_q;
            2'b01 : fracRPostExc_uid39_fpToFPTest_q = fracR_uid24_fpToFPTest_q;
            2'b10 : fracRPostExc_uid39_fpToFPTest_q = zeroFracRPostExc_uid37_fpToFPTest_q;
            2'b11 : fracRPostExc_uid39_fpToFPTest_q = oneFracRPostExc2_uid36_fpToFPTest_q;
            default : fracRPostExc_uid39_fpToFPTest_q = 23'b0;
        endcase
    end

    // fpRes_uid45_fpToFPTest(BITJOIN,44)@0
    assign fpRes_uid45_fpToFPTest_q = {signX_uid44_fpToFPTest_b, expRPostExc_uid43_fpToFPTest_q, fracRPostExc_uid39_fpToFPTest_q};

    // xOut(GPOUT,4)@0
    assign q = fpRes_uid45_fpToFPTest_q;

endmodule
