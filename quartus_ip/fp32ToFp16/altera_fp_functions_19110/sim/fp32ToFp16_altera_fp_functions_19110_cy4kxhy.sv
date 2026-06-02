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

// SystemVerilog created from fp32ToFp16_altera_fp_functions_19110_cy4kxhy
// SystemVerilog created on Mon Jun  1 12:06:55 2026


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module fp32ToFp16_altera_fp_functions_19110_cy4kxhy (
    input wire [31:0] a,
    output wire [15:0] q,
    input wire clk,
    input wire areset
    );

    wire [0:0] GND_q;
    wire [0:0] VCC_q;
    wire [7:0] cstAllOWE_uid7_fpToFPTest_q;
    wire [22:0] cstZeroWF_uid8_fpToFPTest_q;
    wire [7:0] cstAllZWE_uid9_fpToFPTest_q;
    wire [7:0] exp_x_uid10_fpToFPTest_b;
    wire [22:0] frac_x_uid11_fpToFPTest_b;
    wire [0:0] excZ_x_uid12_fpToFPTest_qi;
    reg [0:0] excZ_x_uid12_fpToFPTest_q;
    wire [0:0] expXIsMax_uid13_fpToFPTest_qi;
    reg [0:0] expXIsMax_uid13_fpToFPTest_q;
    wire [0:0] fracXIsZero_uid14_fpToFPTest_qi;
    reg [0:0] fracXIsZero_uid14_fpToFPTest_q;
    wire [0:0] fracXIsNotZero_uid15_fpToFPTest_q;
    wire [0:0] excI_x_uid16_fpToFPTest_q;
    wire [0:0] excN_x_uid17_fpToFPTest_qi;
    reg [0:0] excN_x_uid17_fpToFPTest_q;
    wire [0:0] invExpXIsMax_uid18_fpToFPTest_q;
    wire [0:0] InvExpXIsZero_uid19_fpToFPTest_q;
    wire [0:0] excR_x_uid20_fpToFPTest_q;
    wire [10:0] fracXWOP1_uid23_fpToFPTest_b;
    wire [18:0] expXFracX_uid24_fpToFPTest_q;
    wire [21:0] expFracR_uid29_fpToFPTest_a;
    wire [21:0] expFracR_uid29_fpToFPTest_b;
    logic [21:0] expFracR_uid29_fpToFPTest_o;
    wire [20:0] expFracR_uid29_fpToFPTest_q;
    wire [10:0] fracR_uid30_fpToFPTest_in;
    wire [9:0] fracR_uid30_fpToFPTest_b;
    wire [15:0] expR_uid31_fpToFPTest_in;
    wire [4:0] expR_uid31_fpToFPTest_b;
    wire [9:0] expRExt_uid32_fpToFPTest_b;
    wire [11:0] expUdf_uid33_fpToFPTest_a;
    wire [11:0] expUdf_uid33_fpToFPTest_b;
    logic [11:0] expUdf_uid33_fpToFPTest_o;
    wire [0:0] expUdf_uid33_fpToFPTest_n;
    wire [4:0] expWEOutAllO_uid34_fpToFPTest_q;
    wire [11:0] expOvf_uid35_fpToFPTest_a;
    wire [11:0] expOvf_uid35_fpToFPTest_b;
    logic [11:0] expOvf_uid35_fpToFPTest_o;
    wire [0:0] expOvf_uid35_fpToFPTest_n;
    wire [0:0] inRegAndUdf_uid36_fpToFPTest_q;
    wire [0:0] excRZero_uid37_fpToFPTest_qi;
    reg [0:0] excRZero_uid37_fpToFPTest_q;
    wire [0:0] inRegAndOvf_uid38_fpToFPTest_q;
    wire [0:0] excRInf_uid39_fpToFPTest_qi;
    reg [0:0] excRInf_uid39_fpToFPTest_q;
    wire [2:0] concExc_uid40_fpToFPTest_q;
    reg [1:0] excREnc_uid41_fpToFPTest_q;
    wire [9:0] oneFracRPostExc2_uid42_fpToFPTest_q;
    wire [9:0] zeroFracRPostExc_uid43_fpToFPTest_q;
    wire [1:0] fracRPostExc_uid45_fpToFPTest_s;
    reg [9:0] fracRPostExc_uid45_fpToFPTest_q;
    wire [4:0] zeroExpRPostExc_uid48_fpToFPTest_q;
    wire [1:0] expRPostExc_uid49_fpToFPTest_s;
    reg [4:0] expRPostExc_uid49_fpToFPTest_q;
    wire [0:0] signX_uid50_fpToFPTest_b;
    wire [15:0] fpRes_uid51_fpToFPTest_q;
    wire [19:0] rndExpUpdate_uid28_fpToFPTest_q_const_q;
    reg [0:0] redist0_signX_uid50_fpToFPTest_b_2_q;
    reg [0:0] redist0_signX_uid50_fpToFPTest_b_2_delay_0;
    reg [4:0] redist1_expR_uid31_fpToFPTest_b_1_q;
    reg [9:0] redist2_fracR_uid30_fpToFPTest_b_1_q;


    // VCC(CONSTANT,1)
    assign VCC_q = 1'b1;

    // signX_uid50_fpToFPTest(BITSELECT,49)@0
    assign signX_uid50_fpToFPTest_b = a[31:31];

    // redist0_signX_uid50_fpToFPTest_b_2(DELAY,54)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else
        begin
            redist0_signX_uid50_fpToFPTest_b_2_delay_0 <= $unsigned(signX_uid50_fpToFPTest_b);
            redist0_signX_uid50_fpToFPTest_b_2_q <= $signed(redist0_signX_uid50_fpToFPTest_b_2_delay_0);
        end
    end

    // expWEOutAllO_uid34_fpToFPTest(CONSTANT,33)
    assign expWEOutAllO_uid34_fpToFPTest_q = 5'b11111;

    // rndExpUpdate_uid28_fpToFPTest_q_const(CONSTANT,53)
    assign rndExpUpdate_uid28_fpToFPTest_q_const_q = 20'b11001000000000000001;

    // exp_x_uid10_fpToFPTest(BITSELECT,9)@0
    assign exp_x_uid10_fpToFPTest_b = $signed(a[30:23]);

    // frac_x_uid11_fpToFPTest(BITSELECT,10)@0
    assign frac_x_uid11_fpToFPTest_b = $signed(a[22:0]);

    // fracXWOP1_uid23_fpToFPTest(BITSELECT,22)@0
    assign fracXWOP1_uid23_fpToFPTest_b = $signed(frac_x_uid11_fpToFPTest_b[22:12]);

    // expXFracX_uid24_fpToFPTest(BITJOIN,23)@0
    assign expXFracX_uid24_fpToFPTest_q = {exp_x_uid10_fpToFPTest_b, fracXWOP1_uid23_fpToFPTest_b};

    // expFracR_uid29_fpToFPTest(ADD,28)@0 + 1
    assign expFracR_uid29_fpToFPTest_a = $unsigned({3'b000, expXFracX_uid24_fpToFPTest_q});
    assign expFracR_uid29_fpToFPTest_b = $unsigned({{2{rndExpUpdate_uid28_fpToFPTest_q_const_q[19]}}, rndExpUpdate_uid28_fpToFPTest_q_const_q});
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else
        begin
            expFracR_uid29_fpToFPTest_o <= $unsigned($signed(expFracR_uid29_fpToFPTest_a) + $signed(expFracR_uid29_fpToFPTest_b));
        end
    end
    assign expFracR_uid29_fpToFPTest_q = $signed(expFracR_uid29_fpToFPTest_o[20:0]);

    // expR_uid31_fpToFPTest(BITSELECT,30)@1
    assign expR_uid31_fpToFPTest_in = expFracR_uid29_fpToFPTest_q[15:0];
    assign expR_uid31_fpToFPTest_b = $signed(expR_uid31_fpToFPTest_in[15:11]);

    // redist1_expR_uid31_fpToFPTest_b_1(DELAY,55)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else
        begin
            redist1_expR_uid31_fpToFPTest_b_1_q <= expR_uid31_fpToFPTest_b;
        end
    end

    // zeroExpRPostExc_uid48_fpToFPTest(CONSTANT,47)
    assign zeroExpRPostExc_uid48_fpToFPTest_q = 5'b00000;

    // cstZeroWF_uid8_fpToFPTest(CONSTANT,7)
    assign cstZeroWF_uid8_fpToFPTest_q = 23'b00000000000000000000000;

    // fracXIsZero_uid14_fpToFPTest(LOGICAL,13)@0 + 1
    assign fracXIsZero_uid14_fpToFPTest_qi = $unsigned(cstZeroWF_uid8_fpToFPTest_q == frac_x_uid11_fpToFPTest_b ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("NONE"), .phase(0), .modulus(1) )
    fracXIsZero_uid14_fpToFPTest_delay ( .xin(fracXIsZero_uid14_fpToFPTest_qi), .xout(fracXIsZero_uid14_fpToFPTest_q), .clk(clk), .aclr(areset), .ena(1'b1) );

    // fracXIsNotZero_uid15_fpToFPTest(LOGICAL,14)@1
    assign fracXIsNotZero_uid15_fpToFPTest_q = $signed(~ (fracXIsZero_uid14_fpToFPTest_q));

    // cstAllOWE_uid7_fpToFPTest(CONSTANT,6)
    assign cstAllOWE_uid7_fpToFPTest_q = 8'b11111111;

    // expXIsMax_uid13_fpToFPTest(LOGICAL,12)@0 + 1
    assign expXIsMax_uid13_fpToFPTest_qi = $unsigned(exp_x_uid10_fpToFPTest_b == cstAllOWE_uid7_fpToFPTest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("NONE"), .phase(0), .modulus(1) )
    expXIsMax_uid13_fpToFPTest_delay ( .xin(expXIsMax_uid13_fpToFPTest_qi), .xout(expXIsMax_uid13_fpToFPTest_q), .clk(clk), .aclr(areset), .ena(1'b1) );

    // excN_x_uid17_fpToFPTest(LOGICAL,16)@1 + 1
    assign excN_x_uid17_fpToFPTest_qi = expXIsMax_uid13_fpToFPTest_q & fracXIsNotZero_uid15_fpToFPTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("NONE"), .phase(0), .modulus(1) )
    excN_x_uid17_fpToFPTest_delay ( .xin(excN_x_uid17_fpToFPTest_qi), .xout(excN_x_uid17_fpToFPTest_q), .clk(clk), .aclr(areset), .ena(1'b1) );

    // GND(CONSTANT,0)
    assign GND_q = 1'b0;

    // expRExt_uid32_fpToFPTest(BITSELECT,31)@1
    assign expRExt_uid32_fpToFPTest_b = expFracR_uid29_fpToFPTest_q[20:11];

    // expOvf_uid35_fpToFPTest(COMPARE,34)@1
    assign expOvf_uid35_fpToFPTest_a = $unsigned({{2{expRExt_uid32_fpToFPTest_b[9]}}, expRExt_uid32_fpToFPTest_b});
    assign expOvf_uid35_fpToFPTest_b = $unsigned({7'b0000000, expWEOutAllO_uid34_fpToFPTest_q});
    assign expOvf_uid35_fpToFPTest_o = $unsigned($signed(expOvf_uid35_fpToFPTest_a) - $signed(expOvf_uid35_fpToFPTest_b));
    assign expOvf_uid35_fpToFPTest_n[0] = ~ (expOvf_uid35_fpToFPTest_o[11]);

    // invExpXIsMax_uid18_fpToFPTest(LOGICAL,17)@1
    assign invExpXIsMax_uid18_fpToFPTest_q = $signed(~ (expXIsMax_uid13_fpToFPTest_q));

    // cstAllZWE_uid9_fpToFPTest(CONSTANT,8)
    assign cstAllZWE_uid9_fpToFPTest_q = 8'b00000000;

    // excZ_x_uid12_fpToFPTest(LOGICAL,11)@0 + 1
    assign excZ_x_uid12_fpToFPTest_qi = $unsigned(exp_x_uid10_fpToFPTest_b == cstAllZWE_uid9_fpToFPTest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("NONE"), .phase(0), .modulus(1) )
    excZ_x_uid12_fpToFPTest_delay ( .xin(excZ_x_uid12_fpToFPTest_qi), .xout(excZ_x_uid12_fpToFPTest_q), .clk(clk), .aclr(areset), .ena(1'b1) );

    // InvExpXIsZero_uid19_fpToFPTest(LOGICAL,18)@1
    assign InvExpXIsZero_uid19_fpToFPTest_q = $signed(~ (excZ_x_uid12_fpToFPTest_q));

    // excR_x_uid20_fpToFPTest(LOGICAL,19)@1
    assign excR_x_uid20_fpToFPTest_q = $signed(InvExpXIsZero_uid19_fpToFPTest_q & invExpXIsMax_uid18_fpToFPTest_q);

    // inRegAndOvf_uid38_fpToFPTest(LOGICAL,37)@1
    assign inRegAndOvf_uid38_fpToFPTest_q = $signed(excR_x_uid20_fpToFPTest_q & expOvf_uid35_fpToFPTest_n);

    // excI_x_uid16_fpToFPTest(LOGICAL,15)@1
    assign excI_x_uid16_fpToFPTest_q = $signed(expXIsMax_uid13_fpToFPTest_q & fracXIsZero_uid14_fpToFPTest_q);

    // excRInf_uid39_fpToFPTest(LOGICAL,38)@1 + 1
    assign excRInf_uid39_fpToFPTest_qi = excI_x_uid16_fpToFPTest_q | inRegAndOvf_uid38_fpToFPTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("NONE"), .phase(0), .modulus(1) )
    excRInf_uid39_fpToFPTest_delay ( .xin(excRInf_uid39_fpToFPTest_qi), .xout(excRInf_uid39_fpToFPTest_q), .clk(clk), .aclr(areset), .ena(1'b1) );

    // expUdf_uid33_fpToFPTest(COMPARE,32)@1
    assign expUdf_uid33_fpToFPTest_a = $unsigned({11'b00000000000, GND_q});
    assign expUdf_uid33_fpToFPTest_b = $unsigned({{2{expRExt_uid32_fpToFPTest_b[9]}}, expRExt_uid32_fpToFPTest_b});
    assign expUdf_uid33_fpToFPTest_o = $unsigned($signed(expUdf_uid33_fpToFPTest_a) - $signed(expUdf_uid33_fpToFPTest_b));
    assign expUdf_uid33_fpToFPTest_n[0] = ~ (expUdf_uid33_fpToFPTest_o[11]);

    // inRegAndUdf_uid36_fpToFPTest(LOGICAL,35)@1
    assign inRegAndUdf_uid36_fpToFPTest_q = $signed(excR_x_uid20_fpToFPTest_q & expUdf_uid33_fpToFPTest_n);

    // excRZero_uid37_fpToFPTest(LOGICAL,36)@1 + 1
    assign excRZero_uid37_fpToFPTest_qi = excZ_x_uid12_fpToFPTest_q | inRegAndUdf_uid36_fpToFPTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("NONE"), .phase(0), .modulus(1) )
    excRZero_uid37_fpToFPTest_delay ( .xin(excRZero_uid37_fpToFPTest_qi), .xout(excRZero_uid37_fpToFPTest_q), .clk(clk), .aclr(areset), .ena(1'b1) );

    // concExc_uid40_fpToFPTest(BITJOIN,39)@2
    assign concExc_uid40_fpToFPTest_q = {excN_x_uid17_fpToFPTest_q, excRInf_uid39_fpToFPTest_q, excRZero_uid37_fpToFPTest_q};

    // excREnc_uid41_fpToFPTest(LOOKUP,40)@2
    always_comb 
    begin
        // Begin reserved scope level
        unique case (concExc_uid40_fpToFPTest_q)
            3'b000 : excREnc_uid41_fpToFPTest_q = 2'b01;
            3'b001 : excREnc_uid41_fpToFPTest_q = 2'b00;
            3'b010 : excREnc_uid41_fpToFPTest_q = 2'b10;
            3'b011 : excREnc_uid41_fpToFPTest_q = 2'b00;
            3'b100 : excREnc_uid41_fpToFPTest_q = 2'b11;
            3'b101 : excREnc_uid41_fpToFPTest_q = 2'b00;
            3'b110 : excREnc_uid41_fpToFPTest_q = 2'b00;
            3'b111 : excREnc_uid41_fpToFPTest_q = 2'b00;
            default : begin
                          // unreachable
                          excREnc_uid41_fpToFPTest_q = 2'bxx;
                      end
        endcase
        // End reserved scope level
    end

    // expRPostExc_uid49_fpToFPTest(MUX,48)@2
    assign expRPostExc_uid49_fpToFPTest_s = excREnc_uid41_fpToFPTest_q;
    always_comb 
    begin
        unique case (expRPostExc_uid49_fpToFPTest_s)
            2'b00 : expRPostExc_uid49_fpToFPTest_q = zeroExpRPostExc_uid48_fpToFPTest_q;
            2'b01 : expRPostExc_uid49_fpToFPTest_q = redist1_expR_uid31_fpToFPTest_b_1_q;
            2'b10 : expRPostExc_uid49_fpToFPTest_q = expWEOutAllO_uid34_fpToFPTest_q;
            2'b11 : expRPostExc_uid49_fpToFPTest_q = expWEOutAllO_uid34_fpToFPTest_q;
            default : expRPostExc_uid49_fpToFPTest_q = 5'b0;
        endcase
    end

    // oneFracRPostExc2_uid42_fpToFPTest(CONSTANT,41)
    assign oneFracRPostExc2_uid42_fpToFPTest_q = 10'b0000000001;

    // fracR_uid30_fpToFPTest(BITSELECT,29)@1
    assign fracR_uid30_fpToFPTest_in = expFracR_uid29_fpToFPTest_q[10:0];
    assign fracR_uid30_fpToFPTest_b = $signed(fracR_uid30_fpToFPTest_in[10:1]);

    // redist2_fracR_uid30_fpToFPTest_b_1(DELAY,56)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else
        begin
            redist2_fracR_uid30_fpToFPTest_b_1_q <= fracR_uid30_fpToFPTest_b;
        end
    end

    // zeroFracRPostExc_uid43_fpToFPTest(CONSTANT,42)
    assign zeroFracRPostExc_uid43_fpToFPTest_q = 10'b0000000000;

    // fracRPostExc_uid45_fpToFPTest(MUX,44)@2
    assign fracRPostExc_uid45_fpToFPTest_s = excREnc_uid41_fpToFPTest_q;
    always_comb 
    begin
        unique case (fracRPostExc_uid45_fpToFPTest_s)
            2'b00 : fracRPostExc_uid45_fpToFPTest_q = zeroFracRPostExc_uid43_fpToFPTest_q;
            2'b01 : fracRPostExc_uid45_fpToFPTest_q = redist2_fracR_uid30_fpToFPTest_b_1_q;
            2'b10 : fracRPostExc_uid45_fpToFPTest_q = zeroFracRPostExc_uid43_fpToFPTest_q;
            2'b11 : fracRPostExc_uid45_fpToFPTest_q = oneFracRPostExc2_uid42_fpToFPTest_q;
            default : fracRPostExc_uid45_fpToFPTest_q = 10'b0;
        endcase
    end

    // fpRes_uid51_fpToFPTest(BITJOIN,50)@2
    assign fpRes_uid51_fpToFPTest_q = {redist0_signX_uid50_fpToFPTest_b_2_q, expRPostExc_uid49_fpToFPTest_q, fracRPostExc_uid45_fpToFPTest_q};

    // xOut(GPOUT,4)@2
    assign q = fpRes_uid51_fpToFPTest_q;

endmodule
