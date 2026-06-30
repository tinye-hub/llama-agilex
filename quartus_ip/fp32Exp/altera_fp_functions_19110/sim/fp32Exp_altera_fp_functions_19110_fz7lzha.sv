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

// SystemVerilog created from fp32Exp_altera_fp_functions_19110_fz7lzha
// SystemVerilog created on Tue Jun 30 04:11:14 2026


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module fp32Exp_altera_fp_functions_19110_fz7lzha (
    input wire [31:0] a,
    input wire [0:0] en,
    output wire [31:0] q,
    input wire clk,
    input wire areset
    );

    wire [0:0] GND_q;
    wire [0:0] VCC_q;
    wire [7:0] expX_uid6_fpExpETest_b;
    wire [0:0] signX_uid7_fpExpETest_b;
    wire [22:0] fracX_uid8_fpExpETest_b;
    wire [7:0] cstBias_uid9_fpExpETest_q;
    wire [7:0] cstBiasM1_uid10_fpExpETest_q;
    wire [7:0] cstZeroWE_uid14_fpExpETest_q;
    wire [7:0] cstAllOWE_uid17_fpExpETest_q;
    wire [22:0] cstZeroWF_uid18_fpExpETest_q;
    wire [0:0] excZ_x_uid22_fpExpETest_qi;
    reg [0:0] excZ_x_uid22_fpExpETest_q;
    wire [0:0] expXIsMax_uid23_fpExpETest_qi;
    reg [0:0] expXIsMax_uid23_fpExpETest_q;
    wire [0:0] fracXIsZero_uid24_fpExpETest_qi;
    reg [0:0] fracXIsZero_uid24_fpExpETest_q;
    wire [0:0] fracXIsNotZero_uid25_fpExpETest_q;
    wire [0:0] excI_x_uid26_fpExpETest_q;
    wire [0:0] excN_x_uid27_fpExpETest_q;
    wire [0:0] invExpXIsMax_uid28_fpExpETest_q;
    wire [0:0] InvExpXIsZero_uid29_fpExpETest_q;
    wire [0:0] excR_x_uid30_fpExpETest_q;
    wire [30:0] expFracX_uid31_fpExpETest_q;
    wire [0:0] invSignX_uid34_fpExpETest_q;
    wire [0:0] inputOverflow_uid35_fpExpETest_q;
    wire [0:0] inputUnderflow_uid38_fpExpETest_q;
    wire [6:0] xFxpLow_uid39_fpExpETest_b;
    wire [7:0] oXLow_uid41_fpExpETest_q;
    wire [7:0] cstBiasPCstShift_uid42_fpExpETest_q;
    wire [8:0] shiftVal_uid43_fpExpETest_a;
    wire [8:0] shiftVal_uid43_fpExpETest_b;
    logic [8:0] shiftVal_uid43_fpExpETest_o;
    wire [8:0] shiftVal_uid43_fpExpETest_q;
    wire [0:0] shiftUdf_uid46_fpExpETest_qi;
    reg [0:0] shiftUdf_uid46_fpExpETest_q;
    wire [10:0] zEp_uid51_fpExpETest_q;
    wire [10:0] ePOC_uid52_fpExpETest_b;
    wire [10:0] ePOC_uid52_fpExpETest_qi;
    reg [10:0] ePOC_uid52_fpExpETest_q;
    wire [1:0] Rnd2C_uid54_fpExpETest_q;
    wire [12:0] eP2CWRnd_uid57_fpExpETest_a;
    wire [12:0] eP2CWRnd_uid57_fpExpETest_b;
    logic [12:0] eP2CWRnd_uid57_fpExpETest_o;
    wire [11:0] eP2CWRnd_uid57_fpExpETest_q;
    wire [9:0] expTmp_uid58_fpExpETest_in;
    wire [7:0] expTmp_uid58_fpExpETest_b;
    wire [10:0] bit7_uid59_fpExpETest_in;
    wire [0:0] bit7_uid59_fpExpETest_b;
    wire [0:0] invBit7_uid60_fpExpETest_q;
    wire [9:0] bit8_uid61_fpExpETest_in;
    wire [0:0] bit8_uid61_fpExpETest_b;
    wire [0:0] maxExpCond_uid62_fpExpETest_qi;
    reg [0:0] maxExpCond_uid62_fpExpETest_q;
    wire [0:0] kPZHigh_uid73_fpExpETest_s;
    reg [31:0] kPZHigh_uid73_fpExpETest_q;
    wire [0:0] kPZLow_uid76_fpExpETest_s;
    reg [31:0] kPZLow_uid76_fpExpETest_q;
    wire [0:0] ySign_uid77_fpExpETest_b;
    wire [22:0] fraction_uid78_fpExpETest_in;
    wire [22:0] fraction_uid78_fpExpETest_b;
    wire [30:0] exp_uid79_fpExpETest_in;
    wire [7:0] exp_uid79_fpExpETest_b;
    wire [0:0] invYSign_uid80_fpExpETest_q;
    wire [31:0] minusY_uid81_fpExpETest_q;
    wire [0:0] ySign_uid83_fpExpETest_b;
    wire [22:0] fraction_uid84_fpExpETest_in;
    wire [22:0] fraction_uid84_fpExpETest_b;
    wire [30:0] exp_uid85_fpExpETest_in;
    wire [7:0] exp_uid85_fpExpETest_b;
    wire [0:0] invYSign_uid86_fpExpETest_q;
    wire [31:0] minusY_uid87_fpExpETest_q;
    wire [22:0] fracYP_uid89_fpExpETest_b;
    wire [7:0] expYP_uid90_fpExpETest_b;
    wire [0:0] signYP_uid91_fpExpETest_b;
    wire [6:0] fracYPTop_uid93_fpExpETest_b;
    wire [7:0] fxpAPreAlign_uid95_fpExpETest_q;
    wire [8:0] shiftValFxpA_uid96_fpExpETest_a;
    wire [8:0] shiftValFxpA_uid96_fpExpETest_b;
    logic [8:0] shiftValFxpA_uid96_fpExpETest_o;
    wire [8:0] shiftValFxpA_uid96_fpExpETest_q;
    wire [3:0] shiftValFxpAR_uid97_fpExpETest_in;
    wire [3:0] shiftValFxpAR_uid97_fpExpETest_b;
    wire [8:0] addrEATable_uid99_fpExpETest_q;
    wire [0:0] eAPostUdfA_uid108_fpExpETest_s;
    reg [31:0] eAPostUdfA_uid108_fpExpETest_q;
    reg [6:0] maskAFP_uid109_fpExpETest_q;
    wire [6:0] fracYPTopPostMask_uid110_fpExpETest_q;
    wire [15:0] cst16z_uid111_fpExpETest_q;
    wire [22:0] fracAFull_uid112_fpExpETest_q;
    wire [0:0] newExpA_uid113_fpExpETest_s;
    reg [7:0] newExpA_uid113_fpExpETest_q;
    wire [31:0] a_uid114_fpExpETest_q;
    wire [0:0] ySign_uid115_fpExpETest_b;
    wire [22:0] fraction_uid116_fpExpETest_in;
    wire [22:0] fraction_uid116_fpExpETest_b;
    wire [30:0] exp_uid117_fpExpETest_in;
    wire [7:0] exp_uid117_fpExpETest_b;
    wire [0:0] invYSign_uid118_fpExpETest_q;
    wire [31:0] minusY_uid119_fpExpETest_q;
    wire [7:0] expEY_uid126_fpExpETest_b;
    wire [1:0] lowerBitOfeY_uid127_fpExpETest_in;
    wire [1:0] lowerBitOfeY_uid127_fpExpETest_b;
    wire [7:0] biasM2_uid129_fpExpETest_q;
    wire [7:0] biasP1_uid130_fpExpETest_q;
    wire [1:0] expUpdateVal_uid131_fpExpETest_s;
    reg [7:0] expUpdateVal_uid131_fpExpETest_q;
    wire [10:0] updatedExponent_uid132_fpExpETest_a;
    wire [10:0] updatedExponent_uid132_fpExpETest_b;
    logic [10:0] updatedExponent_uid132_fpExpETest_o;
    wire [9:0] updatedExponent_uid132_fpExpETest_q;
    wire [7:0] expR_uid133_fpExpETest_in;
    wire [7:0] expR_uid133_fpExpETest_b;
    wire [0:0] negInf_uid134_fpExpETest_q;
    wire [0:0] regXAndExpOverflowAndNeg_uid135_fpExpETest_q;
    wire [0:0] excRZero_uid136_fpExpETest_q;
    wire [0:0] regXAndExpOverflowAndPos_uid137_fpExpETest_q;
    wire [0:0] posInf_uid139_fpExpETest_q;
    wire [0:0] excRInf_uid140_fpExpETest_q;
    wire [2:0] concExc_uid141_fpExpETest_q;
    reg [1:0] excREnc_uid142_fpExpETest_q;
    wire [22:0] oneFracRPostExc2_uid143_fpExpETest_q;
    wire [22:0] fracEY_uid145_fpExpETest_b;
    wire [1:0] fracRPostExc_uid147_fpExpETest_s;
    reg [22:0] fracRPostExc_uid147_fpExpETest_q;
    wire [1:0] expRPostExc_uid151_fpExpETest_s;
    reg [7:0] expRPostExc_uid151_fpExpETest_q;
    wire [0:0] signEY_uid152_fpExpETest_b;
    wire [31:0] finalResult_uid153_fpExpETest_q;
    reg [12:0] p1_uid240_eP_uid50_fpExpETest_q;
    reg [8:0] p0_uid241_eP_uid50_fpExpETest_q;
    wire [13:0] lev1_a0_uid242_eP_uid50_fpExpETest_a;
    wire [13:0] lev1_a0_uid242_eP_uid50_fpExpETest_b;
    logic [13:0] lev1_a0_uid242_eP_uid50_fpExpETest_o;
    wire [13:0] lev1_a0_uid242_eP_uid50_fpExpETest_q;
    wire [11:0] sOuputFormat_uid243_eP_uid50_fpExpETest_in;
    wire [9:0] sOuputFormat_uid243_eP_uid50_fpExpETest_b;
    wire [31:0] cste128h_uid72_fpExpETest_b_const_q;
    wire [31:0] cste128l_uid75_fpExpETest_b_const_q;
    wire [31:0] oneFP_uid107_fpExpETest_b_const_q;
    wire [31:0] cstHalfFP_uid122_fpExpETest_b_const_q;
    wire [6:0] rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest_b;
    wire [7:0] rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q;
    wire [5:0] rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest_b;
    wire [1:0] rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q;
    wire [7:0] rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q;
    wire [4:0] rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest_b;
    wire [2:0] rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q;
    wire [7:0] rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q;
    wire [1:0] rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s;
    reg [7:0] rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q;
    wire [3:0] rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest_b;
    wire [3:0] rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q;
    wire [7:0] rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q;
    wire floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_reset0;
    wire floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ena_NotRstA;
    wire [31:0] floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ia;
    wire [7:0] floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_aa;
    wire [7:0] floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ab;
    wire [31:0] floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ir;
    wire [31:0] floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r;
    wire floatTable_kPPreZLow_uid67_fpExpETest_lutmem_reset0;
    wire floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ena_NotRstA;
    wire [31:0] floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ia;
    wire [7:0] floatTable_kPPreZLow_uid67_fpExpETest_lutmem_aa;
    wire [7:0] floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ab;
    wire [31:0] floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ir;
    wire [31:0] floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r;
    wire yP0_uid82_fpExpETest_impl_reset0;
    wire yP0_uid82_fpExpETest_impl_ena0;
    wire [31:0] yP0_uid82_fpExpETest_impl_ax0;
    wire [31:0] yP0_uid82_fpExpETest_impl_ay0;
    wire [31:0] yP0_uid82_fpExpETest_impl_q0;
    wire yP_uid88_fpExpETest_impl_reset0;
    wire yP_uid88_fpExpETest_impl_ena0;
    wire [31:0] yP_uid88_fpExpETest_impl_ax0;
    wire [31:0] yP_uid88_fpExpETest_impl_ay0;
    wire [31:0] yP_uid88_fpExpETest_impl_q0;
    wire [6:0] rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest_b;
    wire [7:0] rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest_q;
    wire [5:0] rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest_b;
    wire [7:0] rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest_q;
    wire [4:0] rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest_b;
    wire [7:0] rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest_q;
    wire [1:0] rightShiftStage0_uid290_fxpA_uid98_fpExpETest_s;
    reg [7:0] rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q;
    wire [3:0] rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest_b;
    wire [7:0] rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest_q;
    wire [1:0] rightShiftStage1_uid297_fxpA_uid98_fpExpETest_s;
    reg [7:0] rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q;
    wire floatTable_eA_uid100_fpExpETest_lutmem_reset0;
    wire floatTable_eA_uid100_fpExpETest_lutmem_ena_NotRstA;
    wire [31:0] floatTable_eA_uid100_fpExpETest_lutmem_ia;
    wire [8:0] floatTable_eA_uid100_fpExpETest_lutmem_aa;
    wire [8:0] floatTable_eA_uid100_fpExpETest_lutmem_ab;
    wire [31:0] floatTable_eA_uid100_fpExpETest_lutmem_ir;
    wire [31:0] floatTable_eA_uid100_fpExpETest_lutmem_r;
    wire b_uid120_fpExpETest_impl_reset0;
    wire b_uid120_fpExpETest_impl_ena0;
    wire [31:0] b_uid120_fpExpETest_impl_ax0;
    wire [31:0] b_uid120_fpExpETest_impl_ay0;
    wire [31:0] b_uid120_fpExpETest_impl_q0;
    wire oPBo2_uid123_fpExpETest_impl_reset0;
    wire oPBo2_uid123_fpExpETest_impl_ena0;
    wire [31:0] oPBo2_uid123_fpExpETest_impl_ax0;
    wire [31:0] oPBo2_uid123_fpExpETest_impl_ay0;
    wire [31:0] oPBo2_uid123_fpExpETest_impl_az0;
    wire [31:0] oPBo2_uid123_fpExpETest_impl_q0;
    wire eB_uid124_fpExpETest_impl_reset0;
    wire eB_uid124_fpExpETest_impl_ena0;
    wire [31:0] eB_uid124_fpExpETest_impl_ax0;
    wire [31:0] eB_uid124_fpExpETest_impl_ay0;
    wire [31:0] eB_uid124_fpExpETest_impl_az0;
    wire [31:0] eB_uid124_fpExpETest_impl_q0;
    wire eY_uid125_fpExpETest_impl_reset0;
    wire eY_uid125_fpExpETest_impl_ena0;
    wire [31:0] eY_uid125_fpExpETest_impl_ay0;
    wire [31:0] eY_uid125_fpExpETest_impl_az0;
    wire [31:0] eY_uid125_fpExpETest_impl_q0;
    wire [27:0] expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313_q;
    wire [27:0] expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314_b;
    wire [29:0] expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_a;
    wire [29:0] expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_b;
    logic [29:0] expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o;
    wire [0:0] expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_n;
    wire [26:0] expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316_q;
    wire [26:0] expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317_b;
    wire [28:0] expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_a;
    wire [28:0] expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_b;
    logic [28:0] expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o;
    wire [0:0] expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_n;
    wire [4:0] udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q;
    wire [7:0] udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_a;
    wire [7:0] udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_b;
    logic [7:0] udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_o;
    wire [0:0] udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c;
    wire [7:0] shiftValPos_uid44_fpExpETest_bit_select_merged_in;
    wire [2:0] shiftValPos_uid44_fpExpETest_bit_select_merged_b;
    wire [4:0] shiftValPos_uid44_fpExpETest_bit_select_merged_c;
    wire [4:0] xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_b;
    wire [2:0] xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_c;
    wire [2:0] expYPBottom_uid92_fpExpETest_bit_select_merged_b;
    wire [4:0] expYPBottom_uid92_fpExpETest_bit_select_merged_c;
    wire [1:0] rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_b;
    wire [1:0] rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c;
    wire [1:0] rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_b;
    wire [0:0] rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c;
    wire [0:0] rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q;
    reg [7:0] mergedMUXes0_q;
    reg [1:0] redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_q;
    reg [2:0] redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q;
    reg [0:0] redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14_q;
    reg [31:0] redist3_eB_uid124_fpExpETest_impl_q0_1_q;
    reg [31:0] redist4_oPBo2_uid123_fpExpETest_impl_q0_1_q;
    reg [31:0] redist5_b_uid120_fpExpETest_impl_q0_1_q;
    reg [31:0] redist8_yP_uid88_fpExpETest_impl_q0_1_q;
    reg [31:0] redist9_yP0_uid82_fpExpETest_impl_q0_1_q;
    reg [0:0] redist10_signEY_uid152_fpExpETest_b_1_q;
    reg [22:0] redist11_fracEY_uid145_fpExpETest_b_1_q;
    reg [31:0] redist13_minusY_uid119_fpExpETest_q_1_q;
    reg [0:0] redist14_signYP_uid91_fpExpETest_b_12_q;
    reg [0:0] redist15_maxExpCond_uid62_fpExpETest_q_2_q;
    reg [0:0] redist16_maxExpCond_uid62_fpExpETest_q_6_q;
    reg [0:0] redist16_maxExpCond_uid62_fpExpETest_q_6_delay_0;
    reg [0:0] redist16_maxExpCond_uid62_fpExpETest_q_6_delay_1;
    reg [0:0] redist16_maxExpCond_uid62_fpExpETest_q_6_delay_2;
    reg [7:0] redist17_expTmp_uid58_fpExpETest_b_4_q;
    reg [7:0] redist17_expTmp_uid58_fpExpETest_b_4_delay_0;
    reg [7:0] redist17_expTmp_uid58_fpExpETest_b_4_delay_1;
    reg [7:0] redist17_expTmp_uid58_fpExpETest_b_4_delay_2;
    reg [0:0] redist19_signX_uid7_fpExpETest_b_1_q;
    reg [7:0] redist20_expX_uid6_fpExpETest_b_1_q;
    reg [31:0] redist21_xIn_a_1_q;
    reg [31:0] redist22_xIn_a_2_q;
    reg [31:0] redist23_xIn_a_5_q;
    reg [31:0] redist23_xIn_a_5_delay_0;
    reg [31:0] redist23_xIn_a_5_delay_1;
    wire redist6_b_uid120_fpExpETest_impl_q0_6_mem_reset0;
    wire redist6_b_uid120_fpExpETest_impl_q0_6_mem_ena_OrRstB;
    wire [31:0] redist6_b_uid120_fpExpETest_impl_q0_6_mem_ia;
    wire [1:0] redist6_b_uid120_fpExpETest_impl_q0_6_mem_aa;
    wire [1:0] redist6_b_uid120_fpExpETest_impl_q0_6_mem_ab;
    wire [31:0] redist6_b_uid120_fpExpETest_impl_q0_6_mem_iq;
    wire [31:0] redist6_b_uid120_fpExpETest_impl_q0_6_mem_q;
    wire [1:0] redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q;
    (* preserve_syn_only *) reg [1:0] redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i;
    wire [0:0] redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s;
    reg [1:0] redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q;
    reg [1:0] redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q;
    wire redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_reset0;
    wire redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ena_OrRstB;
    wire [7:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ia;
    wire [3:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_aa;
    wire [3:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ab;
    wire [7:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_iq;
    wire [7:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_q;
    wire [3:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q;
    (* preserve_syn_only *) reg [3:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i;
    (* preserve_syn_only *) reg redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq;
    wire [0:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s;
    reg [3:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q;
    reg [3:0] redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q;
    wire redist12_excREnc_uid142_fpExpETest_q_29_mem_reset0;
    wire redist12_excREnc_uid142_fpExpETest_q_29_mem_ena_OrRstB;
    wire [1:0] redist12_excREnc_uid142_fpExpETest_q_29_mem_ia;
    wire [4:0] redist12_excREnc_uid142_fpExpETest_q_29_mem_aa;
    wire [4:0] redist12_excREnc_uid142_fpExpETest_q_29_mem_ab;
    wire [1:0] redist12_excREnc_uid142_fpExpETest_q_29_mem_iq;
    wire [1:0] redist12_excREnc_uid142_fpExpETest_q_29_mem_q;
    wire [4:0] redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q;
    (* preserve_syn_only *) reg [4:0] redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i;
    (* preserve_syn_only *) reg redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq;
    wire [0:0] redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s;
    reg [4:0] redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q;
    reg [4:0] redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q;
    reg [7:0] redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q;
    wire redist18_expTmp_uid58_fpExpETest_b_28_mem_reset0;
    wire redist18_expTmp_uid58_fpExpETest_b_28_mem_ena_OrRstB;
    wire [7:0] redist18_expTmp_uid58_fpExpETest_b_28_mem_ia;
    wire [4:0] redist18_expTmp_uid58_fpExpETest_b_28_mem_aa;
    wire [4:0] redist18_expTmp_uid58_fpExpETest_b_28_mem_ab;
    wire [7:0] redist18_expTmp_uid58_fpExpETest_b_28_mem_iq;
    wire [7:0] redist18_expTmp_uid58_fpExpETest_b_28_mem_q;
    wire [4:0] redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q;
    (* preserve_syn_only *) reg [4:0] redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i;
    (* preserve_syn_only *) reg redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq;
    wire [0:0] redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s;
    reg [4:0] redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q;
    reg [4:0] redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q;


    // oneFP_uid107_fpExpETest_b_const(CONSTANT,246)
    assign oneFP_uid107_fpExpETest_b_const_q = 32'b00111111100000000000000000000000;

    // redist21_xIn_a_1(DELAY,349)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist21_xIn_a_1_q <= a;
        end
    end

    // redist22_xIn_a_2(DELAY,350)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist22_xIn_a_2_q <= redist21_xIn_a_1_q;
        end
    end

    // redist23_xIn_a_5(DELAY,351)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist23_xIn_a_5_delay_0 <= $unsigned(redist22_xIn_a_2_q);
            redist23_xIn_a_5_delay_1 <= redist23_xIn_a_5_delay_0;
            redist23_xIn_a_5_q <= $signed(redist23_xIn_a_5_delay_1);
        end
    end

    // cste128h_uid72_fpExpETest_b_const(CONSTANT,244)
    assign cste128h_uid72_fpExpETest_b_const_q = 32'b01000010101100010111001000010111;

    // VCC(CONSTANT,1)
    assign VCC_q = 1'b1;

    // signX_uid7_fpExpETest(BITSELECT,6)@2
    assign signX_uid7_fpExpETest_b = redist22_xIn_a_2_q[31:31];

    // redist19_signX_uid7_fpExpETest_b_1(DELAY,347)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist19_signX_uid7_fpExpETest_b_1_q <= signX_uid7_fpExpETest_b;
        end
    end

    // Rnd2C_uid54_fpExpETest(BITJOIN,53)@3
    assign Rnd2C_uid54_fpExpETest_q = {VCC_q, redist19_signX_uid7_fpExpETest_b_1_q};

    // GND(CONSTANT,0)
    assign GND_q = 1'b0;

    // rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest(CONSTANT,261)
    assign rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q = 3'b000;

    // rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest(BITSELECT,260)@1
    assign rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest_b = $signed(oXLow_uid41_fpExpETest_q[7:3]);

    // rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest(BITJOIN,262)@1
    assign rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q = {rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q, rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest_b};

    // rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest(CONSTANT,258)
    assign rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q = 2'b00;

    // rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest(BITSELECT,257)@1
    assign rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest_b = $signed(oXLow_uid41_fpExpETest_q[7:2]);

    // rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest(BITJOIN,259)@1
    assign rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q = {rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q, rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest_b};

    // rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest(BITSELECT,254)@1
    assign rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest_b = $signed(oXLow_uid41_fpExpETest_q[7:1]);

    // rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest(BITJOIN,256)@1
    assign rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q = {GND_q, rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest_b};

    // fracX_uid8_fpExpETest(BITSELECT,7)@1
    assign fracX_uid8_fpExpETest_b = $signed(redist21_xIn_a_1_q[22:0]);

    // xFxpLow_uid39_fpExpETest(BITSELECT,38)@1
    assign xFxpLow_uid39_fpExpETest_b = $signed(fracX_uid8_fpExpETest_b[22:16]);

    // oXLow_uid41_fpExpETest(BITJOIN,40)@1
    assign oXLow_uid41_fpExpETest_q = {VCC_q, xFxpLow_uid39_fpExpETest_b};

    // rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest(MUX,264)@1
    assign rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s = rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_b;
    always_comb 
    begin
        unique case (rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s)
            2'b00 : rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q = oXLow_uid41_fpExpETest_q;
            2'b01 : rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q = rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q;
            2'b10 : rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q = rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q;
            2'b11 : rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q = rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q;
            default : rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q = 8'b0;
        endcase
    end

    // rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel(LOGICAL,326)@1
    assign rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q = ~ (rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c);

    // rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest(CONSTANT,266)
    assign rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q = 4'b0000;

    // rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest(BITSELECT,265)@1
    assign rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest_b = $signed(rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q[7:4]);

    // rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest(BITJOIN,267)@1
    assign rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q = {rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q, rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest_b};

    // expX_uid6_fpExpETest(BITSELECT,5)@0
    assign expX_uid6_fpExpETest_b = $signed(a[30:23]);

    // cstBiasPCstShift_uid42_fpExpETest(CONSTANT,41)
    assign cstBiasPCstShift_uid42_fpExpETest_q = 8'b10000101;

    // shiftVal_uid43_fpExpETest(SUB,42)@0
    assign shiftVal_uid43_fpExpETest_a = $unsigned({1'b0, cstBiasPCstShift_uid42_fpExpETest_q});
    assign shiftVal_uid43_fpExpETest_b = $unsigned({1'b0, expX_uid6_fpExpETest_b});
    assign shiftVal_uid43_fpExpETest_o = $unsigned($signed(shiftVal_uid43_fpExpETest_a) - $signed(shiftVal_uid43_fpExpETest_b));
    assign shiftVal_uid43_fpExpETest_q = $signed(shiftVal_uid43_fpExpETest_o[8:0]);

    // shiftValPos_uid44_fpExpETest_bit_select_merged(BITSELECT,321)@0
    assign shiftValPos_uid44_fpExpETest_bit_select_merged_in = shiftVal_uid43_fpExpETest_q[7:0];
    assign shiftValPos_uid44_fpExpETest_bit_select_merged_b = $signed(shiftValPos_uid44_fpExpETest_bit_select_merged_in[2:0]);
    assign shiftValPos_uid44_fpExpETest_bit_select_merged_c = $signed(shiftValPos_uid44_fpExpETest_bit_select_merged_in[7:3]);

    // redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1(DELAY,329)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q <= shiftValPos_uid44_fpExpETest_bit_select_merged_b;
        end
    end

    // rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged(BITSELECT,325)@1
    assign rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_b = $signed(redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q[1:0]);
    assign rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c = $signed(redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q[2:2]);

    // cstZeroWE_uid14_fpExpETest(CONSTANT,13)
    assign cstZeroWE_uid14_fpExpETest_q = 8'b00000000;

    // shiftUdf_uid46_fpExpETest(LOGICAL,45)@0 + 1
    assign shiftUdf_uid46_fpExpETest_qi = $unsigned(shiftValPos_uid44_fpExpETest_bit_select_merged_c != 5'b00000 ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    shiftUdf_uid46_fpExpETest_delay ( .xin(shiftUdf_uid46_fpExpETest_qi), .xout(shiftUdf_uid46_fpExpETest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // mergedMUXes0(SELECTOR,327)@1
    always_comb 
    begin
        mergedMUXes0_q = 8'b0;
        if (rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q == 1'b1)
        begin
            mergedMUXes0_q = $signed(rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q);
        end
        if (rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c == 1'b1)
        begin
            mergedMUXes0_q = $signed(rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q);
        end
        if (shiftUdf_uid46_fpExpETest_q == 1'b1)
        begin
            mergedMUXes0_q = $signed(cstZeroWE_uid14_fpExpETest_q);
        end
    end

    // xv0_uid238_eP_uid50_fpExpETest_bit_select_merged(BITSELECT,322)@1
    assign xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_b = $signed(mergedMUXes0_q[4:0]);
    assign xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_c = $signed(mergedMUXes0_q[7:5]);

    // p0_uid241_eP_uid50_fpExpETest(LOOKUP,240)@1 + 1
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            p0_uid241_eP_uid50_fpExpETest_q <= 9'b000000000;
        end
        else if (en == 1'b1)
        begin
            unique case (xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_b)
                5'b00000 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b000000000;
                5'b00001 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b000001011;
                5'b00010 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b000010111;
                5'b00011 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b000100010;
                5'b00100 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b000101110;
                5'b00101 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b000111001;
                5'b00110 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b001000101;
                5'b00111 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b001010000;
                5'b01000 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b001011100;
                5'b01001 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b001100111;
                5'b01010 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b001110011;
                5'b01011 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b001111110;
                5'b01100 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b010001010;
                5'b01101 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b010010110;
                5'b01110 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b010100001;
                5'b01111 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b010101101;
                5'b10000 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b010111000;
                5'b10001 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b011000100;
                5'b10010 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b011001111;
                5'b10011 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b011011011;
                5'b10100 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b011100110;
                5'b10101 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b011110010;
                5'b10110 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b011111101;
                5'b10111 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b100001001;
                5'b11000 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b100010100;
                5'b11001 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b100100000;
                5'b11010 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b100101100;
                5'b11011 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b100110111;
                5'b11100 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b101000011;
                5'b11101 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b101001110;
                5'b11110 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b101011010;
                5'b11111 : p0_uid241_eP_uid50_fpExpETest_q <= 9'b101100101;
                default : begin
                              // unreachable
                              p0_uid241_eP_uid50_fpExpETest_q <= 9'bxxxxxxxxx;
                          end
            endcase
        end
    end

    // p1_uid240_eP_uid50_fpExpETest(LOOKUP,239)@1 + 1
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            p1_uid240_eP_uid50_fpExpETest_q <= 13'b0000000000010;
        end
        else if (en == 1'b1)
        begin
            unique case (xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_c)
                3'b000 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0000000000010;
                3'b001 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0000101110011;
                3'b010 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0001011100100;
                3'b011 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0010001010101;
                3'b100 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0010111000111;
                3'b101 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0011100111000;
                3'b110 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0100010101001;
                3'b111 : p1_uid240_eP_uid50_fpExpETest_q <= 13'b0101000011011;
                default : begin
                              // unreachable
                              p1_uid240_eP_uid50_fpExpETest_q <= 13'bxxxxxxxxxxxxx;
                          end
            endcase
        end
    end

    // lev1_a0_uid242_eP_uid50_fpExpETest(ADD,241)@2
    assign lev1_a0_uid242_eP_uid50_fpExpETest_a = {1'b0, p1_uid240_eP_uid50_fpExpETest_q};
    assign lev1_a0_uid242_eP_uid50_fpExpETest_b = {5'b00000, p0_uid241_eP_uid50_fpExpETest_q};
    assign lev1_a0_uid242_eP_uid50_fpExpETest_o = $unsigned(lev1_a0_uid242_eP_uid50_fpExpETest_a) + $unsigned(lev1_a0_uid242_eP_uid50_fpExpETest_b);
    assign lev1_a0_uid242_eP_uid50_fpExpETest_q = $signed(lev1_a0_uid242_eP_uid50_fpExpETest_o[13:0]);

    // sOuputFormat_uid243_eP_uid50_fpExpETest(BITSELECT,242)@2
    assign sOuputFormat_uid243_eP_uid50_fpExpETest_in = lev1_a0_uid242_eP_uid50_fpExpETest_q[11:0];
    assign sOuputFormat_uid243_eP_uid50_fpExpETest_b = $signed(sOuputFormat_uid243_eP_uid50_fpExpETest_in[11:2]);

    // zEp_uid51_fpExpETest(BITJOIN,50)@2
    assign zEp_uid51_fpExpETest_q = {GND_q, sOuputFormat_uid243_eP_uid50_fpExpETest_b};

    // ePOC_uid52_fpExpETest(LOGICAL,51)@2 + 1
    assign ePOC_uid52_fpExpETest_b = $unsigned({{10{signX_uid7_fpExpETest_b[0]}}, signX_uid7_fpExpETest_b});
    assign ePOC_uid52_fpExpETest_qi = zEp_uid51_fpExpETest_q ^ ePOC_uid52_fpExpETest_b;
    dspba_delay_ver #( .width(11), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    ePOC_uid52_fpExpETest_delay ( .xin(ePOC_uid52_fpExpETest_qi), .xout(ePOC_uid52_fpExpETest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // eP2CWRnd_uid57_fpExpETest(ADD,56)@3
    assign eP2CWRnd_uid57_fpExpETest_a = $unsigned({{2{ePOC_uid52_fpExpETest_q[10]}}, ePOC_uid52_fpExpETest_q});
    assign eP2CWRnd_uid57_fpExpETest_b = $unsigned({11'b00000000000, Rnd2C_uid54_fpExpETest_q});
    assign eP2CWRnd_uid57_fpExpETest_o = $unsigned($signed(eP2CWRnd_uid57_fpExpETest_a) + $signed(eP2CWRnd_uid57_fpExpETest_b));
    assign eP2CWRnd_uid57_fpExpETest_q = $signed(eP2CWRnd_uid57_fpExpETest_o[11:0]);

    // expTmp_uid58_fpExpETest(BITSELECT,57)@3
    assign expTmp_uid58_fpExpETest_in = $unsigned(eP2CWRnd_uid57_fpExpETest_q[9:0]);
    assign expTmp_uid58_fpExpETest_b = expTmp_uid58_fpExpETest_in[9:2];

    // floatTable_kPPreZHigh_uid63_fpExpETest_lutmem(DUALMEM,271)@3 + 2
    assign floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_aa = expTmp_uid58_fpExpETest_b;
    assign floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(32),
        .widthad_a(8),
        .numwords_a(256),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_kPPreZHigh_uid63_fpExpETest_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_dmem (
        .clocken0(floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ena_NotRstA),
        .sclr(floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_reset0),
        .clock0(clk),
        .address_a(floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_aa),
        .q_a(floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ir),
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
    assign floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r = $signed(floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ir[31:0]);

    // bit7_uid59_fpExpETest(BITSELECT,58)@3
    assign bit7_uid59_fpExpETest_in = $unsigned(eP2CWRnd_uid57_fpExpETest_q[10:0]);
    assign bit7_uid59_fpExpETest_b = bit7_uid59_fpExpETest_in[10:10];

    // invBit7_uid60_fpExpETest(LOGICAL,59)@3
    assign invBit7_uid60_fpExpETest_q = $signed(~ (bit7_uid59_fpExpETest_b));

    // bit8_uid61_fpExpETest(BITSELECT,60)@3
    assign bit8_uid61_fpExpETest_in = $unsigned(eP2CWRnd_uid57_fpExpETest_q[9:0]);
    assign bit8_uid61_fpExpETest_b = bit8_uid61_fpExpETest_in[9:9];

    // maxExpCond_uid62_fpExpETest(LOGICAL,61)@3 + 1
    assign maxExpCond_uid62_fpExpETest_qi = bit8_uid61_fpExpETest_b & invBit7_uid60_fpExpETest_q;
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    maxExpCond_uid62_fpExpETest_delay ( .xin(maxExpCond_uid62_fpExpETest_qi), .xout(maxExpCond_uid62_fpExpETest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist15_maxExpCond_uid62_fpExpETest_q_2(DELAY,343)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist15_maxExpCond_uid62_fpExpETest_q_2_q <= maxExpCond_uid62_fpExpETest_q;
        end
    end

    // kPZHigh_uid73_fpExpETest(MUX,72)@5
    assign kPZHigh_uid73_fpExpETest_s = redist15_maxExpCond_uid62_fpExpETest_q_2_q;
    always_comb 
    begin
        unique case (kPZHigh_uid73_fpExpETest_s)
            1'b0 : kPZHigh_uid73_fpExpETest_q = floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r;
            1'b1 : kPZHigh_uid73_fpExpETest_q = cste128h_uid72_fpExpETest_b_const_q;
            default : kPZHigh_uid73_fpExpETest_q = 32'b0;
        endcase
    end

    // ySign_uid77_fpExpETest(BITSELECT,76)@5
    assign ySign_uid77_fpExpETest_b = kPZHigh_uid73_fpExpETest_q[31:31];

    // invYSign_uid80_fpExpETest(LOGICAL,79)@5
    assign invYSign_uid80_fpExpETest_q = $signed(~ (ySign_uid77_fpExpETest_b));

    // exp_uid79_fpExpETest(BITSELECT,78)@5
    assign exp_uid79_fpExpETest_in = kPZHigh_uid73_fpExpETest_q[30:0];
    assign exp_uid79_fpExpETest_b = $signed(exp_uid79_fpExpETest_in[30:23]);

    // fraction_uid78_fpExpETest(BITSELECT,77)@5
    assign fraction_uid78_fpExpETest_in = kPZHigh_uid73_fpExpETest_q[22:0];
    assign fraction_uid78_fpExpETest_b = $signed(fraction_uid78_fpExpETest_in[22:0]);

    // minusY_uid81_fpExpETest(BITJOIN,80)@5
    assign minusY_uid81_fpExpETest_q = {invYSign_uid80_fpExpETest_q, exp_uid79_fpExpETest_b, fraction_uid78_fpExpETest_b};

    // yP0_uid82_fpExpETest_impl(FPCOLUMN,273)@5
    // out q0@8
    assign yP0_uid82_fpExpETest_impl_ax0 = $unsigned(minusY_uid81_fpExpETest_q);
    assign yP0_uid82_fpExpETest_impl_ay0 = redist23_xIn_a_5_q;
    assign yP0_uid82_fpExpETest_impl_reset0 = 1'b0;
    assign yP0_uid82_fpExpETest_impl_ena0 = en[0] | yP0_uid82_fpExpETest_impl_reset0;
    tennm_fp_mac #(
        .operation_mode("fp32_add"),
        .fp32_adder_a_clken("0"),
        .fp32_adder_b_clken("0"),
        .adder_input_clken("0"),
        .output_clken("0"),
        .clear_type("none")
    ) yP0_uid82_fpExpETest_impl_DSP0 (
        .clk(clk),
        .ena({ 1'b0, 1'b0, yP0_uid82_fpExpETest_impl_ena0 }),
        .clr({ yP0_uid82_fpExpETest_impl_reset0, yP0_uid82_fpExpETest_impl_reset0 }),
        .fp32_adder_a(yP0_uid82_fpExpETest_impl_ax0),
        .fp32_adder_b(yP0_uid82_fpExpETest_impl_ay0),
        .fp32_result(yP0_uid82_fpExpETest_impl_q0),
        .accumulate(),
        .fp16_mult_top_a(),
        .fp16_mult_top_b(),
        .fp16_mult_bot_a(),
        .fp16_mult_bot_b(),
        .fp32_mult_a(),
        .fp32_mult_b(),
        .dfxlfsrena(),
        .dfxmisrena(),
        .fp32_chainin(),
        .fp32_chainout(),
        .fp32_adder_inexact(),
        .fp32_adder_invalid(),
        .fp32_adder_overflow(),
        .fp32_adder_underflow(),
        .fp32_mult_inexact(),
        .fp32_mult_invalid(),
        .fp32_mult_overflow(),
        .fp32_mult_underflow(),
        .fp16_adder_inexact(),
        .fp16_adder_invalid(),
        .fp16_adder_infinite(),
        .fp16_adder_zero(),
        .fp16_adder_overflow(),
        .fp16_adder_underflow(),
        .fp16_mult_top_inexact(),
        .fp16_mult_top_invalid(),
        .fp16_mult_top_infinite(),
        .fp16_mult_top_zero(),
        .fp16_mult_top_overflow(),
        .fp16_mult_top_underflow(),
        .fp16_mult_bot_inexact(),
        .fp16_mult_bot_invalid(),
        .fp16_mult_bot_infinite(),
        .fp16_mult_bot_zero(),
        .fp16_mult_bot_overflow(),
        .fp16_mult_bot_underflow()
    );

    // redist9_yP0_uid82_fpExpETest_impl_q0_1(DELAY,337)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist9_yP0_uid82_fpExpETest_impl_q0_1_q <= yP0_uid82_fpExpETest_impl_q0;
        end
    end

    // cste128l_uid75_fpExpETest_b_const(CONSTANT,245)
    assign cste128l_uid75_fpExpETest_b_const_q = 32'b00110110111101111101000111001111;

    // redist17_expTmp_uid58_fpExpETest_b_4(DELAY,345)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist17_expTmp_uid58_fpExpETest_b_4_delay_0 <= $unsigned(expTmp_uid58_fpExpETest_b);
            redist17_expTmp_uid58_fpExpETest_b_4_delay_1 <= redist17_expTmp_uid58_fpExpETest_b_4_delay_0;
            redist17_expTmp_uid58_fpExpETest_b_4_delay_2 <= redist17_expTmp_uid58_fpExpETest_b_4_delay_1;
            redist17_expTmp_uid58_fpExpETest_b_4_q <= $signed(redist17_expTmp_uid58_fpExpETest_b_4_delay_2);
        end
    end

    // floatTable_kPPreZLow_uid67_fpExpETest_lutmem(DUALMEM,272)@7 + 2
    assign floatTable_kPPreZLow_uid67_fpExpETest_lutmem_aa = redist17_expTmp_uid58_fpExpETest_b_4_q;
    assign floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign floatTable_kPPreZLow_uid67_fpExpETest_lutmem_reset0 = areset;
    altera_syncram #(
        .ram_block_type("M20K"),
        .operation_mode("ROM"),
        .width_a(32),
        .widthad_a(8),
        .numwords_a(256),
        .lpm_type("altera_syncram"),
        .width_byteena_a(1),
        .outdata_reg_a("CLOCK0"),
        .outdata_sclr_a("SCLEAR"),
        .clock_enable_input_a("NORMAL"),
        .power_up_uninitialized("FALSE"),
        .init_file("fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_kPPreZLow_uid67_fpExpETest_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) floatTable_kPPreZLow_uid67_fpExpETest_lutmem_dmem (
        .clocken0(floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ena_NotRstA),
        .sclr(floatTable_kPPreZLow_uid67_fpExpETest_lutmem_reset0),
        .clock0(clk),
        .address_a(floatTable_kPPreZLow_uid67_fpExpETest_lutmem_aa),
        .q_a(floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ir),
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
    assign floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r = $signed(floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ir[31:0]);

    // redist16_maxExpCond_uid62_fpExpETest_q_6(DELAY,344)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist16_maxExpCond_uid62_fpExpETest_q_6_delay_0 <= $unsigned(redist15_maxExpCond_uid62_fpExpETest_q_2_q);
            redist16_maxExpCond_uid62_fpExpETest_q_6_delay_1 <= redist16_maxExpCond_uid62_fpExpETest_q_6_delay_0;
            redist16_maxExpCond_uid62_fpExpETest_q_6_delay_2 <= redist16_maxExpCond_uid62_fpExpETest_q_6_delay_1;
            redist16_maxExpCond_uid62_fpExpETest_q_6_q <= $signed(redist16_maxExpCond_uid62_fpExpETest_q_6_delay_2);
        end
    end

    // kPZLow_uid76_fpExpETest(MUX,75)@9
    assign kPZLow_uid76_fpExpETest_s = redist16_maxExpCond_uid62_fpExpETest_q_6_q;
    always_comb 
    begin
        unique case (kPZLow_uid76_fpExpETest_s)
            1'b0 : kPZLow_uid76_fpExpETest_q = floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r;
            1'b1 : kPZLow_uid76_fpExpETest_q = cste128l_uid75_fpExpETest_b_const_q;
            default : kPZLow_uid76_fpExpETest_q = 32'b0;
        endcase
    end

    // ySign_uid83_fpExpETest(BITSELECT,82)@9
    assign ySign_uid83_fpExpETest_b = kPZLow_uid76_fpExpETest_q[31:31];

    // invYSign_uid86_fpExpETest(LOGICAL,85)@9
    assign invYSign_uid86_fpExpETest_q = $signed(~ (ySign_uid83_fpExpETest_b));

    // exp_uid85_fpExpETest(BITSELECT,84)@9
    assign exp_uid85_fpExpETest_in = kPZLow_uid76_fpExpETest_q[30:0];
    assign exp_uid85_fpExpETest_b = $signed(exp_uid85_fpExpETest_in[30:23]);

    // fraction_uid84_fpExpETest(BITSELECT,83)@9
    assign fraction_uid84_fpExpETest_in = kPZLow_uid76_fpExpETest_q[22:0];
    assign fraction_uid84_fpExpETest_b = $signed(fraction_uid84_fpExpETest_in[22:0]);

    // minusY_uid87_fpExpETest(BITJOIN,86)@9
    assign minusY_uid87_fpExpETest_q = {invYSign_uid86_fpExpETest_q, exp_uid85_fpExpETest_b, fraction_uid84_fpExpETest_b};

    // yP_uid88_fpExpETest_impl(FPCOLUMN,275)@9
    // out q0@12
    assign yP_uid88_fpExpETest_impl_ax0 = $unsigned(minusY_uid87_fpExpETest_q);
    assign yP_uid88_fpExpETest_impl_ay0 = redist9_yP0_uid82_fpExpETest_impl_q0_1_q;
    assign yP_uid88_fpExpETest_impl_reset0 = 1'b0;
    assign yP_uid88_fpExpETest_impl_ena0 = en[0] | yP_uid88_fpExpETest_impl_reset0;
    tennm_fp_mac #(
        .operation_mode("fp32_add"),
        .fp32_adder_a_clken("0"),
        .fp32_adder_b_clken("0"),
        .adder_input_clken("0"),
        .output_clken("0"),
        .clear_type("none")
    ) yP_uid88_fpExpETest_impl_DSP0 (
        .clk(clk),
        .ena({ 1'b0, 1'b0, yP_uid88_fpExpETest_impl_ena0 }),
        .clr({ yP_uid88_fpExpETest_impl_reset0, yP_uid88_fpExpETest_impl_reset0 }),
        .fp32_adder_a(yP_uid88_fpExpETest_impl_ax0),
        .fp32_adder_b(yP_uid88_fpExpETest_impl_ay0),
        .fp32_result(yP_uid88_fpExpETest_impl_q0),
        .accumulate(),
        .fp16_mult_top_a(),
        .fp16_mult_top_b(),
        .fp16_mult_bot_a(),
        .fp16_mult_bot_b(),
        .fp32_mult_a(),
        .fp32_mult_b(),
        .dfxlfsrena(),
        .dfxmisrena(),
        .fp32_chainin(),
        .fp32_chainout(),
        .fp32_adder_inexact(),
        .fp32_adder_invalid(),
        .fp32_adder_overflow(),
        .fp32_adder_underflow(),
        .fp32_mult_inexact(),
        .fp32_mult_invalid(),
        .fp32_mult_overflow(),
        .fp32_mult_underflow(),
        .fp16_adder_inexact(),
        .fp16_adder_invalid(),
        .fp16_adder_infinite(),
        .fp16_adder_zero(),
        .fp16_adder_overflow(),
        .fp16_adder_underflow(),
        .fp16_mult_top_inexact(),
        .fp16_mult_top_invalid(),
        .fp16_mult_top_infinite(),
        .fp16_mult_top_zero(),
        .fp16_mult_top_overflow(),
        .fp16_mult_top_underflow(),
        .fp16_mult_bot_inexact(),
        .fp16_mult_bot_invalid(),
        .fp16_mult_bot_infinite(),
        .fp16_mult_bot_zero(),
        .fp16_mult_bot_overflow(),
        .fp16_mult_bot_underflow()
    );

    // signYP_uid91_fpExpETest(BITSELECT,90)@12
    assign signYP_uid91_fpExpETest_b = yP_uid88_fpExpETest_impl_q0[31:31];

    // redist14_signYP_uid91_fpExpETest_b_12(DELAY,342)
    dspba_delay_ver #( .width(1), .depth(12), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist14_signYP_uid91_fpExpETest_b_12 ( .xin(signYP_uid91_fpExpETest_b), .xout(redist14_signYP_uid91_fpExpETest_b_12_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt(COUNTER,357)
    // low=0, high=8, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i <= 4'd0;
            redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i == 4'd7)
            begin
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq <= 1'b0;
            end
            if (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq == 1'b1)
            begin
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i <= $unsigned(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i) + $unsigned(4'd8);
            end
            else
            begin
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i <= $unsigned(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i) + $unsigned(4'd1);
            end
        end
    end
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q = $signed(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i[3:0]);

    // redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux(MUX,358)
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s = en;
    always_comb 
    begin
        unique case (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s)
            1'b0 : redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q = redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q;
            1'b1 : redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q = redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q;
            default : redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q = 4'b0;
        endcase
    end

    // rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest(BITSELECT,290)@13
    assign rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest_b = $signed(rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q[7:4]);

    // rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest(BITJOIN,292)@13
    assign rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest_q = {rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q, rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest_b};

    // rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest(BITSELECT,285)@12
    assign rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest_b = $signed(fxpAPreAlign_uid95_fpExpETest_q[7:3]);

    // rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest(BITJOIN,287)@12
    assign rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest_q = {rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q, rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest_b};

    // rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest(BITSELECT,282)@12
    assign rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest_b = $signed(fxpAPreAlign_uid95_fpExpETest_q[7:2]);

    // rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest(BITJOIN,284)@12
    assign rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest_q = {rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q, rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest_b};

    // rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest(BITSELECT,279)@12
    assign rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest_b = $signed(fxpAPreAlign_uid95_fpExpETest_q[7:1]);

    // rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest(BITJOIN,281)@12
    assign rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest_q = {GND_q, rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest_b};

    // fracYP_uid89_fpExpETest(BITSELECT,88)@12
    assign fracYP_uid89_fpExpETest_b = $signed(yP_uid88_fpExpETest_impl_q0[22:0]);

    // fracYPTop_uid93_fpExpETest(BITSELECT,92)@12
    assign fracYPTop_uid93_fpExpETest_b = $signed(fracYP_uid89_fpExpETest_b[22:16]);

    // fxpAPreAlign_uid95_fpExpETest(BITJOIN,94)@12
    assign fxpAPreAlign_uid95_fpExpETest_q = {VCC_q, fracYPTop_uid93_fpExpETest_b};

    // expYP_uid90_fpExpETest(BITSELECT,89)@12
    assign expYP_uid90_fpExpETest_b = $signed(yP_uid88_fpExpETest_impl_q0[30:23]);

    // cstBiasM1_uid10_fpExpETest(CONSTANT,9)
    assign cstBiasM1_uid10_fpExpETest_q = 8'b01111110;

    // shiftValFxpA_uid96_fpExpETest(SUB,95)@12
    assign shiftValFxpA_uid96_fpExpETest_a = $unsigned({1'b0, cstBiasM1_uid10_fpExpETest_q});
    assign shiftValFxpA_uid96_fpExpETest_b = $unsigned({1'b0, expYP_uid90_fpExpETest_b});
    assign shiftValFxpA_uid96_fpExpETest_o = $unsigned($signed(shiftValFxpA_uid96_fpExpETest_a) - $signed(shiftValFxpA_uid96_fpExpETest_b));
    assign shiftValFxpA_uid96_fpExpETest_q = $signed(shiftValFxpA_uid96_fpExpETest_o[8:0]);

    // shiftValFxpAR_uid97_fpExpETest(BITSELECT,96)@12
    assign shiftValFxpAR_uid97_fpExpETest_in = shiftValFxpA_uid96_fpExpETest_q[3:0];
    assign shiftValFxpAR_uid97_fpExpETest_b = $signed(shiftValFxpAR_uid97_fpExpETest_in[3:0]);

    // rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged(BITSELECT,324)@12
    assign rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_b = $signed(shiftValFxpAR_uid97_fpExpETest_b[1:0]);
    assign rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c = $signed(shiftValFxpAR_uid97_fpExpETest_b[3:2]);

    // rightShiftStage0_uid290_fxpA_uid98_fpExpETest(MUX,289)@12 + 1
    assign rightShiftStage0_uid290_fxpA_uid98_fpExpETest_s = rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_b;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= 8'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (rightShiftStage0_uid290_fxpA_uid98_fpExpETest_s)
                2'b00 : rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= fxpAPreAlign_uid95_fpExpETest_q;
                2'b01 : rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest_q;
                2'b10 : rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest_q;
                2'b11 : rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest_q;
                default : rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= 8'b0;
            endcase
        end
    end

    // redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1(DELAY,328)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_q <= rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c;
        end
    end

    // rightShiftStage1_uid297_fxpA_uid98_fpExpETest(MUX,296)@13 + 1
    assign rightShiftStage1_uid297_fxpA_uid98_fpExpETest_s = redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_q;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= 8'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (rightShiftStage1_uid297_fxpA_uid98_fpExpETest_s)
                2'b00 : rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q;
                2'b01 : rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest_q;
                2'b10 : rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= cstZeroWE_uid14_fpExpETest_q;
                2'b11 : rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= cstZeroWE_uid14_fpExpETest_q;
                default : rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= 8'b0;
            endcase
        end
    end

    // redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr(REG,359)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q <= 4'b1000;
        end
        else
        begin
            redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q;
        end
    end

    // redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem(DUALMEM,356)
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ia = $unsigned(rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q);
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_aa = redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q;
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ab = redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q;
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(8),
        .widthad_a(4),
        .numwords_a(9),
        .width_b(8),
        .widthad_b(4),
        .numwords_b(9),
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
    ) redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_dmem (
        .clocken1(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_aa),
        .data_a(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ia),
        .wren_a(en[0]),
        .address_b(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ab),
        .q_b(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_iq),
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
    assign redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_q = $signed(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_iq[7:0]);

    // addrEATable_uid99_fpExpETest(BITJOIN,98)@24
    assign addrEATable_uid99_fpExpETest_q = {redist14_signYP_uid91_fpExpETest_b_12_q, redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_q};

    // floatTable_eA_uid100_fpExpETest_lutmem(DUALMEM,298)@24 + 2
    assign floatTable_eA_uid100_fpExpETest_lutmem_aa = addrEATable_uid99_fpExpETest_q;
    assign floatTable_eA_uid100_fpExpETest_lutmem_ena_NotRstA = ~ (areset) & en[0];
    assign floatTable_eA_uid100_fpExpETest_lutmem_reset0 = areset;
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
        .init_file("fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_eA_uid100_fpExpETest_lutmem.hex"),
        .init_file_layout("PORT_A"),
        .intended_device_family("Agilex 5")
    ) floatTable_eA_uid100_fpExpETest_lutmem_dmem (
        .clocken0(floatTable_eA_uid100_fpExpETest_lutmem_ena_NotRstA),
        .sclr(floatTable_eA_uid100_fpExpETest_lutmem_reset0),
        .clock0(clk),
        .address_a(floatTable_eA_uid100_fpExpETest_lutmem_aa),
        .q_a(floatTable_eA_uid100_fpExpETest_lutmem_ir),
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
    assign floatTable_eA_uid100_fpExpETest_lutmem_r = $signed(floatTable_eA_uid100_fpExpETest_lutmem_ir[31:0]);

    // udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319(CONSTANT,318)
    assign udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q = 5'b01111;

    // expYPBottom_uid92_fpExpETest_bit_select_merged(BITSELECT,323)@12
    assign expYPBottom_uid92_fpExpETest_bit_select_merged_b = $signed(expYP_uid90_fpExpETest_b[2:0]);
    assign expYPBottom_uid92_fpExpETest_bit_select_merged_c = $signed(expYP_uid90_fpExpETest_b[7:3]);

    // udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321(COMPARE,320)@12
    assign udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_a = $unsigned({3'b000, expYPBottom_uid92_fpExpETest_bit_select_merged_c});
    assign udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_b = $unsigned({{3{udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q[4]}}, udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q});
    assign udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_o = $unsigned($signed(udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_a) - $signed(udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_b));
    assign udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c[0] = udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_o[7];

    // redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14(DELAY,330)
    dspba_delay_ver #( .width(1), .depth(14), .reset_kind("NONE"), .phase(0), .modulus(1) )
    redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14 ( .xin(udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c), .xout(redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // eAPostUdfA_uid108_fpExpETest(MUX,107)@26 + 1
    assign eAPostUdfA_uid108_fpExpETest_s = redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14_q;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            eAPostUdfA_uid108_fpExpETest_q <= 32'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (eAPostUdfA_uid108_fpExpETest_s)
                1'b0 : eAPostUdfA_uid108_fpExpETest_q <= floatTable_eA_uid100_fpExpETest_lutmem_r;
                1'b1 : eAPostUdfA_uid108_fpExpETest_q <= oneFP_uid107_fpExpETest_b_const_q;
                default : eAPostUdfA_uid108_fpExpETest_q <= 32'b0;
            endcase
        end
    end

    // redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt(COUNTER,353)
    // low=0, high=3, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i <= 2'd0;
        end
        else if (en == 1'b1)
        begin
            redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i <= $unsigned(redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i) + $unsigned(2'd1);
        end
    end
    assign redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q = $signed(redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i[1:0]);

    // redist6_b_uid120_fpExpETest_impl_q0_6_rdmux(MUX,354)
    assign redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s = en;
    always_comb 
    begin
        unique case (redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s)
            1'b0 : redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q = redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q;
            1'b1 : redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q = redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q;
            default : redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q = 2'b0;
        endcase
    end

    // redist8_yP_uid88_fpExpETest_impl_q0_1(DELAY,336)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist8_yP_uid88_fpExpETest_impl_q0_1_q <= yP_uid88_fpExpETest_impl_q0;
        end
    end

    // newExpA_uid113_fpExpETest(MUX,112)@12
    assign newExpA_uid113_fpExpETest_s = udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c;
    always_comb 
    begin
        unique case (newExpA_uid113_fpExpETest_s)
            1'b0 : newExpA_uid113_fpExpETest_q = expYP_uid90_fpExpETest_b;
            1'b1 : newExpA_uid113_fpExpETest_q = cstZeroWE_uid14_fpExpETest_q;
            default : newExpA_uid113_fpExpETest_q = 8'b0;
        endcase
    end

    // maskAFP_uid109_fpExpETest(LOOKUP,108)@12
    always_comb 
    begin
        // Begin reserved scope level
        unique case (expYPBottom_uid92_fpExpETest_bit_select_merged_b)
            3'b000 : maskAFP_uid109_fpExpETest_q = 7'b1000000;
            3'b001 : maskAFP_uid109_fpExpETest_q = 7'b1100000;
            3'b010 : maskAFP_uid109_fpExpETest_q = 7'b1110000;
            3'b011 : maskAFP_uid109_fpExpETest_q = 7'b1111000;
            3'b100 : maskAFP_uid109_fpExpETest_q = 7'b1111100;
            3'b101 : maskAFP_uid109_fpExpETest_q = 7'b1111110;
            3'b110 : maskAFP_uid109_fpExpETest_q = 7'b1111111;
            3'b111 : maskAFP_uid109_fpExpETest_q = 7'b0000000;
            default : begin
                          // unreachable
                          maskAFP_uid109_fpExpETest_q = 7'bxxxxxxx;
                      end
        endcase
        // End reserved scope level
    end

    // fracYPTopPostMask_uid110_fpExpETest(LOGICAL,109)@12
    assign fracYPTopPostMask_uid110_fpExpETest_q = $signed(fracYPTop_uid93_fpExpETest_b & maskAFP_uid109_fpExpETest_q);

    // cst16z_uid111_fpExpETest(CONSTANT,110)
    assign cst16z_uid111_fpExpETest_q = 16'b0000000000000000;

    // fracAFull_uid112_fpExpETest(BITJOIN,111)@12
    assign fracAFull_uid112_fpExpETest_q = {fracYPTopPostMask_uid110_fpExpETest_q, cst16z_uid111_fpExpETest_q};

    // a_uid114_fpExpETest(BITJOIN,113)@12
    assign a_uid114_fpExpETest_q = {signYP_uid91_fpExpETest_b, newExpA_uid113_fpExpETest_q, fracAFull_uid112_fpExpETest_q};

    // ySign_uid115_fpExpETest(BITSELECT,114)@12
    assign ySign_uid115_fpExpETest_b = a_uid114_fpExpETest_q[31:31];

    // invYSign_uid118_fpExpETest(LOGICAL,117)@12
    assign invYSign_uid118_fpExpETest_q = $signed(~ (ySign_uid115_fpExpETest_b));

    // exp_uid117_fpExpETest(BITSELECT,116)@12
    assign exp_uid117_fpExpETest_in = a_uid114_fpExpETest_q[30:0];
    assign exp_uid117_fpExpETest_b = $signed(exp_uid117_fpExpETest_in[30:23]);

    // fraction_uid116_fpExpETest(BITSELECT,115)@12
    assign fraction_uid116_fpExpETest_in = a_uid114_fpExpETest_q[22:0];
    assign fraction_uid116_fpExpETest_b = $signed(fraction_uid116_fpExpETest_in[22:0]);

    // minusY_uid119_fpExpETest(BITJOIN,118)@12
    assign minusY_uid119_fpExpETest_q = {invYSign_uid118_fpExpETest_q, exp_uid117_fpExpETest_b, fraction_uid116_fpExpETest_b};

    // redist13_minusY_uid119_fpExpETest_q_1(DELAY,341)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist13_minusY_uid119_fpExpETest_q_1_q <= minusY_uid119_fpExpETest_q;
        end
    end

    // b_uid120_fpExpETest_impl(FPCOLUMN,301)@13
    // out q0@16
    assign b_uid120_fpExpETest_impl_ax0 = $unsigned(redist13_minusY_uid119_fpExpETest_q_1_q);
    assign b_uid120_fpExpETest_impl_ay0 = redist8_yP_uid88_fpExpETest_impl_q0_1_q;
    assign b_uid120_fpExpETest_impl_reset0 = 1'b0;
    assign b_uid120_fpExpETest_impl_ena0 = en[0] | b_uid120_fpExpETest_impl_reset0;
    tennm_fp_mac #(
        .operation_mode("fp32_add"),
        .fp32_adder_a_clken("0"),
        .fp32_adder_b_clken("0"),
        .adder_input_clken("0"),
        .output_clken("0"),
        .clear_type("none")
    ) b_uid120_fpExpETest_impl_DSP0 (
        .clk(clk),
        .ena({ 1'b0, 1'b0, b_uid120_fpExpETest_impl_ena0 }),
        .clr({ b_uid120_fpExpETest_impl_reset0, b_uid120_fpExpETest_impl_reset0 }),
        .fp32_adder_a(b_uid120_fpExpETest_impl_ax0),
        .fp32_adder_b(b_uid120_fpExpETest_impl_ay0),
        .fp32_result(b_uid120_fpExpETest_impl_q0),
        .accumulate(),
        .fp16_mult_top_a(),
        .fp16_mult_top_b(),
        .fp16_mult_bot_a(),
        .fp16_mult_bot_b(),
        .fp32_mult_a(),
        .fp32_mult_b(),
        .dfxlfsrena(),
        .dfxmisrena(),
        .fp32_chainin(),
        .fp32_chainout(),
        .fp32_adder_inexact(),
        .fp32_adder_invalid(),
        .fp32_adder_overflow(),
        .fp32_adder_underflow(),
        .fp32_mult_inexact(),
        .fp32_mult_invalid(),
        .fp32_mult_overflow(),
        .fp32_mult_underflow(),
        .fp16_adder_inexact(),
        .fp16_adder_invalid(),
        .fp16_adder_infinite(),
        .fp16_adder_zero(),
        .fp16_adder_overflow(),
        .fp16_adder_underflow(),
        .fp16_mult_top_inexact(),
        .fp16_mult_top_invalid(),
        .fp16_mult_top_infinite(),
        .fp16_mult_top_zero(),
        .fp16_mult_top_overflow(),
        .fp16_mult_top_underflow(),
        .fp16_mult_bot_inexact(),
        .fp16_mult_bot_invalid(),
        .fp16_mult_bot_infinite(),
        .fp16_mult_bot_zero(),
        .fp16_mult_bot_overflow(),
        .fp16_mult_bot_underflow()
    );

    // redist5_b_uid120_fpExpETest_impl_q0_1(DELAY,333)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist5_b_uid120_fpExpETest_impl_q0_1_q <= b_uid120_fpExpETest_impl_q0;
        end
    end

    // redist6_b_uid120_fpExpETest_impl_q0_6_wraddr(REG,355)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q <= 2'b11;
        end
        else
        begin
            redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q <= redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q;
        end
    end

    // redist6_b_uid120_fpExpETest_impl_q0_6_mem(DUALMEM,352)
    assign redist6_b_uid120_fpExpETest_impl_q0_6_mem_ia = $unsigned(redist5_b_uid120_fpExpETest_impl_q0_1_q);
    assign redist6_b_uid120_fpExpETest_impl_q0_6_mem_aa = redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q;
    assign redist6_b_uid120_fpExpETest_impl_q0_6_mem_ab = redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q;
    assign redist6_b_uid120_fpExpETest_impl_q0_6_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(32),
        .widthad_a(2),
        .numwords_a(4),
        .width_b(32),
        .widthad_b(2),
        .numwords_b(4),
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
    ) redist6_b_uid120_fpExpETest_impl_q0_6_mem_dmem (
        .clocken1(redist6_b_uid120_fpExpETest_impl_q0_6_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist6_b_uid120_fpExpETest_impl_q0_6_mem_aa),
        .data_a(redist6_b_uid120_fpExpETest_impl_q0_6_mem_ia),
        .wren_a(en[0]),
        .address_b(redist6_b_uid120_fpExpETest_impl_q0_6_mem_ab),
        .q_b(redist6_b_uid120_fpExpETest_impl_q0_6_mem_iq),
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
    assign redist6_b_uid120_fpExpETest_impl_q0_6_mem_q = $signed(redist6_b_uid120_fpExpETest_impl_q0_6_mem_iq[31:0]);

    // cstHalfFP_uid122_fpExpETest_b_const(CONSTANT,247)
    assign cstHalfFP_uid122_fpExpETest_b_const_q = 32'b00111111000000000000000000000000;

    // oPBo2_uid123_fpExpETest_impl(FPCOLUMN,303)@17
    // out q0@21
    assign oPBo2_uid123_fpExpETest_impl_ax0 = $unsigned(oneFP_uid107_fpExpETest_b_const_q);
    assign oPBo2_uid123_fpExpETest_impl_ay0 = cstHalfFP_uid122_fpExpETest_b_const_q;
    assign oPBo2_uid123_fpExpETest_impl_az0 = redist5_b_uid120_fpExpETest_impl_q0_1_q;
    assign oPBo2_uid123_fpExpETest_impl_reset0 = 1'b0;
    assign oPBo2_uid123_fpExpETest_impl_ena0 = en[0] | oPBo2_uid123_fpExpETest_impl_reset0;
    tennm_fp_mac #(
        .operation_mode("fp32_mult_add"),
        .fp32_adder_a_clken("0"),
        .fp32_mult_a_clken("0"),
        .fp32_mult_b_clken("0"),
        .mult_2nd_pipeline_clken("0"),
        .adder_input_clken("0"),
        .fp32_adder_a_chainin_pl_clken("0"),
        .output_clken("0"),
        .clear_type("none")
    ) oPBo2_uid123_fpExpETest_impl_DSP0 (
        .clk(clk),
        .ena({ 1'b0, 1'b0, oPBo2_uid123_fpExpETest_impl_ena0 }),
        .clr({ oPBo2_uid123_fpExpETest_impl_reset0, oPBo2_uid123_fpExpETest_impl_reset0 }),
        .fp32_adder_a(oPBo2_uid123_fpExpETest_impl_ax0),
        .fp32_mult_a(oPBo2_uid123_fpExpETest_impl_ay0),
        .fp32_mult_b(oPBo2_uid123_fpExpETest_impl_az0),
        .fp32_result(oPBo2_uid123_fpExpETest_impl_q0),
        .accumulate(),
        .fp16_mult_top_a(),
        .fp16_mult_top_b(),
        .fp16_mult_bot_a(),
        .fp16_mult_bot_b(),
        .fp32_adder_b(),
        .dfxlfsrena(),
        .dfxmisrena(),
        .fp32_chainin(),
        .fp32_chainout(),
        .fp32_adder_inexact(),
        .fp32_adder_invalid(),
        .fp32_adder_overflow(),
        .fp32_adder_underflow(),
        .fp32_mult_inexact(),
        .fp32_mult_invalid(),
        .fp32_mult_overflow(),
        .fp32_mult_underflow(),
        .fp16_adder_inexact(),
        .fp16_adder_invalid(),
        .fp16_adder_infinite(),
        .fp16_adder_zero(),
        .fp16_adder_overflow(),
        .fp16_adder_underflow(),
        .fp16_mult_top_inexact(),
        .fp16_mult_top_invalid(),
        .fp16_mult_top_infinite(),
        .fp16_mult_top_zero(),
        .fp16_mult_top_overflow(),
        .fp16_mult_top_underflow(),
        .fp16_mult_bot_inexact(),
        .fp16_mult_bot_invalid(),
        .fp16_mult_bot_infinite(),
        .fp16_mult_bot_zero(),
        .fp16_mult_bot_overflow(),
        .fp16_mult_bot_underflow()
    );

    // redist4_oPBo2_uid123_fpExpETest_impl_q0_1(DELAY,332)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist4_oPBo2_uid123_fpExpETest_impl_q0_1_q <= oPBo2_uid123_fpExpETest_impl_q0;
        end
    end

    // eB_uid124_fpExpETest_impl(FPCOLUMN,306)@22
    // out q0@26
    assign eB_uid124_fpExpETest_impl_ax0 = $unsigned(oneFP_uid107_fpExpETest_b_const_q);
    assign eB_uid124_fpExpETest_impl_ay0 = redist4_oPBo2_uid123_fpExpETest_impl_q0_1_q;
    assign eB_uid124_fpExpETest_impl_az0 = redist6_b_uid120_fpExpETest_impl_q0_6_mem_q;
    assign eB_uid124_fpExpETest_impl_reset0 = 1'b0;
    assign eB_uid124_fpExpETest_impl_ena0 = en[0] | eB_uid124_fpExpETest_impl_reset0;
    tennm_fp_mac #(
        .operation_mode("fp32_mult_add"),
        .fp32_adder_a_clken("0"),
        .fp32_mult_a_clken("0"),
        .fp32_mult_b_clken("0"),
        .mult_2nd_pipeline_clken("0"),
        .adder_input_clken("0"),
        .fp32_adder_a_chainin_pl_clken("0"),
        .output_clken("0"),
        .clear_type("none")
    ) eB_uid124_fpExpETest_impl_DSP0 (
        .clk(clk),
        .ena({ 1'b0, 1'b0, eB_uid124_fpExpETest_impl_ena0 }),
        .clr({ eB_uid124_fpExpETest_impl_reset0, eB_uid124_fpExpETest_impl_reset0 }),
        .fp32_adder_a(eB_uid124_fpExpETest_impl_ax0),
        .fp32_mult_a(eB_uid124_fpExpETest_impl_ay0),
        .fp32_mult_b(eB_uid124_fpExpETest_impl_az0),
        .fp32_result(eB_uid124_fpExpETest_impl_q0),
        .accumulate(),
        .fp16_mult_top_a(),
        .fp16_mult_top_b(),
        .fp16_mult_bot_a(),
        .fp16_mult_bot_b(),
        .fp32_adder_b(),
        .dfxlfsrena(),
        .dfxmisrena(),
        .fp32_chainin(),
        .fp32_chainout(),
        .fp32_adder_inexact(),
        .fp32_adder_invalid(),
        .fp32_adder_overflow(),
        .fp32_adder_underflow(),
        .fp32_mult_inexact(),
        .fp32_mult_invalid(),
        .fp32_mult_overflow(),
        .fp32_mult_underflow(),
        .fp16_adder_inexact(),
        .fp16_adder_invalid(),
        .fp16_adder_infinite(),
        .fp16_adder_zero(),
        .fp16_adder_overflow(),
        .fp16_adder_underflow(),
        .fp16_mult_top_inexact(),
        .fp16_mult_top_invalid(),
        .fp16_mult_top_infinite(),
        .fp16_mult_top_zero(),
        .fp16_mult_top_overflow(),
        .fp16_mult_top_underflow(),
        .fp16_mult_bot_inexact(),
        .fp16_mult_bot_invalid(),
        .fp16_mult_bot_infinite(),
        .fp16_mult_bot_zero(),
        .fp16_mult_bot_overflow(),
        .fp16_mult_bot_underflow()
    );

    // redist3_eB_uid124_fpExpETest_impl_q0_1(DELAY,331)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist3_eB_uid124_fpExpETest_impl_q0_1_q <= eB_uid124_fpExpETest_impl_q0;
        end
    end

    // eY_uid125_fpExpETest_impl(FPCOLUMN,309)@27
    // out q0@30
    assign eY_uid125_fpExpETest_impl_ay0 = redist3_eB_uid124_fpExpETest_impl_q0_1_q;
    assign eY_uid125_fpExpETest_impl_az0 = eAPostUdfA_uid108_fpExpETest_q;
    assign eY_uid125_fpExpETest_impl_reset0 = 1'b0;
    assign eY_uid125_fpExpETest_impl_ena0 = en[0] | eY_uid125_fpExpETest_impl_reset0;
    tennm_fp_mac #(
        .operation_mode("fp32_mult"),
        .fp32_mult_a_clken("0"),
        .fp32_mult_b_clken("0"),
        .mult_2nd_pipeline_clken("0"),
        .output_clken("0"),
        .clear_type("none")
    ) eY_uid125_fpExpETest_impl_DSP0 (
        .clk(clk),
        .ena({ 1'b0, 1'b0, eY_uid125_fpExpETest_impl_ena0 }),
        .clr({ eY_uid125_fpExpETest_impl_reset0, eY_uid125_fpExpETest_impl_reset0 }),
        .fp32_mult_a(eY_uid125_fpExpETest_impl_ay0),
        .fp32_mult_b(eY_uid125_fpExpETest_impl_az0),
        .fp32_result(eY_uid125_fpExpETest_impl_q0),
        .accumulate(),
        .fp16_mult_top_a(),
        .fp16_mult_top_b(),
        .fp16_mult_bot_a(),
        .fp16_mult_bot_b(),
        .fp32_adder_a(),
        .fp32_adder_b(),
        .dfxlfsrena(),
        .dfxmisrena(),
        .fp32_chainin(),
        .fp32_chainout(),
        .fp32_adder_inexact(),
        .fp32_adder_invalid(),
        .fp32_adder_overflow(),
        .fp32_adder_underflow(),
        .fp32_mult_inexact(),
        .fp32_mult_invalid(),
        .fp32_mult_overflow(),
        .fp32_mult_underflow(),
        .fp16_adder_inexact(),
        .fp16_adder_invalid(),
        .fp16_adder_infinite(),
        .fp16_adder_zero(),
        .fp16_adder_overflow(),
        .fp16_adder_underflow(),
        .fp16_mult_top_inexact(),
        .fp16_mult_top_invalid(),
        .fp16_mult_top_infinite(),
        .fp16_mult_top_zero(),
        .fp16_mult_top_overflow(),
        .fp16_mult_top_underflow(),
        .fp16_mult_bot_inexact(),
        .fp16_mult_bot_invalid(),
        .fp16_mult_bot_infinite(),
        .fp16_mult_bot_zero(),
        .fp16_mult_bot_overflow(),
        .fp16_mult_bot_underflow()
    );

    // signEY_uid152_fpExpETest(BITSELECT,151)@30
    assign signEY_uid152_fpExpETest_b = eY_uid125_fpExpETest_impl_q0[31:31];

    // redist10_signEY_uid152_fpExpETest_b_1(DELAY,338)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist10_signEY_uid152_fpExpETest_b_1_q <= signEY_uid152_fpExpETest_b;
        end
    end

    // cstAllOWE_uid17_fpExpETest(CONSTANT,16)
    assign cstAllOWE_uid17_fpExpETest_q = 8'b11111111;

    // cstBias_uid9_fpExpETest(CONSTANT,8)
    assign cstBias_uid9_fpExpETest_q = 8'b01111111;

    // biasM2_uid129_fpExpETest(CONSTANT,128)
    assign biasM2_uid129_fpExpETest_q = 8'b01111101;

    // biasP1_uid130_fpExpETest(CONSTANT,129)
    assign biasP1_uid130_fpExpETest_q = 8'b10000000;

    // expEY_uid126_fpExpETest(BITSELECT,125)@30
    assign expEY_uid126_fpExpETest_b = $signed(eY_uid125_fpExpETest_impl_q0[30:23]);

    // lowerBitOfeY_uid127_fpExpETest(BITSELECT,126)@30
    assign lowerBitOfeY_uid127_fpExpETest_in = expEY_uid126_fpExpETest_b[1:0];
    assign lowerBitOfeY_uid127_fpExpETest_b = $signed(lowerBitOfeY_uid127_fpExpETest_in[1:0]);

    // expUpdateVal_uid131_fpExpETest(MUX,130)@30 + 1
    assign expUpdateVal_uid131_fpExpETest_s = lowerBitOfeY_uid127_fpExpETest_b;
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            expUpdateVal_uid131_fpExpETest_q <= 8'b0;
        end
        else if (en == 1'b1)
        begin
            unique case (expUpdateVal_uid131_fpExpETest_s)
                2'b00 : expUpdateVal_uid131_fpExpETest_q <= biasP1_uid130_fpExpETest_q;
                2'b01 : expUpdateVal_uid131_fpExpETest_q <= biasM2_uid129_fpExpETest_q;
                2'b10 : expUpdateVal_uid131_fpExpETest_q <= cstBiasM1_uid10_fpExpETest_q;
                2'b11 : expUpdateVal_uid131_fpExpETest_q <= cstBias_uid9_fpExpETest_q;
                default : expUpdateVal_uid131_fpExpETest_q <= 8'b0;
            endcase
        end
    end

    // redist18_expTmp_uid58_fpExpETest_b_28_rdcnt(COUNTER,366)
    // low=0, high=21, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i <= 5'd0;
            redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i == 5'd20)
            begin
                redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq <= 1'b0;
            end
            if (redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq == 1'b1)
            begin
                redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i <= $unsigned(redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i) + $unsigned(5'd11);
            end
            else
            begin
                redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i <= $unsigned(redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i) + $unsigned(5'd1);
            end
        end
    end
    assign redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q = $signed(redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i[4:0]);

    // redist18_expTmp_uid58_fpExpETest_b_28_rdmux(MUX,367)
    assign redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s = en;
    always_comb 
    begin
        unique case (redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s)
            1'b0 : redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q = redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q;
            1'b1 : redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q = redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q;
            default : redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q = 5'b0;
        endcase
    end

    // redist18_expTmp_uid58_fpExpETest_b_28_wraddr(REG,368)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q <= 5'b10101;
        end
        else
        begin
            redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q <= redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q;
        end
    end

    // redist18_expTmp_uid58_fpExpETest_b_28_mem(DUALMEM,365)
    assign redist18_expTmp_uid58_fpExpETest_b_28_mem_ia = $unsigned(redist17_expTmp_uid58_fpExpETest_b_4_q);
    assign redist18_expTmp_uid58_fpExpETest_b_28_mem_aa = redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q;
    assign redist18_expTmp_uid58_fpExpETest_b_28_mem_ab = redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q;
    assign redist18_expTmp_uid58_fpExpETest_b_28_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(8),
        .widthad_a(5),
        .numwords_a(22),
        .width_b(8),
        .widthad_b(5),
        .numwords_b(22),
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
    ) redist18_expTmp_uid58_fpExpETest_b_28_mem_dmem (
        .clocken1(redist18_expTmp_uid58_fpExpETest_b_28_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist18_expTmp_uid58_fpExpETest_b_28_mem_aa),
        .data_a(redist18_expTmp_uid58_fpExpETest_b_28_mem_ia),
        .wren_a(en[0]),
        .address_b(redist18_expTmp_uid58_fpExpETest_b_28_mem_ab),
        .q_b(redist18_expTmp_uid58_fpExpETest_b_28_mem_iq),
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
    assign redist18_expTmp_uid58_fpExpETest_b_28_mem_q = $signed(redist18_expTmp_uid58_fpExpETest_b_28_mem_iq[7:0]);

    // redist18_expTmp_uid58_fpExpETest_b_28_outputreg0(DELAY,364)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q <= redist18_expTmp_uid58_fpExpETest_b_28_mem_q;
        end
    end

    // updatedExponent_uid132_fpExpETest(ADD,131)@31
    assign updatedExponent_uid132_fpExpETest_a = $unsigned({{3{redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q[7]}}, redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q});
    assign updatedExponent_uid132_fpExpETest_b = $unsigned({3'b000, expUpdateVal_uid131_fpExpETest_q});
    assign updatedExponent_uid132_fpExpETest_o = $unsigned($signed(updatedExponent_uid132_fpExpETest_a) + $signed(updatedExponent_uid132_fpExpETest_b));
    assign updatedExponent_uid132_fpExpETest_q = $signed(updatedExponent_uid132_fpExpETest_o[9:0]);

    // expR_uid133_fpExpETest(BITSELECT,132)@31
    assign expR_uid133_fpExpETest_in = updatedExponent_uid132_fpExpETest_q[7:0];
    assign expR_uid133_fpExpETest_b = $signed(expR_uid133_fpExpETest_in[7:0]);

    // redist12_excREnc_uid142_fpExpETest_q_29_rdcnt(COUNTER,361)
    // low=0, high=26, step=1, init=0
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i <= 5'd0;
            redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq <= 1'b0;
        end
        else if (en == 1'b1)
        begin
            if (redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i == 5'd25)
            begin
                redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq <= 1'b1;
            end
            else
            begin
                redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq <= 1'b0;
            end
            if (redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq == 1'b1)
            begin
                redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i <= $unsigned(redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i) + $unsigned(5'd6);
            end
            else
            begin
                redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i <= $unsigned(redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i) + $unsigned(5'd1);
            end
        end
    end
    assign redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q = $signed(redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i[4:0]);

    // redist12_excREnc_uid142_fpExpETest_q_29_rdmux(MUX,362)
    assign redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s = en;
    always_comb 
    begin
        unique case (redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s)
            1'b0 : redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q = redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q;
            1'b1 : redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q = redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q;
            default : redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q = 5'b0;
        endcase
    end

    // cstZeroWF_uid18_fpExpETest(CONSTANT,17)
    assign cstZeroWF_uid18_fpExpETest_q = 23'b00000000000000000000000;

    // fracXIsZero_uid24_fpExpETest(LOGICAL,23)@1 + 1
    assign fracXIsZero_uid24_fpExpETest_qi = $unsigned(cstZeroWF_uid18_fpExpETest_q == fracX_uid8_fpExpETest_b ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    fracXIsZero_uid24_fpExpETest_delay ( .xin(fracXIsZero_uid24_fpExpETest_qi), .xout(fracXIsZero_uid24_fpExpETest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // fracXIsNotZero_uid25_fpExpETest(LOGICAL,24)@2
    assign fracXIsNotZero_uid25_fpExpETest_q = $signed(~ (fracXIsZero_uid24_fpExpETest_q));

    // redist20_expX_uid6_fpExpETest_b_1(DELAY,348)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist20_expX_uid6_fpExpETest_b_1_q <= expX_uid6_fpExpETest_b;
        end
    end

    // expXIsMax_uid23_fpExpETest(LOGICAL,22)@1 + 1
    assign expXIsMax_uid23_fpExpETest_qi = $unsigned(redist20_expX_uid6_fpExpETest_b_1_q == cstAllOWE_uid17_fpExpETest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    expXIsMax_uid23_fpExpETest_delay ( .xin(expXIsMax_uid23_fpExpETest_qi), .xout(expXIsMax_uid23_fpExpETest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // excN_x_uid27_fpExpETest(LOGICAL,26)@2
    assign excN_x_uid27_fpExpETest_q = $signed(expXIsMax_uid23_fpExpETest_q & fracXIsNotZero_uid25_fpExpETest_q);

    // expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313(CONSTANT,312)
    assign expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313_q = 28'b1000010101100010111001000011;

    // expFracX_uid31_fpExpETest(BITJOIN,30)@1
    assign expFracX_uid31_fpExpETest_q = {redist20_expX_uid6_fpExpETest_b_1_q, fracX_uid8_fpExpETest_b};

    // expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314(BITSELECT,313)@1
    assign expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314_b = $signed(expFracX_uid31_fpExpETest_q[30:3]);

    // expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315(COMPARE,314)@1 + 1
    assign expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_a = {2'b00, expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314_b};
    assign expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_b = {2'b00, expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313_q};
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o <= 30'b0;
        end
        else if (en == 1'b1)
        begin
            expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o <= $unsigned(expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_a) - $unsigned(expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_b);
        end
    end
    assign expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_n[0] = ~ (expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o[29]);

    // invSignX_uid34_fpExpETest(LOGICAL,33)@2
    assign invSignX_uid34_fpExpETest_q = $signed(~ (signX_uid7_fpExpETest_b));

    // inputOverflow_uid35_fpExpETest(LOGICAL,34)@2
    assign inputOverflow_uid35_fpExpETest_q = $signed(invSignX_uid34_fpExpETest_q & expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_n);

    // invExpXIsMax_uid28_fpExpETest(LOGICAL,27)@2
    assign invExpXIsMax_uid28_fpExpETest_q = $signed(~ (expXIsMax_uid23_fpExpETest_q));

    // excZ_x_uid22_fpExpETest(LOGICAL,21)@1 + 1
    assign excZ_x_uid22_fpExpETest_qi = $unsigned(redist20_expX_uid6_fpExpETest_b_1_q == cstZeroWE_uid14_fpExpETest_q ? 1'b1 : 1'b0);
    dspba_delay_ver #( .width(1), .depth(1), .reset_kind("SYNC"), .phase(0), .modulus(1) )
    excZ_x_uid22_fpExpETest_delay ( .xin(excZ_x_uid22_fpExpETest_qi), .xout(excZ_x_uid22_fpExpETest_q), .ena(en[0]), .clk(clk), .aclr(areset) );

    // InvExpXIsZero_uid29_fpExpETest(LOGICAL,28)@2
    assign InvExpXIsZero_uid29_fpExpETest_q = $signed(~ (excZ_x_uid22_fpExpETest_q));

    // excR_x_uid30_fpExpETest(LOGICAL,29)@2
    assign excR_x_uid30_fpExpETest_q = $signed(InvExpXIsZero_uid29_fpExpETest_q & invExpXIsMax_uid28_fpExpETest_q);

    // regXAndExpOverflowAndPos_uid137_fpExpETest(LOGICAL,136)@2
    assign regXAndExpOverflowAndPos_uid137_fpExpETest_q = $signed(excR_x_uid30_fpExpETest_q & inputOverflow_uid35_fpExpETest_q);

    // excI_x_uid26_fpExpETest(LOGICAL,25)@2
    assign excI_x_uid26_fpExpETest_q = $signed(expXIsMax_uid23_fpExpETest_q & fracXIsZero_uid24_fpExpETest_q);

    // posInf_uid139_fpExpETest(LOGICAL,138)@2
    assign posInf_uid139_fpExpETest_q = $signed(excI_x_uid26_fpExpETest_q & invSignX_uid34_fpExpETest_q);

    // excRInf_uid140_fpExpETest(LOGICAL,139)@2
    assign excRInf_uid140_fpExpETest_q = $signed(posInf_uid139_fpExpETest_q | regXAndExpOverflowAndPos_uid137_fpExpETest_q);

    // negInf_uid134_fpExpETest(LOGICAL,133)@2
    assign negInf_uid134_fpExpETest_q = $signed(excI_x_uid26_fpExpETest_q & signX_uid7_fpExpETest_b);

    // expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316(CONSTANT,315)
    assign expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316_q = 27'b100001010101110101011000101;

    // expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317(BITSELECT,316)@1
    assign expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317_b = $signed(expFracX_uid31_fpExpETest_q[30:4]);

    // expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318(COMPARE,317)@1 + 1
    assign expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_a = {2'b00, expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317_b};
    assign expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_b = {2'b00, expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316_q};
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o <= 29'b0;
        end
        else if (en == 1'b1)
        begin
            expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o <= $unsigned(expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_a) - $unsigned(expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_b);
        end
    end
    assign expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_n[0] = ~ (expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o[28]);

    // inputUnderflow_uid38_fpExpETest(LOGICAL,37)@2
    assign inputUnderflow_uid38_fpExpETest_q = $signed(signX_uid7_fpExpETest_b & expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_n);

    // regXAndExpOverflowAndNeg_uid135_fpExpETest(LOGICAL,134)@2
    assign regXAndExpOverflowAndNeg_uid135_fpExpETest_q = $signed(excR_x_uid30_fpExpETest_q & inputUnderflow_uid38_fpExpETest_q);

    // excRZero_uid136_fpExpETest(LOGICAL,135)@2
    assign excRZero_uid136_fpExpETest_q = $signed(regXAndExpOverflowAndNeg_uid135_fpExpETest_q | negInf_uid134_fpExpETest_q);

    // concExc_uid141_fpExpETest(BITJOIN,140)@2
    assign concExc_uid141_fpExpETest_q = {excN_x_uid27_fpExpETest_q, excRInf_uid140_fpExpETest_q, excRZero_uid136_fpExpETest_q};

    // excREnc_uid142_fpExpETest(LOOKUP,141)@2 + 1
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            excREnc_uid142_fpExpETest_q <= 2'b01;
        end
        else if (en == 1'b1)
        begin
            unique case (concExc_uid141_fpExpETest_q)
                3'b000 : excREnc_uid142_fpExpETest_q <= 2'b01;
                3'b001 : excREnc_uid142_fpExpETest_q <= 2'b00;
                3'b010 : excREnc_uid142_fpExpETest_q <= 2'b10;
                3'b011 : excREnc_uid142_fpExpETest_q <= 2'b00;
                3'b100 : excREnc_uid142_fpExpETest_q <= 2'b11;
                3'b101 : excREnc_uid142_fpExpETest_q <= 2'b00;
                3'b110 : excREnc_uid142_fpExpETest_q <= 2'b00;
                3'b111 : excREnc_uid142_fpExpETest_q <= 2'b00;
                default : begin
                              // unreachable
                              excREnc_uid142_fpExpETest_q <= 2'bxx;
                          end
            endcase
        end
    end

    // redist12_excREnc_uid142_fpExpETest_q_29_wraddr(REG,363)
    always_ff @ (posedge clk)
    begin
        if (areset)
        begin
            redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q <= 5'b11010;
        end
        else
        begin
            redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q <= redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q;
        end
    end

    // redist12_excREnc_uid142_fpExpETest_q_29_mem(DUALMEM,360)
    assign redist12_excREnc_uid142_fpExpETest_q_29_mem_ia = $unsigned(excREnc_uid142_fpExpETest_q);
    assign redist12_excREnc_uid142_fpExpETest_q_29_mem_aa = redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q;
    assign redist12_excREnc_uid142_fpExpETest_q_29_mem_ab = redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q;
    assign redist12_excREnc_uid142_fpExpETest_q_29_mem_ena_OrRstB = areset | en[0];
    altera_syncram #(
        .ram_block_type("MLAB"),
        .operation_mode("DUAL_PORT"),
        .width_a(2),
        .widthad_a(5),
        .numwords_a(27),
        .width_b(2),
        .widthad_b(5),
        .numwords_b(27),
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
    ) redist12_excREnc_uid142_fpExpETest_q_29_mem_dmem (
        .clocken1(redist12_excREnc_uid142_fpExpETest_q_29_mem_ena_OrRstB),
        .clocken0(1'b1),
        .clock0(clk),
        .clock1(clk),
        .address_a(redist12_excREnc_uid142_fpExpETest_q_29_mem_aa),
        .data_a(redist12_excREnc_uid142_fpExpETest_q_29_mem_ia),
        .wren_a(en[0]),
        .address_b(redist12_excREnc_uid142_fpExpETest_q_29_mem_ab),
        .q_b(redist12_excREnc_uid142_fpExpETest_q_29_mem_iq),
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
    assign redist12_excREnc_uid142_fpExpETest_q_29_mem_q = $signed(redist12_excREnc_uid142_fpExpETest_q_29_mem_iq[1:0]);

    // expRPostExc_uid151_fpExpETest(MUX,150)@31
    assign expRPostExc_uid151_fpExpETest_s = redist12_excREnc_uid142_fpExpETest_q_29_mem_q;
    always_comb 
    begin
        unique case (expRPostExc_uid151_fpExpETest_s)
            2'b00 : expRPostExc_uid151_fpExpETest_q = cstZeroWE_uid14_fpExpETest_q;
            2'b01 : expRPostExc_uid151_fpExpETest_q = expR_uid133_fpExpETest_b;
            2'b10 : expRPostExc_uid151_fpExpETest_q = cstAllOWE_uid17_fpExpETest_q;
            2'b11 : expRPostExc_uid151_fpExpETest_q = cstAllOWE_uid17_fpExpETest_q;
            default : expRPostExc_uid151_fpExpETest_q = 8'b0;
        endcase
    end

    // oneFracRPostExc2_uid143_fpExpETest(CONSTANT,142)
    assign oneFracRPostExc2_uid143_fpExpETest_q = 23'b00000000000000000000001;

    // fracEY_uid145_fpExpETest(BITSELECT,144)@30
    assign fracEY_uid145_fpExpETest_b = $signed(eY_uid125_fpExpETest_impl_q0[22:0]);

    // redist11_fracEY_uid145_fpExpETest_b_1(DELAY,339)
    always_ff @ (posedge clk)
    begin
        if (0)
        begin
        end
        else if (en == 1'b1)
        begin
            redist11_fracEY_uid145_fpExpETest_b_1_q <= fracEY_uid145_fpExpETest_b;
        end
    end

    // fracRPostExc_uid147_fpExpETest(MUX,146)@31
    assign fracRPostExc_uid147_fpExpETest_s = redist12_excREnc_uid142_fpExpETest_q_29_mem_q;
    always_comb 
    begin
        unique case (fracRPostExc_uid147_fpExpETest_s)
            2'b00 : fracRPostExc_uid147_fpExpETest_q = cstZeroWF_uid18_fpExpETest_q;
            2'b01 : fracRPostExc_uid147_fpExpETest_q = redist11_fracEY_uid145_fpExpETest_b_1_q;
            2'b10 : fracRPostExc_uid147_fpExpETest_q = cstZeroWF_uid18_fpExpETest_q;
            2'b11 : fracRPostExc_uid147_fpExpETest_q = oneFracRPostExc2_uid143_fpExpETest_q;
            default : fracRPostExc_uid147_fpExpETest_q = 23'b0;
        endcase
    end

    // finalResult_uid153_fpExpETest(BITJOIN,152)@31
    assign finalResult_uid153_fpExpETest_q = {redist10_signEY_uid152_fpExpETest_b_1_q, expRPostExc_uid151_fpExpETest_q, fracRPostExc_uid147_fpExpETest_q};

    // xOut(GPOUT,4)@31
    assign q = finalResult_uid153_fpExpETest_q;

endmodule
