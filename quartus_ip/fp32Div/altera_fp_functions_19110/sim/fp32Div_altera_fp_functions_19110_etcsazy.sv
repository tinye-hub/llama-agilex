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

// SystemVerilog created from fp32Div_altera_fp_functions_19110_etcsazy
// SystemVerilog created on Tue Jun 30 04:21:21 2026


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module fp32Div_altera_fp_functions_19110_etcsazy (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [0:0] en,
    output wire [31:0] q,
    input wire clk,
    input wire areset
    );

    wire [0:0] GND_q;
    wire [0:0] VCC_q;
    wire [7:0] cstBias_uid7_fpDivTest_q;
    wire [7:0] expX_uid9_fpDivTest_b;
    wire [22:0] fracX_uid10_fpDivTest_b;
    wire [0:0] signX_uid11_fpDivTest_b;
    wire [7:0] expY_uid12_fpDivTest_b;
    wire [22:0] fracY_uid13_fpDivTest_b;
    wire [0:0] signY_uid14_fpDivTest_b;
    wire [23:0] fracYZero_uid15_fpDivTest_a;
    wire [0:0] fracYZero_uid15_fpDivTest_qi;
    reg [0:0] fracYZero_uid15_fpDivTest_q;
    wire [7:0] cstAllOWE_uid18_fpDivTest_q;
    wire [22:0] cstZeroWF_uid19_fpDivTest_q;
    wire [7:0] cstAllZWE_uid20_fpDivTest_q;
    wire [0:0] excZ_x_uid23_fpDivTest_qi;
    reg [0:0] excZ_x_uid23_fpDivTest_q;
    wire [0:0] expXIsMax_uid24_fpDivTest_qi;
    reg [0:0] expXIsMax_uid24_fpDivTest_q;
    wire [0:0] fracXIsZero_uid25_fpDivTest_qi;
    reg [0:0] fracXIsZero_uid25_fpDivTest_q;
    wire [0:0] fracXIsNotZero_uid26_fpDivTest_q;
    wire [0:0] excI_x_uid27_fpDivTest_q;
    wire [0:0] excN_x_uid28_fpDivTest_q;
    wire [0:0] invExpXIsMax_uid29_fpDivTest_q;
    wire [0:0] InvExpXIsZero_uid30_fpDivTest_q;
    wire [0:0] excR_x_uid31_fpDivTest_q;
    wire [0:0] excZ_y_uid37_fpDivTest_q;
    wire [0:0] expXIsMax_uid38_fpDivTest_qi;
    reg [0:0] expXIsMax_uid38_fpDivTest_q;
    wire [0:0] fracXIsZero_uid39_fpDivTest_qi;
    reg [0:0] fracXIsZero_uid39_fpDivTest_q;
    wire [0:0] fracXIsNotZero_uid40_fpDivTest_q;
    wire [0:0] excI_y_uid41_fpDivTest_q;
    wire [0:0] excN_y_uid42_fpDivTest_q;
    wire [0:0] invExpXIsMax_uid43_fpDivTest_q;
    wire [0:0] InvExpXIsZero_uid44_fpDivTest_q;
    wire [0:0] excR_y_uid45_fpDivTest_q;
    wire [0:0] signR_uid46_fpDivTest_qi;
    reg [0:0] signR_uid46_fpDivTest_q;
    wire [8:0] expXmY_uid47_fpDivTest_a;
    wire [8:0] expXmY_uid47_fpDivTest_b;
    logic [8:0] expXmY_uid47_fpDivTest_o;
    wire [8:0] expXmY_uid47_fpDivTest_q;
    wire [8:0] yAddr_uid51_fpDivTest_b;
    wire [13:0] yPE_uid52_fpDivTest_b;
    wire [31:0] invY_uid54_fpDivTest_in;
    wire [26:0] invY_uid54_fpDivTest_b;
    wire [32:0] invYO_uid55_fpDivTest_in;
    wire [0:0] invYO_uid55_fpDivTest_b;
    wire [23:0] lOAdded_uid57_fpDivTest_q;
    wire [3:0] z4_uid60_fpDivTest_q;
    wire [27:0] oFracXZ4_uid61_fpDivTest_q;
    wire [0:0] divValPreNormYPow2Exc_uid63_fpDivTest_s;
    reg [27:0] divValPreNormYPow2Exc_uid63_fpDivTest_q;
    wire [0:0] norm_uid64_fpDivTest_b;
    wire [26:0] divValPreNormHigh_uid65_fpDivTest_in;
    wire [24:0] divValPreNormHigh_uid65_fpDivTest_b;
    wire [25:0] divValPreNormLow_uid66_fpDivTest_in;
    wire [24:0] divValPreNormLow_uid66_fpDivTest_b;
    wire [0:0] normFracRnd_uid67_fpDivTest_s;
    reg [24:0] normFracRnd_uid67_fpDivTest_q;
    wire [34:0] expFracRnd_uid68_fpDivTest_q;
    wire [23:0] zeroPaddingInAddition_uid74_fpDivTest_q;
    wire [25:0] expFracPostRnd_uid75_fpDivTest_q;
    wire [36:0] expFracPostRnd_uid76_fpDivTest_a;
    wire [36:0] expFracPostRnd_uid76_fpDivTest_b;
    logic [36:0] expFracPostRnd_uid76_fpDivTest_o;
    wire [35:0] expFracPostRnd_uid76_fpDivTest_q;
    wire [23:0] fracXExt_uid77_fpDivTest_q;
    wire [24:0] fracPostRndF_uid79_fpDivTest_in;
    wire [23:0] fracPostRndF_uid79_fpDivTest_b;
    wire [0:0] fracPostRndF_uid80_fpDivTest_s;
    reg [23:0] fracPostRndF_uid80_fpDivTest_q;
    wire [32:0] expPostRndFR_uid81_fpDivTest_in;
    wire [7:0] expPostRndFR_uid81_fpDivTest_b;
    wire [0:0] expPostRndF_uid82_fpDivTest_s;
    reg [7:0] expPostRndF_uid82_fpDivTest_q;
    wire [24:0] lOAdded_uid84_fpDivTest_q;
    wire [23:0] lOAdded_uid87_fpDivTest_q;
    wire [0:0] qDivProdNorm_uid90_fpDivTest_b;
    wire [47:0] qDivProdFracHigh_uid91_fpDivTest_in;
    wire [23:0] qDivProdFracHigh_uid91_fpDivTest_b;
    wire [46:0] qDivProdFracLow_uid92_fpDivTest_in;
    wire [23:0] qDivProdFracLow_uid92_fpDivTest_b;
    wire [0:0] qDivProdFrac_uid93_fpDivTest_s;
    reg [23:0] qDivProdFrac_uid93_fpDivTest_q;
    wire [8:0] qDivProdExp_opA_uid94_fpDivTest_a;
    wire [8:0] qDivProdExp_opA_uid94_fpDivTest_b;
    logic [8:0] qDivProdExp_opA_uid94_fpDivTest_o;
    wire [8:0] qDivProdExp_opA_uid94_fpDivTest_q;
    wire [8:0] qDivProdExp_opBs_uid95_fpDivTest_a;
    wire [8:0] qDivProdExp_opBs_uid95_fpDivTest_b;
    logic [8:0] qDivProdExp_opBs_uid95_fpDivTest_o;
    wire [8:0] qDivProdExp_opBs_uid95_fpDivTest_q;
    wire [11:0] qDivProdExp_uid96_fpDivTest_a;
    wire [11:0] qDivProdExp_uid96_fpDivTest_b;
    logic [11:0] qDivProdExp_uid96_fpDivTest_o;
    wire [10:0] qDivProdExp_uid96_fpDivTest_q;
    wire [22:0] qDivProdFracWF_uid97_fpDivTest_b;
    wire [7:0] qDivProdLTX_opA_uid98_fpDivTest_in;
    wire [7:0] qDivProdLTX_opA_uid98_fpDivTest_b;
    wire [30:0] qDivProdLTX_opA_uid99_fpDivTest_q;
    wire [30:0] qDivProdLTX_opB_uid100_fpDivTest_q;
    wire [32:0] qDividerProdLTX_uid101_fpDivTest_a;
    wire [32:0] qDividerProdLTX_uid101_fpDivTest_b;
    logic [32:0] qDividerProdLTX_uid101_fpDivTest_o;
    wire [0:0] qDividerProdLTX_uid101_fpDivTest_c;
    wire [0:0] betweenFPwF_uid102_fpDivTest_in;
    wire [0:0] betweenFPwF_uid102_fpDivTest_b;
    wire [0:0] extraUlp_uid103_fpDivTest_qi;
    reg [0:0] extraUlp_uid103_fpDivTest_q;
    wire [22:0] fracPostRndFT_uid104_fpDivTest_b;
    wire [23:0] fracRPreExcExt_uid105_fpDivTest_a;
    wire [23:0] fracRPreExcExt_uid105_fpDivTest_b;
    logic [23:0] fracRPreExcExt_uid105_fpDivTest_o;
    wire [23:0] fracRPreExcExt_uid105_fpDivTest_q;
    wire [22:0] fracPostRndFPostUlp_uid106_fpDivTest_in;
    wire [22:0] fracPostRndFPostUlp_uid106_fpDivTest_b;
    wire [0:0] fracRPreExc_uid107_fpDivTest_s;
    reg [22:0] fracRPreExc_uid107_fpDivTest_q;
    wire [0:0] ovfIncRnd_uid109_fpDivTest_b;
    wire [8:0] expFracPostRndInc_uid110_fpDivTest_a;
    wire [8:0] expFracPostRndInc_uid110_fpDivTest_b;
    logic [8:0] expFracPostRndInc_uid110_fpDivTest_o;
    wire [8:0] expFracPostRndInc_uid110_fpDivTest_q;
    wire [7:0] expFracPostRndR_uid111_fpDivTest_in;
    wire [7:0] expFracPostRndR_uid111_fpDivTest_b;
    wire [0:0] expRPreExc_uid112_fpDivTest_s;
    reg [7:0] expRPreExc_uid112_fpDivTest_q;
    wire [10:0] expRExt_uid114_fpDivTest_b;
    wire [12:0] expUdf_uid115_fpDivTest_a;
    wire [12:0] expUdf_uid115_fpDivTest_b;
    logic [12:0] expUdf_uid115_fpDivTest_o;
    wire [0:0] expUdf_uid115_fpDivTest_n;
    wire [12:0] expOvf_uid118_fpDivTest_a;
    wire [12:0] expOvf_uid118_fpDivTest_b;
    logic [12:0] expOvf_uid118_fpDivTest_o;
    wire [0:0] expOvf_uid118_fpDivTest_n;
    wire [0:0] zeroOverReg_uid119_fpDivTest_q;
    wire [0:0] regOverRegWithUf_uid120_fpDivTest_q;
    wire [0:0] xRegOrZero_uid121_fpDivTest_q;
    wire [0:0] regOrZeroOverInf_uid122_fpDivTest_q;
    wire [0:0] excRZero_uid123_fpDivTest_qi;
    reg [0:0] excRZero_uid123_fpDivTest_q;
    wire [0:0] excXRYZ_uid124_fpDivTest_q;
    wire [0:0] excXRYROvf_uid125_fpDivTest_q;
    wire [0:0] excXIYZ_uid126_fpDivTest_q;
    wire [0:0] excXIYR_uid127_fpDivTest_q;
    wire [0:0] excRInf_uid128_fpDivTest_qi;
    reg [0:0] excRInf_uid128_fpDivTest_q;
    wire [0:0] excXZYZ_uid129_fpDivTest_q;
    wire [0:0] excXIYI_uid130_fpDivTest_q;
    wire [0:0] excRNaN_uid131_fpDivTest_qi;
    reg [0:0] excRNaN_uid131_fpDivTest_q;
    wire [2:0] concExc_uid132_fpDivTest_q;
    reg [1:0] excREnc_uid133_fpDivTest_q;
    wire [22:0] oneFracRPostExc2_uid134_fpDivTest_q;
    wire [1:0] fracRPostExc_uid137_fpDivTest_s;
    reg [22:0] fracRPostExc_uid137_fpDivTest_q;
    wire [1:0] expRPostExc_uid141_fpDivTest_s;
    reg [7:0] expRPostExc_uid141_fpDivTest_q;
    wire [0:0] invExcRNaN_uid142_fpDivTest_q;
    wire [0:0] sRPostExc_uid143_fpDivTest_qi;
    reg [0:0] sRPostExc_uid143_fpDivTest_q;
    wire [31:0] divR_uid144_fpDivTest_q;
    wire [12:0] yT1_uid158_invPolyEval_b;
    wire [0:0] lowRangeB_uid160_invPolyEval_in;
    wire [0:0] lowRangeB_uid160_invPolyEval_b;
    wire [12:0] highBBits_uid161_invPolyEval_b;
    wire [22:0] s1sumAHighB_uid162_invPolyEval_a;
    wire [22:0] s1sumAHighB_uid162_invPolyEval_b;
    logic [22:0] s1sumAHighB_uid162_invPolyEval_o;
    wire [22:0] s1sumAHighB_uid162_invPolyEval_q;
    wire [23:0] s1_uid163_invPolyEval_q;
    wire [1:0] lowRangeB_uid166_invPolyEval_in;
    wire [1:0] lowRangeB_uid166_invPolyEval_b;
    wire [22:0] highBBits_uid167_invPolyEval_b;
    wire [32:0] s2sumAHighB_uid168_invPolyEval_a;
    wire [32:0] s2sumAHighB_uid168_invPolyEval_b;
    logic [32:0] s2sumAHighB_uid168_invPolyEval_o;
    wire [32:0] s2sumAHighB_uid168_invPolyEval_q;
    wire [34:0] s2_uid169_invPolyEval_q;
    wire [27:0] osig_uid172_divValPreNorm_uid59_fpDivTest_b;
    wire [13:0] osig_uid175_pT1_uid159_invPolyEval_b;
    wire [24:0] osig_uid178_pT2_uid165_invPolyEval_b;
    wire [9:0] expR_uid48_fpDivTest_MSBs_sums_a;
    wire [9:0] expR_uid48_fpDivTest_MSBs_sums_b;
    logic [9:0] expR_uid48_fpDivTest_MSBs_sums_o;
    wire [8:0] expR_uid48_fpDivTest_MSBs_sums_q;
    wire [9:0] expR_uid48_fpDivTest_split_join_q;
    wire memoryC0_uid146_invTables_lutmem_reset0;
    wire memoryC0_uid146_invTables_lutmem_ena_NotRstA;
    wire [31:0] memoryC0_uid146_invTables_lutmem_ia;
    wire [8:0] memoryC0_uid146_invTables_lutmem_aa;
    wire [8:0] memoryC0_uid146_invTables_lutmem_ab;
    wire [31:0] memoryC0_uid146_invTables_lutmem_ir;
    wire [31:0] memoryC0_uid146_invTables_lutmem_r;
    wire memoryC1_uid149_invTables_lutmem_reset0;
    wire memoryC1_uid149_invTables_lutmem_ena_NotRstA;
    wire [21:0] memoryC1_uid149_invTables_lutmem_ia;
    wire [8:0] memoryC1_uid149_invTables_lutmem_aa;
    wire [8:0] memoryC1_uid149_invTables_lutmem_ab;
    wire [21:0] memoryC1_uid149_invTables_lutmem_ir;
    wire [21:0] memoryC1_uid149_invTables_lutmem_r;
    wire memoryC2_uid152_invTables_lutmem_reset0;
    wire memoryC2_uid152_invTables_lutmem_ena_NotRstA;
    wire [12:0] memoryC2_uid152_invTables_lutmem_ia;
    wire [8:0] memoryC2_uid152_invTables_lutmem_aa;
    wire [8:0] memoryC2_uid152_invTables_lutmem_ab;
    wire [12:0] memoryC2_uid152_invTables_lutmem_ir;
    wire [12:0] memoryC2_uid152_invTables_lutmem_r;
    wire [6:0] expR_uid48_fpDivTest_lhsMSBs_select_b_const_q;
    wire qDivProd_uid89_fpDivTest_cma_reset;
    wire [24:0] qDivProd_uid89_fpDivTest_cma_a0;
    wire [23:0] qDivProd_uid89_fpDivTest_cma_c0;
    wire [48:0] qDivProd_uid89_fpDivTest_cma_s0;
    wire [48:0] qDivProd_uid89_fpDivTest_cma_qq0;
    reg [48:0] qDivProd_uid89_fpDivTest_cma_q;
    wire qDivProd_uid89_fpDivTest_cma_ena0;
    wire qDivProd_uid89_fpDivTest_cma_ena1;
    wire qDivProd_uid89_fpDivTest_cma_ena2;
    wire prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset;
    wire [26:0] prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_a0;
    wire [23:0] prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_c0;
    wire [50:0] prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_s0;
    wire [50:0] prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_qq0;
    reg [50:0] prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_q;
    wire prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0;
    wire prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena1;
    wire prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena2;
    wire prodXY_uid174_pT1_uid159_invPolyEval_cma_reset;
    wire [12:0] prodXY_uid174_pT1_uid159_invPolyEval_cma_a0;
    wire [12:0] prodXY_uid174_pT1_uid159_invPolyEval_cma_c0;
    wire [25:0] prodXY_uid174_pT1_uid159_invPolyEval_cma_s0;
    wire [25:0] prodXY_uid174_pT1_uid159_invPolyEval_cma_qq0;
    reg [25:0] prodXY_uid174_pT1_uid159_invPolyEval_cma_q;
    wire prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0;
    wire prodXY_uid174_pT1_uid159_invPolyEval_cma_ena1;
    wire prodXY_uid174_pT1_uid159_invPolyEval_cma_ena2;
    wire prodXY_uid177_pT2_uid165_invPolyEval_cma_reset;
    wire [13:0] prodXY_uid177_pT2_uid165_invPolyEval_cma_a0;
    wire [23:0] prodXY_uid177_pT2_uid165_invPolyEval_cma_c0;
    wire [37:0] prodXY_uid177_pT2_uid165_invPolyEval_cma_s0;
    wire [37:0] prodXY_uid177_pT2_uid165_invPolyEval_cma_qq0;
    reg [37:0] prodXY_uid177_pT2_uid165_invPolyEval_cma_q;
    wire prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0;
    wire prodXY_uid177_pT2_uid165_invPolyEval_cma_ena1;
    wire prodXY_uid177_pT2_uid165_invPolyEval_cma_ena2;
    wire [7:0] expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b;
    wire [0:0] expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_c;
    reg [23:0] redist0_s1_uid163_invPolyEval_q_1_q;
    reg [0:0] redist1_sRPostExc_uid143_fpDivTest_q_8_q;
    reg [1:0] redist2_excREnc_uid133_fpDivTest_q_8_q;
    reg [10:0] redist3_expRExt_uid114_fpDivTest_b_1_q;
    reg [0:0] redist4_ovfIncRnd_uid109_fpDivTest_b_1_q;
    reg [0:0] redist6_extraUlp_uid103_fpDivTest_q_2_q;
    reg [0:0] redist7_betweenFPwF_uid102_fpDivTest_b_7_q;
    reg [30:0] redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_q;
    reg [22:0] redist10_qDivProdFracWF_uid97_fpDivTest_b_1_q;
    reg [8:0] redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_q;
    reg [8:0] redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_0;
    reg [8:0] redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_1;
    reg [8:0] redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_2;
    reg [8:0] redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_3;
    reg [34:0] redist14_expFracRnd_uid68_fpDivTest_q_1_q;
    reg [0:0] redist15_norm_uid64_fpDivTest_b_1_q;
    reg [23:0] redist16_lOAdded_uid57_fpDivTest_q_5_q;
    reg [23:0] redist16_lOAdded_uid57_fpDivTest_q_5_delay_0;
    reg [23:0] redist16_lOAdded_uid57_fpDivTest_q_5_delay_1;
    reg [23:0] redist16_lOAdded_uid57_fpDivTest_q_5_delay_2;
    reg [0:0] redist17_invYO_uid55_fpDivTest_b_7_q;
    reg [26:0] redist18_invY_uid54_fpDivTest_b_1_q;
    reg [13:0] redist19_yPE_uid52_fpDivTest_b_2_q;
    reg [13:0] redist19_yPE_uid52_fpDivTest_b_2_delay_0;
    reg [8:0] redist21_yAddr_uid51_fpDivTest_b_5_q;
    reg [8:0] redist21_yAddr_uid51_fpDivTest_b_5_delay_0;
    reg [8:0] redist21_yAddr_uid51_fpDivTest_b_5_delay_1;
    reg [8:0] redist21_yAddr_uid51_fpDivTest_b_5_delay_2;
    reg [8:0] redist21_yAddr_uid51_fpDivTest_b_5_delay_3;
    reg [0:0] redist23_signR_uid46_fpDivTest_q_22_q;
    reg [0:0] redist24_fracXIsZero_uid39_fpDivTest_q_21_q;
    reg [0:0] redist25_fracYZero_uid15_fpDivTest_q_19_q;
    reg [7:0] redist27_expY_uid12_fpDivTest_b_20_q;
    reg [7:0] redist27_expY_uid12_fpDivTest_b_20_delay_0;
    reg [7:0] redist28_expY_uid12_fpDivTest_b_21_q;
    reg [7:0] redist30_expX_uid9_fpDivTest_b_4_q;
    reg [7:0] redist30_expX_uid9_fpDivTest_b_4_delay_0;
    reg [7:0] redist30_expX_uid9_fpDivTest_b_4_delay_1;
    reg [7:0] redist30_expX_uid9_fpDivTest_b_4_delay_2;
    reg [7:0] redist31_expX_uid9_fpDivTest_b_6_q;
    reg [7:0] redist31_expX_uid9_fpDivTest_b_6_delay_0;
    reg [22:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q;
    wire redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_reset0;
    wire redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ena_OrRstB;
    wire [22:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ia;
    wire [2:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_aa;
    wire [2:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ab;
    wire [22:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_iq;
    wire [22:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_q;
    wire [2:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i;
    (* preserve_syn_only *) reg redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq;
    wire [0:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s;
    reg [2:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q;
    reg [2:0] redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q;
    reg [30:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_q;
    wire redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_reset0;
    wire redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ena_OrRstB;
    wire [30:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ia;
    wire [2:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_aa;
    wire [2:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ab;
    wire [30:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_iq;
    wire [30:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_q;
    wire [2:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i;
    (* preserve_syn_only *) reg redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq;
    wire [0:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s;
    reg [2:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q;
    reg [2:0] redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q;
    wire redist12_lOAdded_uid87_fpDivTest_q_21_mem_reset0;
    wire redist12_lOAdded_uid87_fpDivTest_q_21_mem_ena_OrRstB;
    wire [23:0] redist12_lOAdded_uid87_fpDivTest_q_21_mem_ia;
    wire [4:0] redist12_lOAdded_uid87_fpDivTest_q_21_mem_aa;
    wire [4:0] redist12_lOAdded_uid87_fpDivTest_q_21_mem_ab;
    wire [23:0] redist12_lOAdded_uid87_fpDivTest_q_21_mem_iq;
    wire [23:0] redist12_lOAdded_uid87_fpDivTest_q_21_mem_q;
    wire [4:0] redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q;
    (* preserve_syn_only *) reg [4:0] redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i;
    (* preserve_syn_only *) reg redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq;
    wire [0:0] redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s;
    reg [4:0] redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q;
    reg [4:0] redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q;
    reg [7:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_q;
    reg [7:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q;
    wire redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_reset0;
    wire redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ena_OrRstB;
    wire [7:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ia;
    wire [2:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_aa;
    wire [2:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ab;
    wire [7:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_iq;
    wire [7:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_q;
    wire [2:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i;
    (* preserve_syn_only *) reg redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq;
    wire [0:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s;
    reg [2:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q;
    reg [2:0] redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q;
    reg [23:0] redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_q;
    wire redist20_yPE_uid52_fpDivTest_b_8_mem_reset0;
    wire redist20_yPE_uid52_fpDivTest_b_8_mem_ena_OrRstB;
    wire [13:0] redist20_yPE_uid52_fpDivTest_b_8_mem_ia;
    wire [2:0] redist20_yPE_uid52_fpDivTest_b_8_mem_aa;
    wire [2:0] redist20_yPE_uid52_fpDivTest_b_8_mem_ab;
    wire [13:0] redist20_yPE_uid52_fpDivTest_b_8_mem_iq;
    wire [13:0] redist20_yPE_uid52_fpDivTest_b_8_mem_q;
    wire [2:0] redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i;
    (* preserve_syn_only *) reg redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq;
    wire [0:0] redist20_yPE_uid52_fpDivTest_b_8_rdmux_s;
    reg [2:0] redist20_yPE_uid52_fpDivTest_b_8_rdmux_q;
    reg [2:0] redist20_yPE_uid52_fpDivTest_b_8_wraddr_q;
    wire redist22_yAddr_uid51_fpDivTest_b_11_mem_reset0;
    wire redist22_yAddr_uid51_fpDivTest_b_11_mem_ena_OrRstB;
    wire [8:0] redist22_yAddr_uid51_fpDivTest_b_11_mem_ia;
    wire [2:0] redist22_yAddr_uid51_fpDivTest_b_11_mem_aa;
    wire [2:0] redist22_yAddr_uid51_fpDivTest_b_11_mem_ab;
    wire [8:0] redist22_yAddr_uid51_fpDivTest_b_11_mem_iq;
    wire [8:0] redist22_yAddr_uid51_fpDivTest_b_11_mem_q;
    wire [2:0] redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i;
    (* preserve_syn_only *) reg redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq;
    wire [0:0] redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s;
    reg [2:0] redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q;
    reg [2:0] redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q;
    wire redist26_expY_uid12_fpDivTest_b_18_mem_reset0;
    wire redist26_expY_uid12_fpDivTest_b_18_mem_ena_OrRstB;
    wire [7:0] redist26_expY_uid12_fpDivTest_b_18_mem_ia;
    wire [4:0] redist26_expY_uid12_fpDivTest_b_18_mem_aa;
    wire [4:0] redist26_expY_uid12_fpDivTest_b_18_mem_ab;
    wire [7:0] redist26_expY_uid12_fpDivTest_b_18_mem_iq;
    wire [7:0] redist26_expY_uid12_fpDivTest_b_18_mem_q;
    wire [4:0] redist26_expY_uid12_fpDivTest_b_18_rdcnt_q;
    (* preserve_syn_only *) reg [4:0] redist26_expY_uid12_fpDivTest_b_18_rdcnt_i;
    (* preserve_syn_only *) reg redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq;
    wire [0:0] redist26_expY_uid12_fpDivTest_b_18_rdmux_s;
    reg [4:0] redist26_expY_uid12_fpDivTest_b_18_rdmux_q;
    reg [4:0] redist26_expY_uid12_fpDivTest_b_18_wraddr_q;
    wire redist29_fracX_uid10_fpDivTest_b_6_mem_reset0;
    wire redist29_fracX_uid10_fpDivTest_b_6_mem_ena_OrRstB;
    wire [22:0] redist29_fracX_uid10_fpDivTest_b_6_mem_ia;
    wire [2:0] redist29_fracX_uid10_fpDivTest_b_6_mem_aa;
    wire [2:0] redist29_fracX_uid10_fpDivTest_b_6_mem_ab;
    wire [22:0] redist29_fracX_uid10_fpDivTest_b_6_mem_iq;
    wire [22:0] redist29_fracX_uid10_fpDivTest_b_6_mem_q;
    wire [2:0] redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q;
    (* preserve_syn_only *) reg [2:0] redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i;
    (* preserve_syn_only *) reg redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq;
    wire [0:0] redist29_fracX_uid10_fpDivTest_b_6_rdmux_s;
    reg [2:0] redist29_fracX_uid10_fpDivTest_b_6_rdmux_q;
    reg [2:0] redist29_fracX_uid10_fpDivTest_b_6_wraddr_q;
    wire redist32_xIn_a_14_mem_reset0;
    wire redist32_xIn_a_14_mem_ena_OrRstB;
    wire [31:0] redist32_xIn_a_14_mem_ia;
    wire [3:0] redist32_xIn_a_14_mem_aa;
    wire [3:0] redist32_xIn_a_14_mem_ab;
    wire [31:0] redist32_xIn_a_14_mem_iq;
    wire [31:0] redist32_xIn_a_14_mem_q;
    wire [3:0] redist32_xIn_a_14_rdcnt_q;
    (* preserve_syn_only *) reg [3:0] redist32_xIn_a_14_rdcnt_i;
    (* preserve_syn_only *) reg redist32_xIn_a_14_rdcnt_eq;
    wire [0:0] redist32_xIn_a_14_rdmux_s;
    reg [3:0] redist32_xIn_a_14_rdmux_q;
    reg [3:0] redist32_xIn_a_14_wraddr_q;


    // fracY_uid13_fpDivTest(BITSELECT,12)@0
    assign fracY_uid13_fpDivTest_b = $signed(b[22:0]);

    // cstZeroWF_uid19_fpDivTest(CONSTANT,18)
    assign cstZeroWF_uid19_fpDivTest_q = 23'b00000000000000000000000;

    // fracXIsZero_uid39_fpDivTest(LOGICAL,38)@0 + 1
    assign fracXIsZero_uid39_fpDivTest_qi = $unsigned(cstZeroWF_uid19_fpDivTest_q == fracY_uid13_fpDivTest_b ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    fracXIsZero_uid39_fpDivTest_delay ( .xin(fracXIsZero_uid39_fpDivTest_qi), .xout(fracXIsZero_uid39_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist24_fracXIsZero_uid39_fpDivTest_q_21(DELAY,219)
    dspba_delay_ver #( .width(1), .depth(20), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist24_fracXIsZero_uid39_fpDivTest_q_21 ( .xin(fracXIsZero_uid39_fpDivTest_q), .xout(redist24_fracXIsZero_uid39_fpDivTest_q_21_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // cstAllOWE_uid18_fpDivTest(CONSTANT,17)
    assign cstAllOWE_uid18_fpDivTest_q = 8'b11111111;

    // redist26_expY_uid12_fpDivTest_b_18_rdcnt(COUNTER,258)
    // low=0, high=16, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist26_expY_uid12_fpDivTest_b_18_rdcnt_i <= 5'd0;
            redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist26_expY_uid12_fpDivTest_b_18_rdcnt_i == 5'd15)
            begin
                redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq <= 1'b0;
            end
            if (redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq == 1'b1)
            begin
                redist26_expY_uid12_fpDivTest_b_18_rdcnt_i <= $unsigned(redist26_expY_uid12_fpDivTest_b_18_rdcnt_i) + $unsigned(5'd16);
            end
            else
            begin
                redist26_expY_uid12_fpDivTest_b_18_rdcnt_i <= $unsigned(redist26_expY_uid12_fpDivTest_b_18_rdcnt_i) + $unsigned(5'd1);
            end
        end
    end
    assign redist26_expY_uid12_fpDivTest_b_18_rdcnt_q = $signed(redist26_expY_uid12_fpDivTest_b_18_rdcnt_i[4:0]);

    // redist26_expY_uid12_fpDivTest_b_18_rdmux(MUX,259)
    assign redist26_expY_uid12_fpDivTest_b_18_rdmux_s = en;
    always_comb 
    begin
        unique case (redist26_expY_uid12_fpDivTest_b_18_rdmux_s)
            1'b0 : redist26_expY_uid12_fpDivTest_b_18_rdmux_q = redist26_expY_uid12_fpDivTest_b_18_wraddr_q;
            1'b1 : redist26_expY_uid12_fpDivTest_b_18_rdmux_q = redist26_expY_uid12_fpDivTest_b_18_rdcnt_q;
            default : redist26_expY_uid12_fpDivTest_b_18_rdmux_q = 5'b0;
        endcase
    end

    // VCC(CONSTANT,1)
    assign VCC_q = 1'b1;

    // expY_uid12_fpDivTest(BITSELECT,11)@0
    assign expY_uid12_fpDivTest_b = $signed(b[30:23]);

    // redist26_expY_uid12_fpDivTest_b_18_wraddr(REG,260)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist26_expY_uid12_fpDivTest_b_18_wraddr_q <= 5'b10000;
        end
        else
        begin
            redist26_expY_uid12_fpDivTest_b_18_wraddr_q <= redist26_expY_uid12_fpDivTest_b_18_rdmux_q;
        end
    end

    // redist26_expY_uid12_fpDivTest_b_18_mem(DUALMEM,257)
    assign redist26_expY_uid12_fpDivTest_b_18_mem_ia = $unsigned(expY_uid12_fpDivTest_b);
    assign redist26_expY_uid12_fpDivTest_b_18_mem_aa = redist26_expY_uid12_fpDivTest_b_18_wraddr_q;
    assign redist26_expY_uid12_fpDivTest_b_18_mem_ab = redist26_expY_uid12_fpDivTest_b_18_rdmux_q;
    assign redist26_expY_uid12_fpDivTest_b_18_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(8),
        .widthad_a(5),
        .numwords_a(17),
        .width_b(8),
        .widthad_b(5),
        .numwords_b(17),
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
    ) redist26_expY_uid12_fpDivTest_b_18_mem_dmem (
        .clocken1(redist26_expY_uid12_fpDivTest_b_18_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist26_expY_uid12_fpDivTest_b_18_mem_aa),
        .data_a(redist26_expY_uid12_fpDivTest_b_18_mem_ia),
        .wren_a(en[0]),
        .address_b(redist26_expY_uid12_fpDivTest_b_18_mem_ab),
        .q_b(redist26_expY_uid12_fpDivTest_b_18_mem_iq),
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
    assign redist26_expY_uid12_fpDivTest_b_18_mem_q = $signed(redist26_expY_uid12_fpDivTest_b_18_mem_iq[7:0]);

    // redist27_expY_uid12_fpDivTest_b_20(DELAY,222)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist27_expY_uid12_fpDivTest_b_20_delay_0 <= $unsigned(redist26_expY_uid12_fpDivTest_b_18_mem_q);
            redist27_expY_uid12_fpDivTest_b_20_q <= $signed(redist27_expY_uid12_fpDivTest_b_20_delay_0);
        end
    end

    // expXIsMax_uid38_fpDivTest(LOGICAL,37)@20 + 1
    assign expXIsMax_uid38_fpDivTest_qi = $unsigned(redist27_expY_uid12_fpDivTest_b_20_q == cstAllOWE_uid18_fpDivTest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    expXIsMax_uid38_fpDivTest_delay ( .xin(expXIsMax_uid38_fpDivTest_qi), .xout(expXIsMax_uid38_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // excI_y_uid41_fpDivTest(LOGICAL,40)@21
    assign excI_y_uid41_fpDivTest_q = $signed(expXIsMax_uid38_fpDivTest_q & redist24_fracXIsZero_uid39_fpDivTest_q_21_q);

    // redist29_fracX_uid10_fpDivTest_b_6_rdcnt(COUNTER,262)
    // low=0, high=4, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i <= 3'd0;
            redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i == 3'd3)
            begin
                redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= 1'b0;
            end
            if (redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq == 1'b1)
            begin
                redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i <= $unsigned(redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i) + $unsigned(3'd4);
            end
            else
            begin
                redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i <= $unsigned(redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q = $signed(redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i[2:0]);

    // redist29_fracX_uid10_fpDivTest_b_6_rdmux(MUX,263)
    assign redist29_fracX_uid10_fpDivTest_b_6_rdmux_s = en;
    always_comb 
    begin
        unique case (redist29_fracX_uid10_fpDivTest_b_6_rdmux_s)
            1'b0 : redist29_fracX_uid10_fpDivTest_b_6_rdmux_q = redist29_fracX_uid10_fpDivTest_b_6_wraddr_q;
            1'b1 : redist29_fracX_uid10_fpDivTest_b_6_rdmux_q = redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q;
            default : redist29_fracX_uid10_fpDivTest_b_6_rdmux_q = 3'b0;
        endcase
    end

    // redist32_xIn_a_14_rdcnt(COUNTER,266)
    // low=0, high=12, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist32_xIn_a_14_rdcnt_i <= 4'd0;
            redist32_xIn_a_14_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist32_xIn_a_14_rdcnt_i == 4'd11)
            begin
                redist32_xIn_a_14_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist32_xIn_a_14_rdcnt_eq <= 1'b0;
            end
            if (redist32_xIn_a_14_rdcnt_eq == 1'b1)
            begin
                redist32_xIn_a_14_rdcnt_i <= $unsigned(redist32_xIn_a_14_rdcnt_i) + $unsigned(4'd4);
            end
            else
            begin
                redist32_xIn_a_14_rdcnt_i <= $unsigned(redist32_xIn_a_14_rdcnt_i) + $unsigned(4'd1);
            end
        end
    end
    assign redist32_xIn_a_14_rdcnt_q = $signed(redist32_xIn_a_14_rdcnt_i[3:0]);

    // redist32_xIn_a_14_rdmux(MUX,267)
    assign redist32_xIn_a_14_rdmux_s = en;
    always_comb 
    begin
        unique case (redist32_xIn_a_14_rdmux_s)
            1'b0 : redist32_xIn_a_14_rdmux_q = redist32_xIn_a_14_wraddr_q;
            1'b1 : redist32_xIn_a_14_rdmux_q = redist32_xIn_a_14_rdcnt_q;
            default : redist32_xIn_a_14_rdmux_q = 4'b0;
        endcase
    end

    // redist32_xIn_a_14_wraddr(REG,268)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist32_xIn_a_14_wraddr_q <= 4'b1100;
        end
        else
        begin
            redist32_xIn_a_14_wraddr_q <= redist32_xIn_a_14_rdmux_q;
        end
    end

    // redist32_xIn_a_14_mem(DUALMEM,265)
    assign redist32_xIn_a_14_mem_ia = $unsigned(a);
    assign redist32_xIn_a_14_mem_aa = redist32_xIn_a_14_wraddr_q;
    assign redist32_xIn_a_14_mem_ab = redist32_xIn_a_14_rdmux_q;
    assign redist32_xIn_a_14_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(32),
        .widthad_a(4),
        .numwords_a(13),
        .width_b(32),
        .widthad_b(4),
        .numwords_b(13),
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
    ) redist32_xIn_a_14_mem_dmem (
        .clocken1(redist32_xIn_a_14_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist32_xIn_a_14_mem_aa),
        .data_a(redist32_xIn_a_14_mem_ia),
        .wren_a(en[0]),
        .address_b(redist32_xIn_a_14_mem_ab),
        .q_b(redist32_xIn_a_14_mem_iq),
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
    assign redist32_xIn_a_14_mem_q = $signed(redist32_xIn_a_14_mem_iq[31:0]);

    // fracX_uid10_fpDivTest(BITSELECT,9)@14
    assign fracX_uid10_fpDivTest_b = $signed(redist32_xIn_a_14_mem_q[22:0]);

    // redist29_fracX_uid10_fpDivTest_b_6_wraddr(REG,264)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist29_fracX_uid10_fpDivTest_b_6_wraddr_q <= 3'b100;
        end
        else
        begin
            redist29_fracX_uid10_fpDivTest_b_6_wraddr_q <= redist29_fracX_uid10_fpDivTest_b_6_rdmux_q;
        end
    end

    // redist29_fracX_uid10_fpDivTest_b_6_mem(DUALMEM,261)
    assign redist29_fracX_uid10_fpDivTest_b_6_mem_ia = $unsigned(fracX_uid10_fpDivTest_b);
    assign redist29_fracX_uid10_fpDivTest_b_6_mem_aa = redist29_fracX_uid10_fpDivTest_b_6_wraddr_q;
    assign redist29_fracX_uid10_fpDivTest_b_6_mem_ab = redist29_fracX_uid10_fpDivTest_b_6_rdmux_q;
    assign redist29_fracX_uid10_fpDivTest_b_6_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(23),
        .widthad_a(3),
        .numwords_a(5),
        .width_b(23),
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
    ) redist29_fracX_uid10_fpDivTest_b_6_mem_dmem (
        .clocken1(redist29_fracX_uid10_fpDivTest_b_6_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist29_fracX_uid10_fpDivTest_b_6_mem_aa),
        .data_a(redist29_fracX_uid10_fpDivTest_b_6_mem_ia),
        .wren_a(en[0]),
        .address_b(redist29_fracX_uid10_fpDivTest_b_6_mem_ab),
        .q_b(redist29_fracX_uid10_fpDivTest_b_6_mem_iq),
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
    assign redist29_fracX_uid10_fpDivTest_b_6_mem_q = $signed(redist29_fracX_uid10_fpDivTest_b_6_mem_iq[22:0]);

    // fracXIsZero_uid25_fpDivTest(LOGICAL,24)@20 + 1
    assign fracXIsZero_uid25_fpDivTest_qi = $unsigned(cstZeroWF_uid19_fpDivTest_q == redist29_fracX_uid10_fpDivTest_b_6_mem_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    fracXIsZero_uid25_fpDivTest_delay ( .xin(fracXIsZero_uid25_fpDivTest_qi), .xout(fracXIsZero_uid25_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // expX_uid9_fpDivTest(BITSELECT,8)@14
    assign expX_uid9_fpDivTest_b = $signed(redist32_xIn_a_14_mem_q[30:23]);

    // redist30_expX_uid9_fpDivTest_b_4(DELAY,225)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist30_expX_uid9_fpDivTest_b_4_delay_0 <= $unsigned(expX_uid9_fpDivTest_b);
            redist30_expX_uid9_fpDivTest_b_4_delay_1 <= redist30_expX_uid9_fpDivTest_b_4_delay_0;
            redist30_expX_uid9_fpDivTest_b_4_delay_2 <= redist30_expX_uid9_fpDivTest_b_4_delay_1;
            redist30_expX_uid9_fpDivTest_b_4_q <= $signed(redist30_expX_uid9_fpDivTest_b_4_delay_2);
        end
    end

    // redist31_expX_uid9_fpDivTest_b_6(DELAY,226)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist31_expX_uid9_fpDivTest_b_6_delay_0 <= $unsigned(redist30_expX_uid9_fpDivTest_b_4_q);
            redist31_expX_uid9_fpDivTest_b_6_q <= $signed(redist31_expX_uid9_fpDivTest_b_6_delay_0);
        end
    end

    // expXIsMax_uid24_fpDivTest(LOGICAL,23)@20 + 1
    assign expXIsMax_uid24_fpDivTest_qi = $unsigned(redist31_expX_uid9_fpDivTest_b_6_q == cstAllOWE_uid18_fpDivTest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    expXIsMax_uid24_fpDivTest_delay ( .xin(expXIsMax_uid24_fpDivTest_qi), .xout(expXIsMax_uid24_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // excI_x_uid27_fpDivTest(LOGICAL,26)@21
    assign excI_x_uid27_fpDivTest_q = $signed(expXIsMax_uid24_fpDivTest_q & fracXIsZero_uid25_fpDivTest_q);

    // excXIYI_uid130_fpDivTest(LOGICAL,129)@21
    assign excXIYI_uid130_fpDivTest_q = $signed(excI_x_uid27_fpDivTest_q & excI_y_uid41_fpDivTest_q);

    // fracXIsNotZero_uid40_fpDivTest(LOGICAL,39)@21
    assign fracXIsNotZero_uid40_fpDivTest_q = $signed(~ (redist24_fracXIsZero_uid39_fpDivTest_q_21_q));

    // excN_y_uid42_fpDivTest(LOGICAL,41)@21
    assign excN_y_uid42_fpDivTest_q = $signed(expXIsMax_uid38_fpDivTest_q & fracXIsNotZero_uid40_fpDivTest_q);

    // fracXIsNotZero_uid26_fpDivTest(LOGICAL,25)@21
    assign fracXIsNotZero_uid26_fpDivTest_q = $signed(~ (fracXIsZero_uid25_fpDivTest_q));

    // excN_x_uid28_fpDivTest(LOGICAL,27)@21
    assign excN_x_uid28_fpDivTest_q = $signed(expXIsMax_uid24_fpDivTest_q & fracXIsNotZero_uid26_fpDivTest_q);

    // cstAllZWE_uid20_fpDivTest(CONSTANT,19)
    assign cstAllZWE_uid20_fpDivTest_q = 8'b00000000;

    // redist28_expY_uid12_fpDivTest_b_21(DELAY,223)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist28_expY_uid12_fpDivTest_b_21_q <= redist27_expY_uid12_fpDivTest_b_20_q;
        end
    end

    // excZ_y_uid37_fpDivTest(LOGICAL,36)@21
    assign excZ_y_uid37_fpDivTest_q = redist28_expY_uid12_fpDivTest_b_21_q == cstAllZWE_uid20_fpDivTest_q ? 1'b1 : 1'b0;

    // excZ_x_uid23_fpDivTest(LOGICAL,22)@20 + 1
    assign excZ_x_uid23_fpDivTest_qi = $unsigned(redist31_expX_uid9_fpDivTest_b_6_q == cstAllZWE_uid20_fpDivTest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    excZ_x_uid23_fpDivTest_delay ( .xin(excZ_x_uid23_fpDivTest_qi), .xout(excZ_x_uid23_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // excXZYZ_uid129_fpDivTest(LOGICAL,128)@21
    assign excXZYZ_uid129_fpDivTest_q = $signed(excZ_x_uid23_fpDivTest_q & excZ_y_uid37_fpDivTest_q);

    // excRNaN_uid131_fpDivTest(LOGICAL,130)@21 + 1
    assign excRNaN_uid131_fpDivTest_qi = excXZYZ_uid129_fpDivTest_q | excN_x_uid28_fpDivTest_q | excN_y_uid42_fpDivTest_q | excXIYI_uid130_fpDivTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    excRNaN_uid131_fpDivTest_delay ( .xin(excRNaN_uid131_fpDivTest_qi), .xout(excRNaN_uid131_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // invExcRNaN_uid142_fpDivTest(LOGICAL,141)@22
    assign invExcRNaN_uid142_fpDivTest_q = $signed(~ (excRNaN_uid131_fpDivTest_q));

    // signY_uid14_fpDivTest(BITSELECT,13)@0
    assign signY_uid14_fpDivTest_b = b[31:31];

    // signX_uid11_fpDivTest(BITSELECT,10)@0
    assign signX_uid11_fpDivTest_b = a[31:31];

    // signR_uid46_fpDivTest(LOGICAL,45)@0 + 1
    assign signR_uid46_fpDivTest_qi = signX_uid11_fpDivTest_b ^ signY_uid14_fpDivTest_b;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    signR_uid46_fpDivTest_delay ( .xin(signR_uid46_fpDivTest_qi), .xout(signR_uid46_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist23_signR_uid46_fpDivTest_q_22(DELAY,218)
    dspba_delay_ver #( .width(1), .depth(21), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist23_signR_uid46_fpDivTest_q_22 ( .xin(signR_uid46_fpDivTest_q), .xout(redist23_signR_uid46_fpDivTest_q_22_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // sRPostExc_uid143_fpDivTest(LOGICAL,142)@22 + 1
    assign sRPostExc_uid143_fpDivTest_qi = redist23_signR_uid46_fpDivTest_q_22_q & invExcRNaN_uid142_fpDivTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    sRPostExc_uid143_fpDivTest_delay ( .xin(sRPostExc_uid143_fpDivTest_qi), .xout(sRPostExc_uid143_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist1_sRPostExc_uid143_fpDivTest_q_8(DELAY,196)
    dspba_delay_ver #( .width(1), .depth(7), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist1_sRPostExc_uid143_fpDivTest_q_8 ( .xin(sRPostExc_uid143_fpDivTest_q), .xout(redist1_sRPostExc_uid143_fpDivTest_q_8_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // GND(CONSTANT,0)
    assign GND_q = 1'b0;

    // fracXExt_uid77_fpDivTest(BITJOIN,76)@20
    assign fracXExt_uid77_fpDivTest_q = {redist29_fracX_uid10_fpDivTest_b_6_mem_q, GND_q};

    // lOAdded_uid57_fpDivTest(BITJOIN,56)@14
    assign lOAdded_uid57_fpDivTest_q = {VCC_q, fracX_uid10_fpDivTest_b};

    // redist16_lOAdded_uid57_fpDivTest_q_5(DELAY,211)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist16_lOAdded_uid57_fpDivTest_q_5_delay_0 <= $unsigned(lOAdded_uid57_fpDivTest_q);
            redist16_lOAdded_uid57_fpDivTest_q_5_delay_1 <= redist16_lOAdded_uid57_fpDivTest_q_5_delay_0;
            redist16_lOAdded_uid57_fpDivTest_q_5_delay_2 <= redist16_lOAdded_uid57_fpDivTest_q_5_delay_1;
            redist16_lOAdded_uid57_fpDivTest_q_5_q <= $signed(redist16_lOAdded_uid57_fpDivTest_q_5_delay_2);
        end
    end

    // redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0(DELAY,248)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_q <= redist16_lOAdded_uid57_fpDivTest_q_5_q;
        end
    end

    // z4_uid60_fpDivTest(CONSTANT,59)
    assign z4_uid60_fpDivTest_q = 4'b0000;

    // oFracXZ4_uid61_fpDivTest(BITJOIN,60)@19
    assign oFracXZ4_uid61_fpDivTest_q = {redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_q, z4_uid60_fpDivTest_q};

    // yAddr_uid51_fpDivTest(BITSELECT,50)@0
    assign yAddr_uid51_fpDivTest_b = $signed(fracY_uid13_fpDivTest_b[22:14]);

    // memoryC2_uid152_invTables_lutmem(DUALMEM,188)@0 + 2
    assign memoryC2_uid152_invTables_lutmem_aa = yAddr_uid51_fpDivTest_b;
    assign memoryC2_uid152_invTables_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign memoryC2_uid152_invTables_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(13),
        .widthad_a(9),
        .numwords_a(512),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Div_altera_fp_functions_19110_etcsazy_memoryC2_uid152_invTables_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) memoryC2_uid152_invTables_lutmem_dmem (
        .clocken0(memoryC2_uid152_invTables_lutmem_ena_NotRstA),
        .sclr(memoryC2_uid152_invTables_lutmem_reset0),
        .clock0(clk),
        .address_a(memoryC2_uid152_invTables_lutmem_aa),
        .q_a(memoryC2_uid152_invTables_lutmem_ir),
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
    assign memoryC2_uid152_invTables_lutmem_r = $signed(memoryC2_uid152_invTables_lutmem_ir[12:0]);

    // yPE_uid52_fpDivTest(BITSELECT,51)@0
    assign yPE_uid52_fpDivTest_b = $signed(b[13:0]);

    // redist19_yPE_uid52_fpDivTest_b_2(DELAY,214)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist19_yPE_uid52_fpDivTest_b_2_delay_0 <= $unsigned(yPE_uid52_fpDivTest_b);
            redist19_yPE_uid52_fpDivTest_b_2_q <= $signed(redist19_yPE_uid52_fpDivTest_b_2_delay_0);
        end
    end

    // yT1_uid158_invPolyEval(BITSELECT,157)@2
    assign yT1_uid158_invPolyEval_b = $signed(redist19_yPE_uid52_fpDivTest_b_2_q[13:1]);

    // prodXY_uid174_pT1_uid159_invPolyEval_cma(CHAINMULTADD,192)@2 + 5
    // in b@5
    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_reset = areset;
    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0 = en[0] | prodXY_uid174_pT1_uid159_invPolyEval_cma_reset;
    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_ena1 = prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0;
    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_ena2 = prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0;

    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_a0 = yT1_uid158_invPolyEval_b;
    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_c0 = $unsigned(memoryC2_uid152_invTables_lutmem_r);
    tennm_mac #(
        .operation_mode("m18x18_full"),
        .clear_type("sclr"),
        .ay_scan_in_clken("0"),
        .ay_scan_in_width(13),
        .ax_clken("0"),
        .ax_width(13),
        .signed_may("false"),
        .signed_max("true"),
        .input_pipeline_clken("2"),
        .second_pipeline_clken("2"),
        .output_clken("1"),
        .result_a_width(26)
    ) prodXY_uid174_pT1_uid159_invPolyEval_cma_DSP0 (
        .clk(clk),
        .ena({ prodXY_uid174_pT1_uid159_invPolyEval_cma_ena2, prodXY_uid174_pT1_uid159_invPolyEval_cma_ena1, prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0 }),
        .clr({ prodXY_uid174_pT1_uid159_invPolyEval_cma_reset, prodXY_uid174_pT1_uid159_invPolyEval_cma_reset }),
        .ay(prodXY_uid174_pT1_uid159_invPolyEval_cma_a0),
        .ax(prodXY_uid174_pT1_uid159_invPolyEval_cma_c0),
        .resulta(prodXY_uid174_pT1_uid159_invPolyEval_cma_s0),
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
    dspba_delay_ver #( .width(26), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    prodXY_uid174_pT1_uid159_invPolyEval_cma_delay0 ( .xin(prodXY_uid174_pT1_uid159_invPolyEval_cma_s0), .xout(prodXY_uid174_pT1_uid159_invPolyEval_cma_qq0), .ena(en[0]), .clk(clk), .aclr(areset) );
    assign prodXY_uid174_pT1_uid159_invPolyEval_cma_q = $unsigned(prodXY_uid174_pT1_uid159_invPolyEval_cma_qq0[25:0]);

    // osig_uid175_pT1_uid159_invPolyEval(BITSELECT,174)@7
    assign osig_uid175_pT1_uid159_invPolyEval_b = prodXY_uid174_pT1_uid159_invPolyEval_cma_q[25:12];

    // highBBits_uid161_invPolyEval(BITSELECT,160)@7
    assign highBBits_uid161_invPolyEval_b = osig_uid175_pT1_uid159_invPolyEval_b[13:1];

    // redist21_yAddr_uid51_fpDivTest_b_5(DELAY,216)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist21_yAddr_uid51_fpDivTest_b_5_delay_0 <= $unsigned(yAddr_uid51_fpDivTest_b);
            redist21_yAddr_uid51_fpDivTest_b_5_delay_1 <= redist21_yAddr_uid51_fpDivTest_b_5_delay_0;
            redist21_yAddr_uid51_fpDivTest_b_5_delay_2 <= redist21_yAddr_uid51_fpDivTest_b_5_delay_1;
            redist21_yAddr_uid51_fpDivTest_b_5_delay_3 <= redist21_yAddr_uid51_fpDivTest_b_5_delay_2;
            redist21_yAddr_uid51_fpDivTest_b_5_q <= $signed(redist21_yAddr_uid51_fpDivTest_b_5_delay_3);
        end
    end

    // memoryC1_uid149_invTables_lutmem(DUALMEM,187)@5 + 2
    assign memoryC1_uid149_invTables_lutmem_aa = redist21_yAddr_uid51_fpDivTest_b_5_q;
    assign memoryC1_uid149_invTables_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign memoryC1_uid149_invTables_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(22),
        .widthad_a(9),
        .numwords_a(512),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Div_altera_fp_functions_19110_etcsazy_memoryC1_uid149_invTables_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) memoryC1_uid149_invTables_lutmem_dmem (
        .clocken0(memoryC1_uid149_invTables_lutmem_ena_NotRstA),
        .sclr(memoryC1_uid149_invTables_lutmem_reset0),
        .clock0(clk),
        .address_a(memoryC1_uid149_invTables_lutmem_aa),
        .q_a(memoryC1_uid149_invTables_lutmem_ir),
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
    assign memoryC1_uid149_invTables_lutmem_r = $signed(memoryC1_uid149_invTables_lutmem_ir[21:0]);

    // s1sumAHighB_uid162_invPolyEval(ADD,161)@7
    assign s1sumAHighB_uid162_invPolyEval_a = $unsigned({{1{memoryC1_uid149_invTables_lutmem_r[21]}}, memoryC1_uid149_invTables_lutmem_r});
    assign s1sumAHighB_uid162_invPolyEval_b = $unsigned({{10{highBBits_uid161_invPolyEval_b[12]}}, highBBits_uid161_invPolyEval_b});
    assign s1sumAHighB_uid162_invPolyEval_o = $unsigned($signed(s1sumAHighB_uid162_invPolyEval_a) + $signed(s1sumAHighB_uid162_invPolyEval_b));
    assign s1sumAHighB_uid162_invPolyEval_q = $signed(s1sumAHighB_uid162_invPolyEval_o[22:0]);

    // lowRangeB_uid160_invPolyEval(BITSELECT,159)@7
    assign lowRangeB_uid160_invPolyEval_in = osig_uid175_pT1_uid159_invPolyEval_b[0:0];
    assign lowRangeB_uid160_invPolyEval_b = $signed(lowRangeB_uid160_invPolyEval_in[0:0]);

    // s1_uid163_invPolyEval(BITJOIN,162)@7
    assign s1_uid163_invPolyEval_q = {s1sumAHighB_uid162_invPolyEval_q, lowRangeB_uid160_invPolyEval_b};

    // redist0_s1_uid163_invPolyEval_q_1(DELAY,195)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist0_s1_uid163_invPolyEval_q_1_q <= s1_uid163_invPolyEval_q;
        end
    end

    // redist20_yPE_uid52_fpDivTest_b_8_rdcnt(COUNTER,250)
    // low=0, high=4, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i <= 3'd0;
            redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i == 3'd3)
            begin
                redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq <= 1'b0;
            end
            if (redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq == 1'b1)
            begin
                redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i <= $unsigned(redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i) + $unsigned(3'd4);
            end
            else
            begin
                redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i <= $unsigned(redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q = $signed(redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i[2:0]);

    // redist20_yPE_uid52_fpDivTest_b_8_rdmux(MUX,251)
    assign redist20_yPE_uid52_fpDivTest_b_8_rdmux_s = en;
    always_comb 
    begin
        unique case (redist20_yPE_uid52_fpDivTest_b_8_rdmux_s)
            1'b0 : redist20_yPE_uid52_fpDivTest_b_8_rdmux_q = redist20_yPE_uid52_fpDivTest_b_8_wraddr_q;
            1'b1 : redist20_yPE_uid52_fpDivTest_b_8_rdmux_q = redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q;
            default : redist20_yPE_uid52_fpDivTest_b_8_rdmux_q = 3'b0;
        endcase
    end

    // redist20_yPE_uid52_fpDivTest_b_8_wraddr(REG,252)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist20_yPE_uid52_fpDivTest_b_8_wraddr_q <= 3'b100;
        end
        else
        begin
            redist20_yPE_uid52_fpDivTest_b_8_wraddr_q <= redist20_yPE_uid52_fpDivTest_b_8_rdmux_q;
        end
    end

    // redist20_yPE_uid52_fpDivTest_b_8_mem(DUALMEM,249)
    assign redist20_yPE_uid52_fpDivTest_b_8_mem_ia = $unsigned(redist19_yPE_uid52_fpDivTest_b_2_q);
    assign redist20_yPE_uid52_fpDivTest_b_8_mem_aa = redist20_yPE_uid52_fpDivTest_b_8_wraddr_q;
    assign redist20_yPE_uid52_fpDivTest_b_8_mem_ab = redist20_yPE_uid52_fpDivTest_b_8_rdmux_q;
    assign redist20_yPE_uid52_fpDivTest_b_8_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(14),
        .widthad_a(3),
        .numwords_a(5),
        .width_b(14),
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
    ) redist20_yPE_uid52_fpDivTest_b_8_mem_dmem (
        .clocken1(redist20_yPE_uid52_fpDivTest_b_8_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist20_yPE_uid52_fpDivTest_b_8_mem_aa),
        .data_a(redist20_yPE_uid52_fpDivTest_b_8_mem_ia),
        .wren_a(en[0]),
        .address_b(redist20_yPE_uid52_fpDivTest_b_8_mem_ab),
        .q_b(redist20_yPE_uid52_fpDivTest_b_8_mem_iq),
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
    assign redist20_yPE_uid52_fpDivTest_b_8_mem_q = $signed(redist20_yPE_uid52_fpDivTest_b_8_mem_iq[13:0]);

    // prodXY_uid177_pT2_uid165_invPolyEval_cma(CHAINMULTADD,193)@8 + 5
    // in b@11
    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_reset = areset;
    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0 = en[0] | prodXY_uid177_pT2_uid165_invPolyEval_cma_reset;
    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_ena1 = prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0;
    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_ena2 = prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0;

    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_a0 = redist20_yPE_uid52_fpDivTest_b_8_mem_q;
    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_c0 = $unsigned(redist0_s1_uid163_invPolyEval_q_1_q);
    tennm_mac #(
        .operation_mode("m27x27"),
        .clear_type("sclr"),
        .use_chainadder("false"),
        .ay_scan_in_clken("0"),
        .ay_scan_in_width(14),
        .ax_clken("0"),
        .ax_width(24),
        .signed_may("false"),
        .signed_max("true"),
        .input_pipeline_clken("2"),
        .second_pipeline_clken("2"),
        .output_clken("1"),
        .result_a_width(38)
    ) prodXY_uid177_pT2_uid165_invPolyEval_cma_DSP0 (
        .clk(clk),
        .ena({ prodXY_uid177_pT2_uid165_invPolyEval_cma_ena2, prodXY_uid177_pT2_uid165_invPolyEval_cma_ena1, prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0 }),
        .clr({ prodXY_uid177_pT2_uid165_invPolyEval_cma_reset, prodXY_uid177_pT2_uid165_invPolyEval_cma_reset }),
        .ay(prodXY_uid177_pT2_uid165_invPolyEval_cma_a0),
        .ax(prodXY_uid177_pT2_uid165_invPolyEval_cma_c0),
        .resulta(prodXY_uid177_pT2_uid165_invPolyEval_cma_s0),
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
    prodXY_uid177_pT2_uid165_invPolyEval_cma_delay0 ( .xin(prodXY_uid177_pT2_uid165_invPolyEval_cma_s0), .xout(prodXY_uid177_pT2_uid165_invPolyEval_cma_qq0), .ena(en[0]), .clk(clk), .aclr(areset) );
    assign prodXY_uid177_pT2_uid165_invPolyEval_cma_q = $unsigned(prodXY_uid177_pT2_uid165_invPolyEval_cma_qq0[37:0]);

    // osig_uid178_pT2_uid165_invPolyEval(BITSELECT,177)@13
    assign osig_uid178_pT2_uid165_invPolyEval_b = prodXY_uid177_pT2_uid165_invPolyEval_cma_q[37:13];

    // highBBits_uid167_invPolyEval(BITSELECT,166)@13
    assign highBBits_uid167_invPolyEval_b = osig_uid178_pT2_uid165_invPolyEval_b[24:2];

    // redist22_yAddr_uid51_fpDivTest_b_11_rdcnt(COUNTER,254)
    // low=0, high=4, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i <= 3'd0;
            redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i == 3'd3)
            begin
                redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq <= 1'b0;
            end
            if (redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq == 1'b1)
            begin
                redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i <= $unsigned(redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i) + $unsigned(3'd4);
            end
            else
            begin
                redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i <= $unsigned(redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q = $signed(redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i[2:0]);

    // redist22_yAddr_uid51_fpDivTest_b_11_rdmux(MUX,255)
    assign redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s = en;
    always_comb 
    begin
        unique case (redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s)
            1'b0 : redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q = redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q;
            1'b1 : redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q = redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q;
            default : redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q = 3'b0;
        endcase
    end

    // redist22_yAddr_uid51_fpDivTest_b_11_wraddr(REG,256)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q <= 3'b100;
        end
        else
        begin
            redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q <= redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q;
        end
    end

    // redist22_yAddr_uid51_fpDivTest_b_11_mem(DUALMEM,253)
    assign redist22_yAddr_uid51_fpDivTest_b_11_mem_ia = $unsigned(redist21_yAddr_uid51_fpDivTest_b_5_q);
    assign redist22_yAddr_uid51_fpDivTest_b_11_mem_aa = redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q;
    assign redist22_yAddr_uid51_fpDivTest_b_11_mem_ab = redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q;
    assign redist22_yAddr_uid51_fpDivTest_b_11_mem_ena_OrRstB = areset | en[0];
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
    ) redist22_yAddr_uid51_fpDivTest_b_11_mem_dmem (
        .clocken1(redist22_yAddr_uid51_fpDivTest_b_11_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist22_yAddr_uid51_fpDivTest_b_11_mem_aa),
        .data_a(redist22_yAddr_uid51_fpDivTest_b_11_mem_ia),
        .wren_a(en[0]),
        .address_b(redist22_yAddr_uid51_fpDivTest_b_11_mem_ab),
        .q_b(redist22_yAddr_uid51_fpDivTest_b_11_mem_iq),
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
    assign redist22_yAddr_uid51_fpDivTest_b_11_mem_q = $signed(redist22_yAddr_uid51_fpDivTest_b_11_mem_iq[8:0]);

    // memoryC0_uid146_invTables_lutmem(DUALMEM,186)@11 + 2
    assign memoryC0_uid146_invTables_lutmem_aa = redist22_yAddr_uid51_fpDivTest_b_11_mem_q;
    assign memoryC0_uid146_invTables_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign memoryC0_uid146_invTables_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(32),
        .widthad_a(9),
        .numwords_a(512),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Div_altera_fp_functions_19110_etcsazy_memoryC0_uid146_invTables_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) memoryC0_uid146_invTables_lutmem_dmem (
        .clocken0(memoryC0_uid146_invTables_lutmem_ena_NotRstA),
        .sclr(memoryC0_uid146_invTables_lutmem_reset0),
        .clock0(clk),
        .address_a(memoryC0_uid146_invTables_lutmem_aa),
        .q_a(memoryC0_uid146_invTables_lutmem_ir),
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
    assign memoryC0_uid146_invTables_lutmem_r = $signed(memoryC0_uid146_invTables_lutmem_ir[31:0]);

    // s2sumAHighB_uid168_invPolyEval(ADD,167)@13
    assign s2sumAHighB_uid168_invPolyEval_a = $unsigned({{1{memoryC0_uid146_invTables_lutmem_r[31]}}, memoryC0_uid146_invTables_lutmem_r});
    assign s2sumAHighB_uid168_invPolyEval_b = $unsigned({{10{highBBits_uid167_invPolyEval_b[22]}}, highBBits_uid167_invPolyEval_b});
    assign s2sumAHighB_uid168_invPolyEval_o = $unsigned($signed(s2sumAHighB_uid168_invPolyEval_a) + $signed(s2sumAHighB_uid168_invPolyEval_b));
    assign s2sumAHighB_uid168_invPolyEval_q = $signed(s2sumAHighB_uid168_invPolyEval_o[32:0]);

    // lowRangeB_uid166_invPolyEval(BITSELECT,165)@13
    assign lowRangeB_uid166_invPolyEval_in = osig_uid178_pT2_uid165_invPolyEval_b[1:0];
    assign lowRangeB_uid166_invPolyEval_b = $signed(lowRangeB_uid166_invPolyEval_in[1:0]);

    // s2_uid169_invPolyEval(BITJOIN,168)@13
    assign s2_uid169_invPolyEval_q = {s2sumAHighB_uid168_invPolyEval_q, lowRangeB_uid166_invPolyEval_b};

    // invY_uid54_fpDivTest(BITSELECT,53)@13
    assign invY_uid54_fpDivTest_in = s2_uid169_invPolyEval_q[31:0];
    assign invY_uid54_fpDivTest_b = $signed(invY_uid54_fpDivTest_in[31:5]);

    // redist18_invY_uid54_fpDivTest_b_1(DELAY,213)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist18_invY_uid54_fpDivTest_b_1_q <= invY_uid54_fpDivTest_b;
        end
    end

    // prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma(CHAINMULTADD,191)@14 + 5
    // in b@17
    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset = areset;
    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0 = en[0] | prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset;
    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena1 = prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0;
    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena2 = prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0;

    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_a0 = redist18_invY_uid54_fpDivTest_b_1_q;
    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_c0 = lOAdded_uid57_fpDivTest_q;
    tennm_mac #(
        .operation_mode("m27x27"),
        .clear_type("sclr"),
        .use_chainadder("false"),
        .ay_scan_in_clken("0"),
        .ay_scan_in_width(27),
        .ax_clken("0"),
        .ax_width(24),
        .signed_may("false"),
        .signed_max("false"),
        .input_pipeline_clken("2"),
        .second_pipeline_clken("2"),
        .output_clken("1"),
        .result_a_width(51)
    ) prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_DSP0 (
        .clk(clk),
        .ena({ prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena2, prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena1, prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0 }),
        .clr({ prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset, prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset }),
        .ay(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_a0),
        .ax(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_c0),
        .resulta(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_s0),
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
    dspba_delay_ver #( .width(51), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_delay0 ( .xin(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_s0), .xout(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_qq0), .ena(en[0]), .clk(clk), .aclr(areset) );
    assign prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_q = $unsigned(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_qq0[50:0]);

    // osig_uid172_divValPreNorm_uid59_fpDivTest(BITSELECT,171)@19
    assign osig_uid172_divValPreNorm_uid59_fpDivTest_b = $signed(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_q[50:23]);

    // fracYZero_uid15_fpDivTest(LOGICAL,16)@0 + 1
    assign fracYZero_uid15_fpDivTest_a = {1'b0, fracY_uid13_fpDivTest_b};
    assign fracYZero_uid15_fpDivTest_qi = $unsigned(fracYZero_uid15_fpDivTest_a == zeroPaddingInAddition_uid74_fpDivTest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    fracYZero_uid15_fpDivTest_delay ( .xin(fracYZero_uid15_fpDivTest_qi), .xout(fracYZero_uid15_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist25_fracYZero_uid15_fpDivTest_q_19(DELAY,220)
    dspba_delay_ver #( .width(1), .depth(18), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist25_fracYZero_uid15_fpDivTest_q_19 ( .xin(fracYZero_uid15_fpDivTest_q), .xout(redist25_fracYZero_uid15_fpDivTest_q_19_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // divValPreNormYPow2Exc_uid63_fpDivTest(MUX,62)@19
    assign divValPreNormYPow2Exc_uid63_fpDivTest_s = redist25_fracYZero_uid15_fpDivTest_q_19_q;
    always_comb 
    begin
        unique case (divValPreNormYPow2Exc_uid63_fpDivTest_s)
            1'b0 : divValPreNormYPow2Exc_uid63_fpDivTest_q = osig_uid172_divValPreNorm_uid59_fpDivTest_b;
            1'b1 : divValPreNormYPow2Exc_uid63_fpDivTest_q = oFracXZ4_uid61_fpDivTest_q;
            default : divValPreNormYPow2Exc_uid63_fpDivTest_q = 28'b0;
        endcase
    end

    // norm_uid64_fpDivTest(BITSELECT,63)@19
    assign norm_uid64_fpDivTest_b = divValPreNormYPow2Exc_uid63_fpDivTest_q[27:27];

    // redist15_norm_uid64_fpDivTest_b_1(DELAY,210)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist15_norm_uid64_fpDivTest_b_1_q <= norm_uid64_fpDivTest_b;
        end
    end

    // zeroPaddingInAddition_uid74_fpDivTest(CONSTANT,73)
    assign zeroPaddingInAddition_uid74_fpDivTest_q = 24'b000000000000000000000000;

    // expFracPostRnd_uid75_fpDivTest(BITJOIN,74)@20
    assign expFracPostRnd_uid75_fpDivTest_q = {redist15_norm_uid64_fpDivTest_b_1_q, zeroPaddingInAddition_uid74_fpDivTest_q, VCC_q};

    // expR_uid48_fpDivTest_lhsMSBs_select_b_const(CONSTANT,189)
    assign expR_uid48_fpDivTest_lhsMSBs_select_b_const_q = 7'b0111111;

    // expR_uid48_fpDivTest_MSBs_sums(ADD,184)@19
    assign expR_uid48_fpDivTest_MSBs_sums_a = $unsigned({3'b000, expR_uid48_fpDivTest_lhsMSBs_select_b_const_q});
    assign expR_uid48_fpDivTest_MSBs_sums_b = $unsigned({{2{expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b[7]}}, expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b});
    assign expR_uid48_fpDivTest_MSBs_sums_o = $unsigned($signed(expR_uid48_fpDivTest_MSBs_sums_a) + $signed(expR_uid48_fpDivTest_MSBs_sums_b));
    assign expR_uid48_fpDivTest_MSBs_sums_q = $signed(expR_uid48_fpDivTest_MSBs_sums_o[8:0]);

    // expXmY_uid47_fpDivTest(SUB,46)@18 + 1
    assign expXmY_uid47_fpDivTest_a = $unsigned({1'b0, redist30_expX_uid9_fpDivTest_b_4_q});
    assign expXmY_uid47_fpDivTest_b = $unsigned({1'b0, redist26_expY_uid12_fpDivTest_b_18_mem_q});
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            expXmY_uid47_fpDivTest_o <= 9'b0;
        end
        else if (en == 1'b1)
        begin
            expXmY_uid47_fpDivTest_o <= $unsigned($signed(expXmY_uid47_fpDivTest_a) - $signed(expXmY_uid47_fpDivTest_b));
        end
    end
    assign expXmY_uid47_fpDivTest_q = $signed(expXmY_uid47_fpDivTest_o[8:0]);

    // expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged(BITSELECT,194)@19
    assign expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b = expXmY_uid47_fpDivTest_q[8:1];
    assign expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_c = expXmY_uid47_fpDivTest_q[0:0];

    // expR_uid48_fpDivTest_split_join(BITJOIN,185)@19
    assign expR_uid48_fpDivTest_split_join_q = {expR_uid48_fpDivTest_MSBs_sums_q, expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_c};

    // divValPreNormHigh_uid65_fpDivTest(BITSELECT,64)@19
    assign divValPreNormHigh_uid65_fpDivTest_in = divValPreNormYPow2Exc_uid63_fpDivTest_q[26:0];
    assign divValPreNormHigh_uid65_fpDivTest_b = $signed(divValPreNormHigh_uid65_fpDivTest_in[26:2]);

    // divValPreNormLow_uid66_fpDivTest(BITSELECT,65)@19
    assign divValPreNormLow_uid66_fpDivTest_in = divValPreNormYPow2Exc_uid63_fpDivTest_q[25:0];
    assign divValPreNormLow_uid66_fpDivTest_b = $signed(divValPreNormLow_uid66_fpDivTest_in[25:1]);

    // normFracRnd_uid67_fpDivTest(MUX,66)@19
    assign normFracRnd_uid67_fpDivTest_s = norm_uid64_fpDivTest_b;
    always_comb 
    begin
        unique case (normFracRnd_uid67_fpDivTest_s)
            1'b0 : normFracRnd_uid67_fpDivTest_q = divValPreNormLow_uid66_fpDivTest_b;
            1'b1 : normFracRnd_uid67_fpDivTest_q = divValPreNormHigh_uid65_fpDivTest_b;
            default : normFracRnd_uid67_fpDivTest_q = 25'b0;
        endcase
    end

    // expFracRnd_uid68_fpDivTest(BITJOIN,67)@19
    assign expFracRnd_uid68_fpDivTest_q = {expR_uid48_fpDivTest_split_join_q, normFracRnd_uid67_fpDivTest_q};

    // redist14_expFracRnd_uid68_fpDivTest_q_1(DELAY,209)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist14_expFracRnd_uid68_fpDivTest_q_1_q <= expFracRnd_uid68_fpDivTest_q;
        end
    end

    // expFracPostRnd_uid76_fpDivTest(ADD,75)@20
    assign expFracPostRnd_uid76_fpDivTest_a = $unsigned({{2{redist14_expFracRnd_uid68_fpDivTest_q_1_q[34]}}, redist14_expFracRnd_uid68_fpDivTest_q_1_q});
    assign expFracPostRnd_uid76_fpDivTest_b = $unsigned({11'b00000000000, expFracPostRnd_uid75_fpDivTest_q});
    assign expFracPostRnd_uid76_fpDivTest_o = $unsigned($signed(expFracPostRnd_uid76_fpDivTest_a) + $signed(expFracPostRnd_uid76_fpDivTest_b));
    assign expFracPostRnd_uid76_fpDivTest_q = $signed(expFracPostRnd_uid76_fpDivTest_o[35:0]);

    // fracPostRndF_uid79_fpDivTest(BITSELECT,78)@20
    assign fracPostRndF_uid79_fpDivTest_in = expFracPostRnd_uid76_fpDivTest_q[24:0];
    assign fracPostRndF_uid79_fpDivTest_b = $signed(fracPostRndF_uid79_fpDivTest_in[24:1]);

    // invYO_uid55_fpDivTest(BITSELECT,54)@13
    assign invYO_uid55_fpDivTest_in = $unsigned(s2_uid169_invPolyEval_q[32:0]);
    assign invYO_uid55_fpDivTest_b = invYO_uid55_fpDivTest_in[32:32];

    // redist17_invYO_uid55_fpDivTest_b_7(DELAY,212)
    dspba_delay_ver #( .width(1), .depth(7), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist17_invYO_uid55_fpDivTest_b_7 ( .xin(invYO_uid55_fpDivTest_b), .xout(redist17_invYO_uid55_fpDivTest_b_7_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // fracPostRndF_uid80_fpDivTest(MUX,79)@20 + 1
    assign fracPostRndF_uid80_fpDivTest_s = redist17_invYO_uid55_fpDivTest_b_7_q;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            fracPostRndF_uid80_fpDivTest_q <= 24'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (fracPostRndF_uid80_fpDivTest_s)
                1'b0 : fracPostRndF_uid80_fpDivTest_q <= fracPostRndF_uid79_fpDivTest_b;
                1'b1 : fracPostRndF_uid80_fpDivTest_q <= fracXExt_uid77_fpDivTest_q;
                default : fracPostRndF_uid80_fpDivTest_q <= 24'b0;
            endcase
        end
    end

    // betweenFPwF_uid102_fpDivTest(BITSELECT,101)@21
    assign betweenFPwF_uid102_fpDivTest_in = $unsigned(fracPostRndF_uid80_fpDivTest_q[0:0]);
    assign betweenFPwF_uid102_fpDivTest_b = betweenFPwF_uid102_fpDivTest_in[0:0];

    // redist7_betweenFPwF_uid102_fpDivTest_b_7(DELAY,202)
    dspba_delay_ver #( .width(1), .depth(7), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist7_betweenFPwF_uid102_fpDivTest_b_7 ( .xin(betweenFPwF_uid102_fpDivTest_b), .xout(redist7_betweenFPwF_uid102_fpDivTest_b_7_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt(COUNTER,235)
    // low=0, high=5, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i <= 3'd0;
            redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i == 3'd4)
            begin
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq <= 1'b0;
            end
            if (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq == 1'b1)
            begin
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i <= $unsigned(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i) + $unsigned(3'd3);
            end
            else
            begin
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i <= $unsigned(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q = $signed(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i[2:0]);

    // redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux(MUX,236)
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s = en;
    always_comb 
    begin
        unique case (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s)
            1'b0 : redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q = redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q;
            1'b1 : redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q = redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q;
            default : redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q = 3'b0;
        endcase
    end

    // qDivProdLTX_opB_uid100_fpDivTest(BITJOIN,99)@20
    assign qDivProdLTX_opB_uid100_fpDivTest_q = {redist31_expX_uid9_fpDivTest_b_6_q, redist29_fracX_uid10_fpDivTest_b_6_mem_q};

    // redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr(REG,237)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q <= 3'b101;
        end
        else
        begin
            redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q;
        end
    end

    // redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem(DUALMEM,234)
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ia = $unsigned(qDivProdLTX_opB_uid100_fpDivTest_q);
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_aa = redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q;
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ab = redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q;
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(31),
        .widthad_a(3),
        .numwords_a(6),
        .width_b(31),
        .widthad_b(3),
        .numwords_b(6),
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
    ) redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_dmem (
        .clocken1(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_aa),
        .data_a(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ia),
        .wren_a(en[0]),
        .address_b(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ab),
        .q_b(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_iq),
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
    assign redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_q = $signed(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_iq[30:0]);

    // redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0(DELAY,233)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_q <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_q;
        end
    end

    // redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt(COUNTER,239)
    // low=0, high=19, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i <= 5'd0;
            redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i == 5'd18)
            begin
                redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq <= 1'b0;
            end
            if (redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq == 1'b1)
            begin
                redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i <= $unsigned(redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i) + $unsigned(5'd13);
            end
            else
            begin
                redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i <= $unsigned(redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i) + $unsigned(5'd1);
            end
        end
    end
    assign redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q = $signed(redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i[4:0]);

    // redist12_lOAdded_uid87_fpDivTest_q_21_rdmux(MUX,240)
    assign redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s = en;
    always_comb 
    begin
        unique case (redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s)
            1'b0 : redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q = redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q;
            1'b1 : redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q = redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q;
            default : redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q = 5'b0;
        endcase
    end

    // lOAdded_uid87_fpDivTest(BITJOIN,86)@0
    assign lOAdded_uid87_fpDivTest_q = {VCC_q, fracY_uid13_fpDivTest_b};

    // redist12_lOAdded_uid87_fpDivTest_q_21_wraddr(REG,241)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q <= 5'b10011;
        end
        else
        begin
            redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q <= redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q;
        end
    end

    // redist12_lOAdded_uid87_fpDivTest_q_21_mem(DUALMEM,238)
    assign redist12_lOAdded_uid87_fpDivTest_q_21_mem_ia = $unsigned(lOAdded_uid87_fpDivTest_q);
    assign redist12_lOAdded_uid87_fpDivTest_q_21_mem_aa = redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q;
    assign redist12_lOAdded_uid87_fpDivTest_q_21_mem_ab = redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q;
    assign redist12_lOAdded_uid87_fpDivTest_q_21_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(24),
        .widthad_a(5),
        .numwords_a(20),
        .width_b(24),
        .widthad_b(5),
        .numwords_b(20),
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
    ) redist12_lOAdded_uid87_fpDivTest_q_21_mem_dmem (
        .clocken1(redist12_lOAdded_uid87_fpDivTest_q_21_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist12_lOAdded_uid87_fpDivTest_q_21_mem_aa),
        .data_a(redist12_lOAdded_uid87_fpDivTest_q_21_mem_ia),
        .wren_a(en[0]),
        .address_b(redist12_lOAdded_uid87_fpDivTest_q_21_mem_ab),
        .q_b(redist12_lOAdded_uid87_fpDivTest_q_21_mem_iq),
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
    assign redist12_lOAdded_uid87_fpDivTest_q_21_mem_q = $signed(redist12_lOAdded_uid87_fpDivTest_q_21_mem_iq[23:0]);

    // lOAdded_uid84_fpDivTest(BITJOIN,83)@21
    assign lOAdded_uid84_fpDivTest_q = {VCC_q, fracPostRndF_uid80_fpDivTest_q};

    // qDivProd_uid89_fpDivTest_cma(CHAINMULTADD,190)@21 + 5
    // in b@24
    assign qDivProd_uid89_fpDivTest_cma_reset = areset;
    assign qDivProd_uid89_fpDivTest_cma_ena0 = en[0] | qDivProd_uid89_fpDivTest_cma_reset;
    assign qDivProd_uid89_fpDivTest_cma_ena1 = qDivProd_uid89_fpDivTest_cma_ena0;
    assign qDivProd_uid89_fpDivTest_cma_ena2 = qDivProd_uid89_fpDivTest_cma_ena0;

    assign qDivProd_uid89_fpDivTest_cma_a0 = lOAdded_uid84_fpDivTest_q;
    assign qDivProd_uid89_fpDivTest_cma_c0 = redist12_lOAdded_uid87_fpDivTest_q_21_mem_q;
    tennm_mac #(
        .operation_mode("m27x27"),
        .clear_type("sclr"),
        .use_chainadder("false"),
        .ay_scan_in_clken("0"),
        .ay_scan_in_width(25),
        .ax_clken("0"),
        .ax_width(24),
        .signed_may("false"),
        .signed_max("false"),
        .input_pipeline_clken("2"),
        .second_pipeline_clken("2"),
        .output_clken("1"),
        .result_a_width(49)
    ) qDivProd_uid89_fpDivTest_cma_DSP0 (
        .clk(clk),
        .ena({ qDivProd_uid89_fpDivTest_cma_ena2, qDivProd_uid89_fpDivTest_cma_ena1, qDivProd_uid89_fpDivTest_cma_ena0 }),
        .clr({ qDivProd_uid89_fpDivTest_cma_reset, qDivProd_uid89_fpDivTest_cma_reset }),
        .ay(qDivProd_uid89_fpDivTest_cma_a0),
        .ax(qDivProd_uid89_fpDivTest_cma_c0),
        .resulta(qDivProd_uid89_fpDivTest_cma_s0),
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
    dspba_delay_ver #( .width(49), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    qDivProd_uid89_fpDivTest_cma_delay0 ( .xin(qDivProd_uid89_fpDivTest_cma_s0), .xout(qDivProd_uid89_fpDivTest_cma_qq0), .ena(en[0]), .clk(clk), .aclr(areset) );
    assign qDivProd_uid89_fpDivTest_cma_q = $unsigned(qDivProd_uid89_fpDivTest_cma_qq0[48:0]);

    // qDivProdNorm_uid90_fpDivTest(BITSELECT,89)@26
    assign qDivProdNorm_uid90_fpDivTest_b = qDivProd_uid89_fpDivTest_cma_q[48:48];

    // cstBias_uid7_fpDivTest(CONSTANT,6)
    assign cstBias_uid7_fpDivTest_q = 8'b01111111;

    // qDivProdExp_opBs_uid95_fpDivTest(SUB,94)@26 + 1
    assign qDivProdExp_opBs_uid95_fpDivTest_a = $unsigned({1'b0, cstBias_uid7_fpDivTest_q});
    assign qDivProdExp_opBs_uid95_fpDivTest_b = $unsigned({8'b00000000, qDivProdNorm_uid90_fpDivTest_b});
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            qDivProdExp_opBs_uid95_fpDivTest_o <= 9'b0;
        end
        else if (en == 1'b1)
        begin
            qDivProdExp_opBs_uid95_fpDivTest_o <= $unsigned($signed(qDivProdExp_opBs_uid95_fpDivTest_a) - $signed(qDivProdExp_opBs_uid95_fpDivTest_b));
        end
    end
    assign qDivProdExp_opBs_uid95_fpDivTest_q = $signed(qDivProdExp_opBs_uid95_fpDivTest_o[8:0]);

    // expPostRndFR_uid81_fpDivTest(BITSELECT,80)@20
    assign expPostRndFR_uid81_fpDivTest_in = expFracPostRnd_uid76_fpDivTest_q[32:0];
    assign expPostRndFR_uid81_fpDivTest_b = $signed(expPostRndFR_uid81_fpDivTest_in[32:25]);

    // expPostRndF_uid82_fpDivTest(MUX,81)@20 + 1
    assign expPostRndF_uid82_fpDivTest_s = redist17_invYO_uid55_fpDivTest_b_7_q;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            expPostRndF_uid82_fpDivTest_q <= 8'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (expPostRndF_uid82_fpDivTest_s)
                1'b0 : expPostRndF_uid82_fpDivTest_q <= expPostRndFR_uid81_fpDivTest_b;
                1'b1 : expPostRndF_uid82_fpDivTest_q <= redist31_expX_uid9_fpDivTest_b_6_q;
                default : expPostRndF_uid82_fpDivTest_q <= 8'b0;
            endcase
        end
    end

    // qDivProdExp_opA_uid94_fpDivTest(ADD,93)@21 + 1
    assign qDivProdExp_opA_uid94_fpDivTest_a = {1'b0, redist28_expY_uid12_fpDivTest_b_21_q};
    assign qDivProdExp_opA_uid94_fpDivTest_b = {1'b0, expPostRndF_uid82_fpDivTest_q};
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            qDivProdExp_opA_uid94_fpDivTest_o <= 9'b0;
        end
        else if (en == 1'b1)
        begin
            qDivProdExp_opA_uid94_fpDivTest_o <= $unsigned(qDivProdExp_opA_uid94_fpDivTest_a) + $unsigned(qDivProdExp_opA_uid94_fpDivTest_b);
        end
    end
    assign qDivProdExp_opA_uid94_fpDivTest_q = $signed(qDivProdExp_opA_uid94_fpDivTest_o[8:0]);

    // redist11_qDivProdExp_opA_uid94_fpDivTest_q_6(DELAY,206)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_0 <= $unsigned(qDivProdExp_opA_uid94_fpDivTest_q);
            redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_1 <= redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_0;
            redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_2 <= redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_1;
            redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_3 <= redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_2;
            redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_q <= $signed(redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_3);
        end
    end

    // qDivProdExp_uid96_fpDivTest(SUB,95)@27
    assign qDivProdExp_uid96_fpDivTest_a = $unsigned({3'b000, redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_q});
    assign qDivProdExp_uid96_fpDivTest_b = $unsigned({{3{qDivProdExp_opBs_uid95_fpDivTest_q[8]}}, qDivProdExp_opBs_uid95_fpDivTest_q});
    assign qDivProdExp_uid96_fpDivTest_o = $unsigned($signed(qDivProdExp_uid96_fpDivTest_a) - $signed(qDivProdExp_uid96_fpDivTest_b));
    assign qDivProdExp_uid96_fpDivTest_q = $signed(qDivProdExp_uid96_fpDivTest_o[10:0]);

    // qDivProdLTX_opA_uid98_fpDivTest(BITSELECT,97)@27
    assign qDivProdLTX_opA_uid98_fpDivTest_in = qDivProdExp_uid96_fpDivTest_q[7:0];
    assign qDivProdLTX_opA_uid98_fpDivTest_b = $signed(qDivProdLTX_opA_uid98_fpDivTest_in[7:0]);

    // qDivProdFracHigh_uid91_fpDivTest(BITSELECT,90)@26
    assign qDivProdFracHigh_uid91_fpDivTest_in = qDivProd_uid89_fpDivTest_cma_q[47:0];
    assign qDivProdFracHigh_uid91_fpDivTest_b = $signed(qDivProdFracHigh_uid91_fpDivTest_in[47:24]);

    // qDivProdFracLow_uid92_fpDivTest(BITSELECT,91)@26
    assign qDivProdFracLow_uid92_fpDivTest_in = qDivProd_uid89_fpDivTest_cma_q[46:0];
    assign qDivProdFracLow_uid92_fpDivTest_b = $signed(qDivProdFracLow_uid92_fpDivTest_in[46:23]);

    // qDivProdFrac_uid93_fpDivTest(MUX,92)@26
    assign qDivProdFrac_uid93_fpDivTest_s = qDivProdNorm_uid90_fpDivTest_b;
    always_comb 
    begin
        unique case (qDivProdFrac_uid93_fpDivTest_s)
            1'b0 : qDivProdFrac_uid93_fpDivTest_q = qDivProdFracLow_uid92_fpDivTest_b;
            1'b1 : qDivProdFrac_uid93_fpDivTest_q = qDivProdFracHigh_uid91_fpDivTest_b;
            default : qDivProdFrac_uid93_fpDivTest_q = 24'b0;
        endcase
    end

    // qDivProdFracWF_uid97_fpDivTest(BITSELECT,96)@26
    assign qDivProdFracWF_uid97_fpDivTest_b = $signed(qDivProdFrac_uid93_fpDivTest_q[23:1]);

    // redist10_qDivProdFracWF_uid97_fpDivTest_b_1(DELAY,205)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist10_qDivProdFracWF_uid97_fpDivTest_b_1_q <= qDivProdFracWF_uid97_fpDivTest_b;
        end
    end

    // qDivProdLTX_opA_uid99_fpDivTest(BITJOIN,98)@27
    assign qDivProdLTX_opA_uid99_fpDivTest_q = {qDivProdLTX_opA_uid98_fpDivTest_b, redist10_qDivProdFracWF_uid97_fpDivTest_b_1_q};

    // redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1(DELAY,204)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_q <= qDivProdLTX_opA_uid99_fpDivTest_q;
        end
    end

    // qDividerProdLTX_uid101_fpDivTest(COMPARE,100)@28
    assign qDividerProdLTX_uid101_fpDivTest_a = {2'b00, redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_q};
    assign qDividerProdLTX_uid101_fpDivTest_b = {2'b00, redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_q};
    assign qDividerProdLTX_uid101_fpDivTest_o = $unsigned(qDividerProdLTX_uid101_fpDivTest_a) - $unsigned(qDividerProdLTX_uid101_fpDivTest_b);
    assign qDividerProdLTX_uid101_fpDivTest_c[0] = qDividerProdLTX_uid101_fpDivTest_o[32];

    // extraUlp_uid103_fpDivTest(LOGICAL,102)@28 + 1
    assign extraUlp_uid103_fpDivTest_qi = qDividerProdLTX_uid101_fpDivTest_c & redist7_betweenFPwF_uid102_fpDivTest_b_7_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    extraUlp_uid103_fpDivTest_delay ( .xin(extraUlp_uid103_fpDivTest_qi), .xout(extraUlp_uid103_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt(COUNTER,230)
    // low=0, high=5, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i <= 3'd0;
            redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i == 3'd4)
            begin
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq <= 1'b0;
            end
            if (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq == 1'b1)
            begin
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i <= $unsigned(redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i) + $unsigned(3'd3);
            end
            else
            begin
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i <= $unsigned(redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q = $signed(redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i[2:0]);

    // redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux(MUX,231)
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s = en;
    always_comb 
    begin
        unique case (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s)
            1'b0 : redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q = redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q;
            1'b1 : redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q = redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q;
            default : redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q = 3'b0;
        endcase
    end

    // fracPostRndFT_uid104_fpDivTest(BITSELECT,103)@21
    assign fracPostRndFT_uid104_fpDivTest_b = $signed(fracPostRndF_uid80_fpDivTest_q[23:1]);

    // redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr(REG,232)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q <= 3'b101;
        end
        else
        begin
            redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q;
        end
    end

    // redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem(DUALMEM,229)
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ia = $unsigned(fracPostRndFT_uid104_fpDivTest_b);
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_aa = redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q;
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ab = redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q;
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(23),
        .widthad_a(3),
        .numwords_a(6),
        .width_b(23),
        .widthad_b(3),
        .numwords_b(6),
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
    ) redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_dmem (
        .clocken1(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_aa),
        .data_a(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ia),
        .wren_a(en[0]),
        .address_b(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ab),
        .q_b(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_iq),
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
    assign redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_q = $signed(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_iq[22:0]);

    // redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0(DELAY,228)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_q;
        end
    end

    // fracRPreExcExt_uid105_fpDivTest(ADD,104)@29
    assign fracRPreExcExt_uid105_fpDivTest_a = {1'b0, redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q};
    assign fracRPreExcExt_uid105_fpDivTest_b = {23'b00000000000000000000000, extraUlp_uid103_fpDivTest_q};
    assign fracRPreExcExt_uid105_fpDivTest_o = $unsigned(fracRPreExcExt_uid105_fpDivTest_a) + $unsigned(fracRPreExcExt_uid105_fpDivTest_b);
    assign fracRPreExcExt_uid105_fpDivTest_q = $signed(fracRPreExcExt_uid105_fpDivTest_o[23:0]);

    // ovfIncRnd_uid109_fpDivTest(BITSELECT,108)@29
    assign ovfIncRnd_uid109_fpDivTest_b = fracRPreExcExt_uid105_fpDivTest_q[23:23];

    // redist4_ovfIncRnd_uid109_fpDivTest_b_1(DELAY,199)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist4_ovfIncRnd_uid109_fpDivTest_b_1_q <= ovfIncRnd_uid109_fpDivTest_b;
        end
    end

    // expFracPostRndInc_uid110_fpDivTest(ADD,109)@30
    assign expFracPostRndInc_uid110_fpDivTest_a = {1'b0, redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q};
    assign expFracPostRndInc_uid110_fpDivTest_b = {8'b00000000, redist4_ovfIncRnd_uid109_fpDivTest_b_1_q};
    assign expFracPostRndInc_uid110_fpDivTest_o = $unsigned(expFracPostRndInc_uid110_fpDivTest_a) + $unsigned(expFracPostRndInc_uid110_fpDivTest_b);
    assign expFracPostRndInc_uid110_fpDivTest_q = $signed(expFracPostRndInc_uid110_fpDivTest_o[8:0]);

    // expFracPostRndR_uid111_fpDivTest(BITSELECT,110)@30
    assign expFracPostRndR_uid111_fpDivTest_in = expFracPostRndInc_uid110_fpDivTest_q[7:0];
    assign expFracPostRndR_uid111_fpDivTest_b = $signed(expFracPostRndR_uid111_fpDivTest_in[7:0]);

    // redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt(COUNTER,245)
    // low=0, high=6, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i <= 3'd0;
            redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i == 3'd5)
            begin
                redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq <= 1'b0;
            end
            if (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq == 1'b1)
            begin
                redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i <= $unsigned(redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i) + $unsigned(3'd2);
            end
            else
            begin
                redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i <= $unsigned(redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i) + $unsigned(3'd1);
            end
        end
    end
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q = $signed(redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i[2:0]);

    // redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux(MUX,246)
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s = en;
    always_comb 
    begin
        unique case (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s)
            1'b0 : redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q = redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q;
            1'b1 : redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q = redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q;
            default : redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q = 3'b0;
        endcase
    end

    // redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0(DELAY,242)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_q <= expPostRndFR_uid81_fpDivTest_b;
        end
    end

    // redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr(REG,247)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q <= 3'b110;
        end
        else
        begin
            redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q;
        end
    end

    // redist13_expPostRndFR_uid81_fpDivTest_b_10_mem(DUALMEM,244)
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ia = $unsigned(redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_q);
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_aa = redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q;
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ab = redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q;
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(8),
        .widthad_a(3),
        .numwords_a(7),
        .width_b(8),
        .widthad_b(3),
        .numwords_b(7),
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
    ) redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_dmem (
        .clocken1(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_aa),
        .data_a(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ia),
        .wren_a(en[0]),
        .address_b(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ab),
        .q_b(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_iq),
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
    assign redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_q = $signed(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_iq[7:0]);

    // redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0(DELAY,243)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_q;
        end
    end

    // redist6_extraUlp_uid103_fpDivTest_q_2(DELAY,201)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist6_extraUlp_uid103_fpDivTest_q_2_q <= extraUlp_uid103_fpDivTest_q;
        end
    end

    // expRPreExc_uid112_fpDivTest(MUX,111)@30
    assign expRPreExc_uid112_fpDivTest_s = redist6_extraUlp_uid103_fpDivTest_q_2_q;
    always_comb 
    begin
        unique case (expRPreExc_uid112_fpDivTest_s)
            1'b0 : expRPreExc_uid112_fpDivTest_q = redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q;
            1'b1 : expRPreExc_uid112_fpDivTest_q = expFracPostRndR_uid111_fpDivTest_b;
            default : expRPreExc_uid112_fpDivTest_q = 8'b0;
        endcase
    end

    // invExpXIsMax_uid43_fpDivTest(LOGICAL,42)@21
    assign invExpXIsMax_uid43_fpDivTest_q = $signed(~ (expXIsMax_uid38_fpDivTest_q));

    // InvExpXIsZero_uid44_fpDivTest(LOGICAL,43)@21
    assign InvExpXIsZero_uid44_fpDivTest_q = $signed(~ (excZ_y_uid37_fpDivTest_q));

    // excR_y_uid45_fpDivTest(LOGICAL,44)@21
    assign excR_y_uid45_fpDivTest_q = $signed(InvExpXIsZero_uid44_fpDivTest_q & invExpXIsMax_uid43_fpDivTest_q);

    // excXIYR_uid127_fpDivTest(LOGICAL,126)@21
    assign excXIYR_uid127_fpDivTest_q = $signed(excI_x_uid27_fpDivTest_q & excR_y_uid45_fpDivTest_q);

    // excXIYZ_uid126_fpDivTest(LOGICAL,125)@21
    assign excXIYZ_uid126_fpDivTest_q = $signed(excI_x_uid27_fpDivTest_q & excZ_y_uid37_fpDivTest_q);

    // expRExt_uid114_fpDivTest(BITSELECT,113)@20
    assign expRExt_uid114_fpDivTest_b = expFracPostRnd_uid76_fpDivTest_q[35:25];

    // redist3_expRExt_uid114_fpDivTest_b_1(DELAY,198)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist3_expRExt_uid114_fpDivTest_b_1_q <= expRExt_uid114_fpDivTest_b;
        end
    end

    // expOvf_uid118_fpDivTest(COMPARE,117)@21
    assign expOvf_uid118_fpDivTest_a = $unsigned({{2{redist3_expRExt_uid114_fpDivTest_b_1_q[10]}}, redist3_expRExt_uid114_fpDivTest_b_1_q});
    assign expOvf_uid118_fpDivTest_b = $unsigned({5'b00000, cstAllOWE_uid18_fpDivTest_q});
    assign expOvf_uid118_fpDivTest_o = $unsigned($signed(expOvf_uid118_fpDivTest_a) - $signed(expOvf_uid118_fpDivTest_b));
    assign expOvf_uid118_fpDivTest_n[0] = ~ (expOvf_uid118_fpDivTest_o[12]);

    // invExpXIsMax_uid29_fpDivTest(LOGICAL,28)@21
    assign invExpXIsMax_uid29_fpDivTest_q = $signed(~ (expXIsMax_uid24_fpDivTest_q));

    // InvExpXIsZero_uid30_fpDivTest(LOGICAL,29)@21
    assign InvExpXIsZero_uid30_fpDivTest_q = $signed(~ (excZ_x_uid23_fpDivTest_q));

    // excR_x_uid31_fpDivTest(LOGICAL,30)@21
    assign excR_x_uid31_fpDivTest_q = $signed(InvExpXIsZero_uid30_fpDivTest_q & invExpXIsMax_uid29_fpDivTest_q);

    // excXRYROvf_uid125_fpDivTest(LOGICAL,124)@21
    assign excXRYROvf_uid125_fpDivTest_q = $signed(excR_x_uid31_fpDivTest_q & excR_y_uid45_fpDivTest_q & expOvf_uid118_fpDivTest_n);

    // excXRYZ_uid124_fpDivTest(LOGICAL,123)@21
    assign excXRYZ_uid124_fpDivTest_q = $signed(excR_x_uid31_fpDivTest_q & excZ_y_uid37_fpDivTest_q);

    // excRInf_uid128_fpDivTest(LOGICAL,127)@21 + 1
    assign excRInf_uid128_fpDivTest_qi = excXRYZ_uid124_fpDivTest_q | excXRYROvf_uid125_fpDivTest_q | excXIYZ_uid126_fpDivTest_q | excXIYR_uid127_fpDivTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    excRInf_uid128_fpDivTest_delay ( .xin(excRInf_uid128_fpDivTest_qi), .xout(excRInf_uid128_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // xRegOrZero_uid121_fpDivTest(LOGICAL,120)@21
    assign xRegOrZero_uid121_fpDivTest_q = $signed(excR_x_uid31_fpDivTest_q | excZ_x_uid23_fpDivTest_q);

    // regOrZeroOverInf_uid122_fpDivTest(LOGICAL,121)@21
    assign regOrZeroOverInf_uid122_fpDivTest_q = $signed(xRegOrZero_uid121_fpDivTest_q & excI_y_uid41_fpDivTest_q);

    // expUdf_uid115_fpDivTest(COMPARE,114)@21
    assign expUdf_uid115_fpDivTest_a = $unsigned({12'b000000000000, GND_q});
    assign expUdf_uid115_fpDivTest_b = $unsigned({{2{redist3_expRExt_uid114_fpDivTest_b_1_q[10]}}, redist3_expRExt_uid114_fpDivTest_b_1_q});
    assign expUdf_uid115_fpDivTest_o = $unsigned($signed(expUdf_uid115_fpDivTest_a) - $signed(expUdf_uid115_fpDivTest_b));
    assign expUdf_uid115_fpDivTest_n[0] = ~ (expUdf_uid115_fpDivTest_o[12]);

    // regOverRegWithUf_uid120_fpDivTest(LOGICAL,119)@21
    assign regOverRegWithUf_uid120_fpDivTest_q = $signed(expUdf_uid115_fpDivTest_n & excR_x_uid31_fpDivTest_q & excR_y_uid45_fpDivTest_q);

    // zeroOverReg_uid119_fpDivTest(LOGICAL,118)@21
    assign zeroOverReg_uid119_fpDivTest_q = $signed(excZ_x_uid23_fpDivTest_q & excR_y_uid45_fpDivTest_q);

    // excRZero_uid123_fpDivTest(LOGICAL,122)@21 + 1
    assign excRZero_uid123_fpDivTest_qi = zeroOverReg_uid119_fpDivTest_q | regOverRegWithUf_uid120_fpDivTest_q | regOrZeroOverInf_uid122_fpDivTest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    excRZero_uid123_fpDivTest_delay ( .xin(excRZero_uid123_fpDivTest_qi), .xout(excRZero_uid123_fpDivTest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // concExc_uid132_fpDivTest(BITJOIN,131)@22
    assign concExc_uid132_fpDivTest_q = {excRNaN_uid131_fpDivTest_q, excRInf_uid128_fpDivTest_q, excRZero_uid123_fpDivTest_q};

    // excREnc_uid133_fpDivTest(LOOKUP,132)@22 + 1
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            excREnc_uid133_fpDivTest_q <= 2'b01;
        end
        else if (en == 1'b1)
        begin
            unique case (concExc_uid132_fpDivTest_q)
                3'b000 : excREnc_uid133_fpDivTest_q <= 2'b01;
                3'b001 : excREnc_uid133_fpDivTest_q <= 2'b00;
                3'b010 : excREnc_uid133_fpDivTest_q <= 2'b10;
                3'b011 : excREnc_uid133_fpDivTest_q <= 2'b00;
                3'b100 : excREnc_uid133_fpDivTest_q <= 2'b11;
                3'b101 : excREnc_uid133_fpDivTest_q <= 2'b00;
                3'b110 : excREnc_uid133_fpDivTest_q <= 2'b00;
                3'b111 : excREnc_uid133_fpDivTest_q <= 2'b00;
                default : begin
                              // unreachable
                              excREnc_uid133_fpDivTest_q <= 2'bxx;
                          end
            endcase
        end
    end

    // redist2_excREnc_uid133_fpDivTest_q_8(DELAY,197)
    dspba_delay_ver #( .width(2), .depth(7), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist2_excREnc_uid133_fpDivTest_q_8 ( .xin(excREnc_uid133_fpDivTest_q), .xout(redist2_excREnc_uid133_fpDivTest_q_8_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // expRPostExc_uid141_fpDivTest(MUX,140)@30
    assign expRPostExc_uid141_fpDivTest_s = redist2_excREnc_uid133_fpDivTest_q_8_q;
    always_comb 
    begin
        unique case (expRPostExc_uid141_fpDivTest_s)
            2'b00 : expRPostExc_uid141_fpDivTest_q = cstAllZWE_uid20_fpDivTest_q;
            2'b01 : expRPostExc_uid141_fpDivTest_q = expRPreExc_uid112_fpDivTest_q;
            2'b10 : expRPostExc_uid141_fpDivTest_q = cstAllOWE_uid18_fpDivTest_q;
            2'b11 : expRPostExc_uid141_fpDivTest_q = cstAllOWE_uid18_fpDivTest_q;
            default : expRPostExc_uid141_fpDivTest_q = 8'b0;
        endcase
    end

    // oneFracRPostExc2_uid134_fpDivTest(CONSTANT,133)
    assign oneFracRPostExc2_uid134_fpDivTest_q = 23'b00000000000000000000001;

    // fracPostRndFPostUlp_uid106_fpDivTest(BITSELECT,105)@29
    assign fracPostRndFPostUlp_uid106_fpDivTest_in = fracRPreExcExt_uid105_fpDivTest_q[22:0];
    assign fracPostRndFPostUlp_uid106_fpDivTest_b = $signed(fracPostRndFPostUlp_uid106_fpDivTest_in[22:0]);

    // fracRPreExc_uid107_fpDivTest(MUX,106)@29 + 1
    assign fracRPreExc_uid107_fpDivTest_s = extraUlp_uid103_fpDivTest_q;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            fracRPreExc_uid107_fpDivTest_q <= 23'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (fracRPreExc_uid107_fpDivTest_s)
                1'b0 : fracRPreExc_uid107_fpDivTest_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q;
                1'b1 : fracRPreExc_uid107_fpDivTest_q <= fracPostRndFPostUlp_uid106_fpDivTest_b;
                default : fracRPreExc_uid107_fpDivTest_q <= 23'b0;
            endcase
        end
    end

    // fracRPostExc_uid137_fpDivTest(MUX,136)@30
    assign fracRPostExc_uid137_fpDivTest_s = redist2_excREnc_uid133_fpDivTest_q_8_q;
    always_comb 
    begin
        unique case (fracRPostExc_uid137_fpDivTest_s)
            2'b00 : fracRPostExc_uid137_fpDivTest_q = cstZeroWF_uid19_fpDivTest_q;
            2'b01 : fracRPostExc_uid137_fpDivTest_q = fracRPreExc_uid107_fpDivTest_q;
            2'b10 : fracRPostExc_uid137_fpDivTest_q = cstZeroWF_uid19_fpDivTest_q;
            2'b11 : fracRPostExc_uid137_fpDivTest_q = oneFracRPostExc2_uid134_fpDivTest_q;
            default : fracRPostExc_uid137_fpDivTest_q = 23'b0;
        endcase
    end

    // divR_uid144_fpDivTest(BITJOIN,143)@30
    assign divR_uid144_fpDivTest_q = {redist1_sRPostExc_uid143_fpDivTest_q_8_q, expRPostExc_uid141_fpDivTest_q, fracRPostExc_uid137_fpDivTest_q};

    // xOut(GPOUT,4)@30
    assign q = divR_uid144_fpDivTest_q;

endmodule
