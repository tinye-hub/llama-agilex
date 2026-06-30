-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Altera(R) FPGAs Version 25.1.1 (Release Build #64f96064e9)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2025 Altera Corporation.  All rights reserved.
-- Your use of Altera Corporation's  design tools,  logic functions and other
-- software and  tools, and  its AMPP partner logic functions, and any output
-- files any  of the  foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or  information  are expressly
-- subject to the terms and  conditions  of the  Altera FPGA Software License
-- Agreement, Altera MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that  your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Altera
-- and  sold by Altera  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from fp32Exp_altera_fp_functions_19110_fz7lzha
-- VHDL created on Tue Jun 30 04:11:18 2026


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;

library tennm;
use tennm.tennm_components.tennm_mac;
use tennm.tennm_components.tennm_fp_mac;
use tennm.tennm_components.tennm_dsp_prime;

entity fp32Exp_altera_fp_functions_19110_fz7lzha is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        en : in std_logic_vector(0 downto 0);  -- ufix1
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fp32Exp_altera_fp_functions_19110_fz7lzha;

architecture normal of fp32Exp_altera_fp_functions_19110_fz7lzha is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expX_uid6_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal signX_uid7_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracX_uid8_fpExpETest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal cstBias_uid9_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstBiasM1_uid10_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWE_uid14_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstAllOWE_uid17_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid18_fpExpETest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid22_fpExpETest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_x_uid22_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid23_fpExpETest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid23_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid24_fpExpETest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid24_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid25_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid26_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid27_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid28_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid29_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid30_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracX_uid31_fpExpETest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal invSignX_uid34_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal inputOverflow_uid35_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal inputUnderflow_uid38_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xFxpLow_uid39_fpExpETest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal oXLow_uid41_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstBiasPCstShift_uid42_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftVal_uid43_fpExpETest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftVal_uid43_fpExpETest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftVal_uid43_fpExpETest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftVal_uid43_fpExpETest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftUdf_uid46_fpExpETest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftUdf_uid46_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal zEp_uid51_fpExpETest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal ePOC_uid52_fpExpETest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal ePOC_uid52_fpExpETest_qi : STD_LOGIC_VECTOR (10 downto 0);
    signal ePOC_uid52_fpExpETest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal Rnd2C_uid54_fpExpETest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal eP2CWRnd_uid57_fpExpETest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal eP2CWRnd_uid57_fpExpETest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal eP2CWRnd_uid57_fpExpETest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal eP2CWRnd_uid57_fpExpETest_q : STD_LOGIC_VECTOR (11 downto 0);
    signal expTmp_uid58_fpExpETest_in : STD_LOGIC_VECTOR (9 downto 0);
    signal expTmp_uid58_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal bit7_uid59_fpExpETest_in : STD_LOGIC_VECTOR (10 downto 0);
    signal bit7_uid59_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal invBit7_uid60_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal bit8_uid61_fpExpETest_in : STD_LOGIC_VECTOR (9 downto 0);
    signal bit8_uid61_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal maxExpCond_uid62_fpExpETest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal maxExpCond_uid62_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal kPZHigh_uid73_fpExpETest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal kPZHigh_uid73_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal kPZLow_uid76_fpExpETest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal kPZLow_uid76_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal ySign_uid77_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fraction_uid78_fpExpETest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fraction_uid78_fpExpETest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal exp_uid79_fpExpETest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal exp_uid79_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal invYSign_uid80_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal minusY_uid81_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal ySign_uid83_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fraction_uid84_fpExpETest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fraction_uid84_fpExpETest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal exp_uid85_fpExpETest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal exp_uid85_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal invYSign_uid86_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal minusY_uid87_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal fracYP_uid89_fpExpETest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expYP_uid90_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal signYP_uid91_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracYPTop_uid93_fpExpETest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal fxpAPreAlign_uid95_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftValFxpA_uid96_fpExpETest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftValFxpA_uid96_fpExpETest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftValFxpA_uid96_fpExpETest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftValFxpA_uid96_fpExpETest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftValFxpAR_uid97_fpExpETest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal shiftValFxpAR_uid97_fpExpETest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal addrEATable_uid99_fpExpETest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal eAPostUdfA_uid108_fpExpETest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal eAPostUdfA_uid108_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal maskAFP_uid109_fpExpETest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal fracYPTopPostMask_uid110_fpExpETest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal cst16z_uid111_fpExpETest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal fracAFull_uid112_fpExpETest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal newExpA_uid113_fpExpETest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal newExpA_uid113_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal a_uid114_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal ySign_uid115_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fraction_uid116_fpExpETest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fraction_uid116_fpExpETest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal exp_uid117_fpExpETest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal exp_uid117_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal invYSign_uid118_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal minusY_uid119_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal expEY_uid126_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal lowerBitOfeY_uid127_fpExpETest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowerBitOfeY_uid127_fpExpETest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal biasM2_uid129_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal biasP1_uid130_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expUpdateVal_uid131_fpExpETest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expUpdateVal_uid131_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal updatedExponent_uid132_fpExpETest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal updatedExponent_uid132_fpExpETest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal updatedExponent_uid132_fpExpETest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal updatedExponent_uid132_fpExpETest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expR_uid133_fpExpETest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expR_uid133_fpExpETest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal negInf_uid134_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regXAndExpOverflowAndNeg_uid135_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid136_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regXAndExpOverflowAndPos_uid137_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal posInf_uid139_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid140_fpExpETest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid141_fpExpETest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid142_fpExpETest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oneFracRPostExc2_uid143_fpExpETest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracEY_uid145_fpExpETest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid147_fpExpETest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid147_fpExpETest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid151_fpExpETest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid151_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal signEY_uid152_fpExpETest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal finalResult_uid153_fpExpETest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal p1_uid240_eP_uid50_fpExpETest_q : STD_LOGIC_VECTOR (12 downto 0);
    signal p0_uid241_eP_uid50_fpExpETest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal lev1_a0_uid242_eP_uid50_fpExpETest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal lev1_a0_uid242_eP_uid50_fpExpETest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal lev1_a0_uid242_eP_uid50_fpExpETest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal lev1_a0_uid242_eP_uid50_fpExpETest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal sOuputFormat_uid243_eP_uid50_fpExpETest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal sOuputFormat_uid243_eP_uid50_fpExpETest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal cste128h_uid72_fpExpETest_b_const_q : STD_LOGIC_VECTOR (31 downto 0);
    signal cste128l_uid75_fpExpETest_b_const_q : STD_LOGIC_VECTOR (31 downto 0);
    signal oneFP_uid107_fpExpETest_b_const_q : STD_LOGIC_VECTOR (31 downto 0);
    signal cstHalfFP_uid122_fpExpETest_b_const_q : STD_LOGIC_VECTOR (31 downto 0);
    signal rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_reset0 : std_logic;
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ena_NotRstA : std_logic;
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ir : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_reset0 : std_logic;
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ena_NotRstA : std_logic;
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ir : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r : STD_LOGIC_VECTOR (31 downto 0);
    signal yP0_uid82_fpExpETest_impl_reset0 : std_logic;
    signal yP0_uid82_fpExpETest_impl_ena0 : std_logic;
    signal yP0_uid82_fpExpETest_impl_ax0 : STD_LOGIC_VECTOR (31 downto 0);
    signal yP0_uid82_fpExpETest_impl_ay0 : STD_LOGIC_VECTOR (31 downto 0);
    signal yP0_uid82_fpExpETest_impl_q0 : STD_LOGIC_VECTOR (31 downto 0);
    signal yP_uid88_fpExpETest_impl_reset0 : std_logic;
    signal yP_uid88_fpExpETest_impl_ena0 : std_logic;
    signal yP_uid88_fpExpETest_impl_ax0 : STD_LOGIC_VECTOR (31 downto 0);
    signal yP_uid88_fpExpETest_impl_ay0 : STD_LOGIC_VECTOR (31 downto 0);
    signal yP_uid88_fpExpETest_impl_q0 : STD_LOGIC_VECTOR (31 downto 0);
    signal rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0_uid290_fxpA_uid98_fpExpETest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage1_uid297_fxpA_uid98_fpExpETest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal floatTable_eA_uid100_fpExpETest_lutmem_reset0 : std_logic;
    signal floatTable_eA_uid100_fpExpETest_lutmem_ena_NotRstA : std_logic;
    signal floatTable_eA_uid100_fpExpETest_lutmem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_eA_uid100_fpExpETest_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal floatTable_eA_uid100_fpExpETest_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal floatTable_eA_uid100_fpExpETest_lutmem_ir : STD_LOGIC_VECTOR (31 downto 0);
    signal floatTable_eA_uid100_fpExpETest_lutmem_r : STD_LOGIC_VECTOR (31 downto 0);
    signal b_uid120_fpExpETest_impl_reset0 : std_logic;
    signal b_uid120_fpExpETest_impl_ena0 : std_logic;
    signal b_uid120_fpExpETest_impl_ax0 : STD_LOGIC_VECTOR (31 downto 0);
    signal b_uid120_fpExpETest_impl_ay0 : STD_LOGIC_VECTOR (31 downto 0);
    signal b_uid120_fpExpETest_impl_q0 : STD_LOGIC_VECTOR (31 downto 0);
    signal oPBo2_uid123_fpExpETest_impl_reset0 : std_logic;
    signal oPBo2_uid123_fpExpETest_impl_ena0 : std_logic;
    signal oPBo2_uid123_fpExpETest_impl_ax0 : STD_LOGIC_VECTOR (31 downto 0);
    signal oPBo2_uid123_fpExpETest_impl_ay0 : STD_LOGIC_VECTOR (31 downto 0);
    signal oPBo2_uid123_fpExpETest_impl_az0 : STD_LOGIC_VECTOR (31 downto 0);
    signal oPBo2_uid123_fpExpETest_impl_q0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eB_uid124_fpExpETest_impl_reset0 : std_logic;
    signal eB_uid124_fpExpETest_impl_ena0 : std_logic;
    signal eB_uid124_fpExpETest_impl_ax0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eB_uid124_fpExpETest_impl_ay0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eB_uid124_fpExpETest_impl_az0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eB_uid124_fpExpETest_impl_q0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eY_uid125_fpExpETest_impl_reset0 : std_logic;
    signal eY_uid125_fpExpETest_impl_ena0 : std_logic;
    signal eY_uid125_fpExpETest_impl_ay0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eY_uid125_fpExpETest_impl_az0 : STD_LOGIC_VECTOR (31 downto 0);
    signal eY_uid125_fpExpETest_impl_q0 : STD_LOGIC_VECTOR (31 downto 0);
    signal expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313_q : STD_LOGIC_VECTOR (27 downto 0);
    signal expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314_b : STD_LOGIC_VECTOR (27 downto 0);
    signal expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_a : STD_LOGIC_VECTOR (29 downto 0);
    signal expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_b : STD_LOGIC_VECTOR (29 downto 0);
    signal expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o : STD_LOGIC_VECTOR (29 downto 0);
    signal expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316_q : STD_LOGIC_VECTOR (26 downto 0);
    signal expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317_b : STD_LOGIC_VECTOR (26 downto 0);
    signal expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_a : STD_LOGIC_VECTOR (28 downto 0);
    signal expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_b : STD_LOGIC_VECTOR (28 downto 0);
    signal expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o : STD_LOGIC_VECTOR (28 downto 0);
    signal expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_n : STD_LOGIC_VECTOR (0 downto 0);
    signal udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q : STD_LOGIC_VECTOR (4 downto 0);
    signal udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_a : STD_LOGIC_VECTOR (7 downto 0);
    signal udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_b : STD_LOGIC_VECTOR (7 downto 0);
    signal udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_o : STD_LOGIC_VECTOR (7 downto 0);
    signal udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftValPos_uid44_fpExpETest_bit_select_merged_in : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftValPos_uid44_fpExpETest_bit_select_merged_b : STD_LOGIC_VECTOR (2 downto 0);
    signal shiftValPos_uid44_fpExpETest_bit_select_merged_c : STD_LOGIC_VECTOR (4 downto 0);
    signal xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_b : STD_LOGIC_VECTOR (4 downto 0);
    signal xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_c : STD_LOGIC_VECTOR (2 downto 0);
    signal expYPBottom_uid92_fpExpETest_bit_select_merged_b : STD_LOGIC_VECTOR (2 downto 0);
    signal expYPBottom_uid92_fpExpETest_bit_select_merged_c : STD_LOGIC_VECTOR (4 downto 0);
    signal rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q : STD_LOGIC_VECTOR (0 downto 0);
    signal mergedMUXes0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_eB_uid124_fpExpETest_impl_q0_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist4_oPBo2_uid123_fpExpETest_impl_q0_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist5_b_uid120_fpExpETest_impl_q0_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist8_yP_uid88_fpExpETest_impl_q0_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist9_yP0_uid82_fpExpETest_impl_q0_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist10_signEY_uid152_fpExpETest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_fracEY_uid145_fpExpETest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist13_minusY_uid119_fpExpETest_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist14_signYP_uid91_fpExpETest_b_12_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist15_maxExpCond_uid62_fpExpETest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_maxExpCond_uid62_fpExpETest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_maxExpCond_uid62_fpExpETest_q_6_delay_0 : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_maxExpCond_uid62_fpExpETest_q_6_delay_1 : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_maxExpCond_uid62_fpExpETest_q_6_delay_2 : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_expTmp_uid58_fpExpETest_b_4_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist17_expTmp_uid58_fpExpETest_b_4_delay_0 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist17_expTmp_uid58_fpExpETest_b_4_delay_1 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist17_expTmp_uid58_fpExpETest_b_4_delay_2 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist19_signX_uid7_fpExpETest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist20_expX_uid6_fpExpETest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist21_xIn_a_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist22_xIn_a_2_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist23_xIn_a_5_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist23_xIn_a_5_delay_0 : STD_LOGIC_VECTOR (31 downto 0);
    signal redist23_xIn_a_5_delay_1 : STD_LOGIC_VECTOR (31 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_reset0 : std_logic;
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_ena_OrRstB : std_logic;
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_aa : STD_LOGIC_VECTOR (1 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_ab : STD_LOGIC_VECTOR (1 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_iq : STD_LOGIC_VECTOR (31 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_mem_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i : UNSIGNED (1 downto 0);
    attribute preserve_syn_only : boolean;
    attribute preserve_syn_only of redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i : signal is true;
    signal redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_reset0 : std_logic;
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ena_OrRstB : std_logic;
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ia : STD_LOGIC_VECTOR (7 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_aa : STD_LOGIC_VECTOR (3 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ab : STD_LOGIC_VECTOR (3 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_iq : STD_LOGIC_VECTOR (7 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i : UNSIGNED (3 downto 0);
    attribute preserve_syn_only of redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i : signal is true;
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq : signal is true;
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_reset0 : std_logic;
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_ena_OrRstB : std_logic;
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_ia : STD_LOGIC_VECTOR (1 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_aa : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_ab : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_iq : STD_LOGIC_VECTOR (1 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_mem_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i : UNSIGNED (4 downto 0);
    attribute preserve_syn_only of redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i : signal is true;
    signal redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq : signal is true;
    signal redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_reset0 : std_logic;
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_ena_OrRstB : std_logic;
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_ia : STD_LOGIC_VECTOR (7 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_aa : STD_LOGIC_VECTOR (4 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_ab : STD_LOGIC_VECTOR (4 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_iq : STD_LOGIC_VECTOR (7 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_mem_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i : UNSIGNED (4 downto 0);
    attribute preserve_syn_only of redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i : signal is true;
    signal redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq : signal is true;
    signal redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q : STD_LOGIC_VECTOR (4 downto 0);

begin


    -- oneFP_uid107_fpExpETest_b_const(CONSTANT,246)
    oneFP_uid107_fpExpETest_b_const_q <= "00111111100000000000000000000000";

    -- redist21_xIn_a_1(DELAY,349)
    redist21_xIn_a_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist21_xIn_a_1_q <= a;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist22_xIn_a_2(DELAY,350)
    redist22_xIn_a_2_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist22_xIn_a_2_q <= redist21_xIn_a_1_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist23_xIn_a_5(DELAY,351)
    redist23_xIn_a_5_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist23_xIn_a_5_delay_0 <= STD_LOGIC_VECTOR(redist22_xIn_a_2_q);
                    redist23_xIn_a_5_delay_1 <= redist23_xIn_a_5_delay_0;
                    redist23_xIn_a_5_q <= STD_LOGIC_VECTOR(redist23_xIn_a_5_delay_1);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- cste128h_uid72_fpExpETest_b_const(CONSTANT,244)
    cste128h_uid72_fpExpETest_b_const_q <= "01000010101100010111001000010111";

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signX_uid7_fpExpETest(BITSELECT,6)@2
    signX_uid7_fpExpETest_b <= redist22_xIn_a_2_q(31 downto 31);

    -- redist19_signX_uid7_fpExpETest_b_1(DELAY,347)
    redist19_signX_uid7_fpExpETest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist19_signX_uid7_fpExpETest_b_1_q <= signX_uid7_fpExpETest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Rnd2C_uid54_fpExpETest(BITJOIN,53)@3
    Rnd2C_uid54_fpExpETest_q <= VCC_q & redist19_signX_uid7_fpExpETest_b_1_q;

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest(CONSTANT,261)
    rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q <= "000";

    -- rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest(BITSELECT,260)@1
    rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest_b <= STD_LOGIC_VECTOR(oXLow_uid41_fpExpETest_q(7 downto 3));

    -- rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest(BITJOIN,262)@1
    rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q <= rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q & rightShiftStage0Idx3Rng3_uid261_fxpXRed_uid47_fpExpETest_b;

    -- rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest(CONSTANT,258)
    rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q <= "00";

    -- rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest(BITSELECT,257)@1
    rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest_b <= STD_LOGIC_VECTOR(oXLow_uid41_fpExpETest_q(7 downto 2));

    -- rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest(BITJOIN,259)@1
    rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q <= rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q & rightShiftStage0Idx2Rng2_uid258_fxpXRed_uid47_fpExpETest_b;

    -- rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest(BITSELECT,254)@1
    rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest_b <= STD_LOGIC_VECTOR(oXLow_uid41_fpExpETest_q(7 downto 1));

    -- rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest(BITJOIN,256)@1
    rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q <= GND_q & rightShiftStage0Idx1Rng1_uid255_fxpXRed_uid47_fpExpETest_b;

    -- fracX_uid8_fpExpETest(BITSELECT,7)@1
    fracX_uid8_fpExpETest_b <= STD_LOGIC_VECTOR(redist21_xIn_a_1_q(22 downto 0));

    -- xFxpLow_uid39_fpExpETest(BITSELECT,38)@1
    xFxpLow_uid39_fpExpETest_b <= STD_LOGIC_VECTOR(fracX_uid8_fpExpETest_b(22 downto 16));

    -- oXLow_uid41_fpExpETest(BITJOIN,40)@1
    oXLow_uid41_fpExpETest_q <= VCC_q & xFxpLow_uid39_fpExpETest_b;

    -- rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest(MUX,264)@1
    rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s <= rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_b;
    rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_combproc: PROCESS (rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s, en, oXLow_uid41_fpExpETest_q, rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q, rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q, rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q)
    BEGIN
        CASE (rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_s) IS
            WHEN "00" => rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q <= oXLow_uid41_fpExpETest_q;
            WHEN "01" => rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q <= rightShiftStage0Idx1_uid257_fxpXRed_uid47_fpExpETest_q;
            WHEN "10" => rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q <= rightShiftStage0Idx2_uid260_fxpXRed_uid47_fpExpETest_q;
            WHEN "11" => rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q <= rightShiftStage0Idx3_uid263_fxpXRed_uid47_fpExpETest_q;
            WHEN OTHERS => rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel(LOGICAL,326)@1
    rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q <= not (rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c);

    -- rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest(CONSTANT,266)
    rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q <= "0000";

    -- rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest(BITSELECT,265)@1
    rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest_b <= STD_LOGIC_VECTOR(rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q(7 downto 4));

    -- rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest(BITJOIN,267)@1
    rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q <= rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q & rightShiftStage1Idx1Rng4_uid266_fxpXRed_uid47_fpExpETest_b;

    -- expX_uid6_fpExpETest(BITSELECT,5)@0
    expX_uid6_fpExpETest_b <= STD_LOGIC_VECTOR(a(30 downto 23));

    -- cstBiasPCstShift_uid42_fpExpETest(CONSTANT,41)
    cstBiasPCstShift_uid42_fpExpETest_q <= "10000101";

    -- shiftVal_uid43_fpExpETest(SUB,42)@0
    shiftVal_uid43_fpExpETest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & cstBiasPCstShift_uid42_fpExpETest_q));
    shiftVal_uid43_fpExpETest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & expX_uid6_fpExpETest_b));
    shiftVal_uid43_fpExpETest_o <= STD_LOGIC_VECTOR(SIGNED(shiftVal_uid43_fpExpETest_a) - SIGNED(shiftVal_uid43_fpExpETest_b));
    shiftVal_uid43_fpExpETest_q <= STD_LOGIC_VECTOR(shiftVal_uid43_fpExpETest_o(8 downto 0));

    -- shiftValPos_uid44_fpExpETest_bit_select_merged(BITSELECT,321)@0
    shiftValPos_uid44_fpExpETest_bit_select_merged_in <= shiftVal_uid43_fpExpETest_q(7 downto 0);
    shiftValPos_uid44_fpExpETest_bit_select_merged_b <= STD_LOGIC_VECTOR(shiftValPos_uid44_fpExpETest_bit_select_merged_in(2 downto 0));
    shiftValPos_uid44_fpExpETest_bit_select_merged_c <= STD_LOGIC_VECTOR(shiftValPos_uid44_fpExpETest_bit_select_merged_in(7 downto 3));

    -- redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1(DELAY,329)
    redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q <= shiftValPos_uid44_fpExpETest_bit_select_merged_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged(BITSELECT,325)@1
    rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_b <= STD_LOGIC_VECTOR(redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q(1 downto 0));
    rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c <= STD_LOGIC_VECTOR(redist1_shiftValPos_uid44_fpExpETest_bit_select_merged_b_1_q(2 downto 2));

    -- cstZeroWE_uid14_fpExpETest(CONSTANT,13)
    cstZeroWE_uid14_fpExpETest_q <= "00000000";

    -- shiftUdf_uid46_fpExpETest(LOGICAL,45)@0 + 1
    shiftUdf_uid46_fpExpETest_qi <= "1" WHEN shiftValPos_uid44_fpExpETest_bit_select_merged_c /= "00000" ELSE "0";
    shiftUdf_uid46_fpExpETest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => shiftUdf_uid46_fpExpETest_qi, xout => shiftUdf_uid46_fpExpETest_q, ena => en(0), clk => clk, aclr => areset );

    -- mergedMUXes0(SELECTOR,327)@1
    mergedMUXes0_combproc: PROCESS (shiftUdf_uid46_fpExpETest_q, cstZeroWE_uid14_fpExpETest_q, rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c, rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q, rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q, rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q)
    BEGIN
        mergedMUXes0_q <= (others => '0');
        IF (rightShiftStage1_uid270_fxpXRed_uid47_fpExpETestinvSel_q = "1") THEN
            mergedMUXes0_q <= STD_LOGIC_VECTOR(rightShiftStage0_uid265_fxpXRed_uid47_fpExpETest_q);
        END IF;
        IF (rightShiftStageSel0Dto0_uid264_fxpXRed_uid47_fpExpETest_bit_select_merged_c = "1") THEN
            mergedMUXes0_q <= STD_LOGIC_VECTOR(rightShiftStage1Idx1_uid268_fxpXRed_uid47_fpExpETest_q);
        END IF;
        IF (shiftUdf_uid46_fpExpETest_q = "1") THEN
            mergedMUXes0_q <= STD_LOGIC_VECTOR(cstZeroWE_uid14_fpExpETest_q);
        END IF;
    END PROCESS;

    -- xv0_uid238_eP_uid50_fpExpETest_bit_select_merged(BITSELECT,322)@1
    xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_b <= STD_LOGIC_VECTOR(mergedMUXes0_q(4 downto 0));
    xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_c <= STD_LOGIC_VECTOR(mergedMUXes0_q(7 downto 5));

    -- p0_uid241_eP_uid50_fpExpETest(LOOKUP,240)@1 + 1
    p0_uid241_eP_uid50_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                p0_uid241_eP_uid50_fpExpETest_q <= "000000000";
            ELSE
                IF (en = "1") THEN
                    CASE (xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_b) IS
                        WHEN "00000" => p0_uid241_eP_uid50_fpExpETest_q <= "000000000";
                        WHEN "00001" => p0_uid241_eP_uid50_fpExpETest_q <= "000001011";
                        WHEN "00010" => p0_uid241_eP_uid50_fpExpETest_q <= "000010111";
                        WHEN "00011" => p0_uid241_eP_uid50_fpExpETest_q <= "000100010";
                        WHEN "00100" => p0_uid241_eP_uid50_fpExpETest_q <= "000101110";
                        WHEN "00101" => p0_uid241_eP_uid50_fpExpETest_q <= "000111001";
                        WHEN "00110" => p0_uid241_eP_uid50_fpExpETest_q <= "001000101";
                        WHEN "00111" => p0_uid241_eP_uid50_fpExpETest_q <= "001010000";
                        WHEN "01000" => p0_uid241_eP_uid50_fpExpETest_q <= "001011100";
                        WHEN "01001" => p0_uid241_eP_uid50_fpExpETest_q <= "001100111";
                        WHEN "01010" => p0_uid241_eP_uid50_fpExpETest_q <= "001110011";
                        WHEN "01011" => p0_uid241_eP_uid50_fpExpETest_q <= "001111110";
                        WHEN "01100" => p0_uid241_eP_uid50_fpExpETest_q <= "010001010";
                        WHEN "01101" => p0_uid241_eP_uid50_fpExpETest_q <= "010010110";
                        WHEN "01110" => p0_uid241_eP_uid50_fpExpETest_q <= "010100001";
                        WHEN "01111" => p0_uid241_eP_uid50_fpExpETest_q <= "010101101";
                        WHEN "10000" => p0_uid241_eP_uid50_fpExpETest_q <= "010111000";
                        WHEN "10001" => p0_uid241_eP_uid50_fpExpETest_q <= "011000100";
                        WHEN "10010" => p0_uid241_eP_uid50_fpExpETest_q <= "011001111";
                        WHEN "10011" => p0_uid241_eP_uid50_fpExpETest_q <= "011011011";
                        WHEN "10100" => p0_uid241_eP_uid50_fpExpETest_q <= "011100110";
                        WHEN "10101" => p0_uid241_eP_uid50_fpExpETest_q <= "011110010";
                        WHEN "10110" => p0_uid241_eP_uid50_fpExpETest_q <= "011111101";
                        WHEN "10111" => p0_uid241_eP_uid50_fpExpETest_q <= "100001001";
                        WHEN "11000" => p0_uid241_eP_uid50_fpExpETest_q <= "100010100";
                        WHEN "11001" => p0_uid241_eP_uid50_fpExpETest_q <= "100100000";
                        WHEN "11010" => p0_uid241_eP_uid50_fpExpETest_q <= "100101100";
                        WHEN "11011" => p0_uid241_eP_uid50_fpExpETest_q <= "100110111";
                        WHEN "11100" => p0_uid241_eP_uid50_fpExpETest_q <= "101000011";
                        WHEN "11101" => p0_uid241_eP_uid50_fpExpETest_q <= "101001110";
                        WHEN "11110" => p0_uid241_eP_uid50_fpExpETest_q <= "101011010";
                        WHEN "11111" => p0_uid241_eP_uid50_fpExpETest_q <= "101100101";
                        WHEN OTHERS => -- unreachable
                                       p0_uid241_eP_uid50_fpExpETest_q <= (others => '-');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- p1_uid240_eP_uid50_fpExpETest(LOOKUP,239)@1 + 1
    p1_uid240_eP_uid50_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                p1_uid240_eP_uid50_fpExpETest_q <= "0000000000010";
            ELSE
                IF (en = "1") THEN
                    CASE (xv0_uid238_eP_uid50_fpExpETest_bit_select_merged_c) IS
                        WHEN "000" => p1_uid240_eP_uid50_fpExpETest_q <= "0000000000010";
                        WHEN "001" => p1_uid240_eP_uid50_fpExpETest_q <= "0000101110011";
                        WHEN "010" => p1_uid240_eP_uid50_fpExpETest_q <= "0001011100100";
                        WHEN "011" => p1_uid240_eP_uid50_fpExpETest_q <= "0010001010101";
                        WHEN "100" => p1_uid240_eP_uid50_fpExpETest_q <= "0010111000111";
                        WHEN "101" => p1_uid240_eP_uid50_fpExpETest_q <= "0011100111000";
                        WHEN "110" => p1_uid240_eP_uid50_fpExpETest_q <= "0100010101001";
                        WHEN "111" => p1_uid240_eP_uid50_fpExpETest_q <= "0101000011011";
                        WHEN OTHERS => -- unreachable
                                       p1_uid240_eP_uid50_fpExpETest_q <= (others => '-');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- lev1_a0_uid242_eP_uid50_fpExpETest(ADD,241)@2
    lev1_a0_uid242_eP_uid50_fpExpETest_a <= STD_LOGIC_VECTOR("0" & p1_uid240_eP_uid50_fpExpETest_q);
    lev1_a0_uid242_eP_uid50_fpExpETest_b <= STD_LOGIC_VECTOR("00000" & p0_uid241_eP_uid50_fpExpETest_q);
    lev1_a0_uid242_eP_uid50_fpExpETest_o <= STD_LOGIC_VECTOR(UNSIGNED(lev1_a0_uid242_eP_uid50_fpExpETest_a) + UNSIGNED(lev1_a0_uid242_eP_uid50_fpExpETest_b));
    lev1_a0_uid242_eP_uid50_fpExpETest_q <= STD_LOGIC_VECTOR(lev1_a0_uid242_eP_uid50_fpExpETest_o(13 downto 0));

    -- sOuputFormat_uid243_eP_uid50_fpExpETest(BITSELECT,242)@2
    sOuputFormat_uid243_eP_uid50_fpExpETest_in <= lev1_a0_uid242_eP_uid50_fpExpETest_q(11 downto 0);
    sOuputFormat_uid243_eP_uid50_fpExpETest_b <= STD_LOGIC_VECTOR(sOuputFormat_uid243_eP_uid50_fpExpETest_in(11 downto 2));

    -- zEp_uid51_fpExpETest(BITJOIN,50)@2
    zEp_uid51_fpExpETest_q <= GND_q & sOuputFormat_uid243_eP_uid50_fpExpETest_b;

    -- ePOC_uid52_fpExpETest(LOGICAL,51)@2 + 1
    ePOC_uid52_fpExpETest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 1 => signX_uid7_fpExpETest_b(0)) & signX_uid7_fpExpETest_b));
    ePOC_uid52_fpExpETest_qi <= zEp_uid51_fpExpETest_q xor ePOC_uid52_fpExpETest_b;
    ePOC_uid52_fpExpETest_delay : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => ePOC_uid52_fpExpETest_qi, xout => ePOC_uid52_fpExpETest_q, ena => en(0), clk => clk, aclr => areset );

    -- eP2CWRnd_uid57_fpExpETest(ADD,56)@3
    eP2CWRnd_uid57_fpExpETest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => ePOC_uid52_fpExpETest_q(10)) & ePOC_uid52_fpExpETest_q));
    eP2CWRnd_uid57_fpExpETest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & Rnd2C_uid54_fpExpETest_q));
    eP2CWRnd_uid57_fpExpETest_o <= STD_LOGIC_VECTOR(SIGNED(eP2CWRnd_uid57_fpExpETest_a) + SIGNED(eP2CWRnd_uid57_fpExpETest_b));
    eP2CWRnd_uid57_fpExpETest_q <= STD_LOGIC_VECTOR(eP2CWRnd_uid57_fpExpETest_o(11 downto 0));

    -- expTmp_uid58_fpExpETest(BITSELECT,57)@3
    expTmp_uid58_fpExpETest_in <= STD_LOGIC_VECTOR(eP2CWRnd_uid57_fpExpETest_q(9 downto 0));
    expTmp_uid58_fpExpETest_b <= expTmp_uid58_fpExpETest_in(9 downto 2);

    -- floatTable_kPPreZHigh_uid63_fpExpETest_lutmem(DUALMEM,271)@3 + 2
    floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_aa <= expTmp_uid58_fpExpETest_b;
    floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ena_NotRstA <= not (areset) and en(0);
    floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_reset0 <= areset;
    floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 32,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_kPPreZHigh_uid63_fpExpETest_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ena_NotRstA,
        sclr => floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_reset0,
        clock0 => clk,
        address_a => floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_aa,
        q_a => floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ir
    );
    floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r <= STD_LOGIC_VECTOR(floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_ir(31 downto 0));

    -- bit7_uid59_fpExpETest(BITSELECT,58)@3
    bit7_uid59_fpExpETest_in <= STD_LOGIC_VECTOR(eP2CWRnd_uid57_fpExpETest_q(10 downto 0));
    bit7_uid59_fpExpETest_b <= bit7_uid59_fpExpETest_in(10 downto 10);

    -- invBit7_uid60_fpExpETest(LOGICAL,59)@3
    invBit7_uid60_fpExpETest_q <= STD_LOGIC_VECTOR(not (bit7_uid59_fpExpETest_b));

    -- bit8_uid61_fpExpETest(BITSELECT,60)@3
    bit8_uid61_fpExpETest_in <= STD_LOGIC_VECTOR(eP2CWRnd_uid57_fpExpETest_q(9 downto 0));
    bit8_uid61_fpExpETest_b <= bit8_uid61_fpExpETest_in(9 downto 9);

    -- maxExpCond_uid62_fpExpETest(LOGICAL,61)@3 + 1
    maxExpCond_uid62_fpExpETest_qi <= bit8_uid61_fpExpETest_b and invBit7_uid60_fpExpETest_q;
    maxExpCond_uid62_fpExpETest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => maxExpCond_uid62_fpExpETest_qi, xout => maxExpCond_uid62_fpExpETest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist15_maxExpCond_uid62_fpExpETest_q_2(DELAY,343)
    redist15_maxExpCond_uid62_fpExpETest_q_2_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist15_maxExpCond_uid62_fpExpETest_q_2_q <= maxExpCond_uid62_fpExpETest_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- kPZHigh_uid73_fpExpETest(MUX,72)@5
    kPZHigh_uid73_fpExpETest_s <= redist15_maxExpCond_uid62_fpExpETest_q_2_q;
    kPZHigh_uid73_fpExpETest_combproc: PROCESS (kPZHigh_uid73_fpExpETest_s, en, floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r, cste128h_uid72_fpExpETest_b_const_q)
    BEGIN
        CASE (kPZHigh_uid73_fpExpETest_s) IS
            WHEN "0" => kPZHigh_uid73_fpExpETest_q <= floatTable_kPPreZHigh_uid63_fpExpETest_lutmem_r;
            WHEN "1" => kPZHigh_uid73_fpExpETest_q <= cste128h_uid72_fpExpETest_b_const_q;
            WHEN OTHERS => kPZHigh_uid73_fpExpETest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- ySign_uid77_fpExpETest(BITSELECT,76)@5
    ySign_uid77_fpExpETest_b <= kPZHigh_uid73_fpExpETest_q(31 downto 31);

    -- invYSign_uid80_fpExpETest(LOGICAL,79)@5
    invYSign_uid80_fpExpETest_q <= STD_LOGIC_VECTOR(not (ySign_uid77_fpExpETest_b));

    -- exp_uid79_fpExpETest(BITSELECT,78)@5
    exp_uid79_fpExpETest_in <= kPZHigh_uid73_fpExpETest_q(30 downto 0);
    exp_uid79_fpExpETest_b <= STD_LOGIC_VECTOR(exp_uid79_fpExpETest_in(30 downto 23));

    -- fraction_uid78_fpExpETest(BITSELECT,77)@5
    fraction_uid78_fpExpETest_in <= kPZHigh_uid73_fpExpETest_q(22 downto 0);
    fraction_uid78_fpExpETest_b <= STD_LOGIC_VECTOR(fraction_uid78_fpExpETest_in(22 downto 0));

    -- minusY_uid81_fpExpETest(BITJOIN,80)@5
    minusY_uid81_fpExpETest_q <= invYSign_uid80_fpExpETest_q & exp_uid79_fpExpETest_b & fraction_uid78_fpExpETest_b;

    -- yP0_uid82_fpExpETest_impl(FPCOLUMN,273)@5
    -- out q0@8
    yP0_uid82_fpExpETest_impl_ax0 <= STD_LOGIC_VECTOR(minusY_uid81_fpExpETest_q);
    yP0_uid82_fpExpETest_impl_ay0 <= redist23_xIn_a_5_q;
    yP0_uid82_fpExpETest_impl_reset0 <= '0';
    yP0_uid82_fpExpETest_impl_ena0 <= en(0) or yP0_uid82_fpExpETest_impl_reset0;
    yP0_uid82_fpExpETest_impl_DSP0 : tennm_fp_mac
    GENERIC MAP (
        operation_mode => "fp32_add",
        fp32_adder_a_clken => "0",
        fp32_adder_b_clken => "0",
        adder_input_clken => "0",
        output_clken => "0",
        clear_type => "none"
    )
    PORT MAP (
        clk => clk,
        ena(0) => yP0_uid82_fpExpETest_impl_ena0,
        ena(1) => '0',
        ena(2) => '0',
        clr(0) => yP0_uid82_fpExpETest_impl_reset0,
        clr(1) => yP0_uid82_fpExpETest_impl_reset0,
        fp32_adder_a => yP0_uid82_fpExpETest_impl_ax0,
        fp32_adder_b => yP0_uid82_fpExpETest_impl_ay0,
        fp32_result => yP0_uid82_fpExpETest_impl_q0
    );

    -- redist9_yP0_uid82_fpExpETest_impl_q0_1(DELAY,337)
    redist9_yP0_uid82_fpExpETest_impl_q0_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist9_yP0_uid82_fpExpETest_impl_q0_1_q <= yP0_uid82_fpExpETest_impl_q0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- cste128l_uid75_fpExpETest_b_const(CONSTANT,245)
    cste128l_uid75_fpExpETest_b_const_q <= "00110110111101111101000111001111";

    -- redist17_expTmp_uid58_fpExpETest_b_4(DELAY,345)
    redist17_expTmp_uid58_fpExpETest_b_4_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist17_expTmp_uid58_fpExpETest_b_4_delay_0 <= STD_LOGIC_VECTOR(expTmp_uid58_fpExpETest_b);
                    redist17_expTmp_uid58_fpExpETest_b_4_delay_1 <= redist17_expTmp_uid58_fpExpETest_b_4_delay_0;
                    redist17_expTmp_uid58_fpExpETest_b_4_delay_2 <= redist17_expTmp_uid58_fpExpETest_b_4_delay_1;
                    redist17_expTmp_uid58_fpExpETest_b_4_q <= STD_LOGIC_VECTOR(redist17_expTmp_uid58_fpExpETest_b_4_delay_2);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- floatTable_kPPreZLow_uid67_fpExpETest_lutmem(DUALMEM,272)@7 + 2
    floatTable_kPPreZLow_uid67_fpExpETest_lutmem_aa <= redist17_expTmp_uid58_fpExpETest_b_4_q;
    floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ena_NotRstA <= not (areset) and en(0);
    floatTable_kPPreZLow_uid67_fpExpETest_lutmem_reset0 <= areset;
    floatTable_kPPreZLow_uid67_fpExpETest_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 32,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_kPPreZLow_uid67_fpExpETest_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ena_NotRstA,
        sclr => floatTable_kPPreZLow_uid67_fpExpETest_lutmem_reset0,
        clock0 => clk,
        address_a => floatTable_kPPreZLow_uid67_fpExpETest_lutmem_aa,
        q_a => floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ir
    );
    floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r <= STD_LOGIC_VECTOR(floatTable_kPPreZLow_uid67_fpExpETest_lutmem_ir(31 downto 0));

    -- redist16_maxExpCond_uid62_fpExpETest_q_6(DELAY,344)
    redist16_maxExpCond_uid62_fpExpETest_q_6_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist16_maxExpCond_uid62_fpExpETest_q_6_delay_0 <= STD_LOGIC_VECTOR(redist15_maxExpCond_uid62_fpExpETest_q_2_q);
                    redist16_maxExpCond_uid62_fpExpETest_q_6_delay_1 <= redist16_maxExpCond_uid62_fpExpETest_q_6_delay_0;
                    redist16_maxExpCond_uid62_fpExpETest_q_6_delay_2 <= redist16_maxExpCond_uid62_fpExpETest_q_6_delay_1;
                    redist16_maxExpCond_uid62_fpExpETest_q_6_q <= STD_LOGIC_VECTOR(redist16_maxExpCond_uid62_fpExpETest_q_6_delay_2);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- kPZLow_uid76_fpExpETest(MUX,75)@9
    kPZLow_uid76_fpExpETest_s <= redist16_maxExpCond_uid62_fpExpETest_q_6_q;
    kPZLow_uid76_fpExpETest_combproc: PROCESS (kPZLow_uid76_fpExpETest_s, en, floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r, cste128l_uid75_fpExpETest_b_const_q)
    BEGIN
        CASE (kPZLow_uid76_fpExpETest_s) IS
            WHEN "0" => kPZLow_uid76_fpExpETest_q <= floatTable_kPPreZLow_uid67_fpExpETest_lutmem_r;
            WHEN "1" => kPZLow_uid76_fpExpETest_q <= cste128l_uid75_fpExpETest_b_const_q;
            WHEN OTHERS => kPZLow_uid76_fpExpETest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- ySign_uid83_fpExpETest(BITSELECT,82)@9
    ySign_uid83_fpExpETest_b <= kPZLow_uid76_fpExpETest_q(31 downto 31);

    -- invYSign_uid86_fpExpETest(LOGICAL,85)@9
    invYSign_uid86_fpExpETest_q <= STD_LOGIC_VECTOR(not (ySign_uid83_fpExpETest_b));

    -- exp_uid85_fpExpETest(BITSELECT,84)@9
    exp_uid85_fpExpETest_in <= kPZLow_uid76_fpExpETest_q(30 downto 0);
    exp_uid85_fpExpETest_b <= STD_LOGIC_VECTOR(exp_uid85_fpExpETest_in(30 downto 23));

    -- fraction_uid84_fpExpETest(BITSELECT,83)@9
    fraction_uid84_fpExpETest_in <= kPZLow_uid76_fpExpETest_q(22 downto 0);
    fraction_uid84_fpExpETest_b <= STD_LOGIC_VECTOR(fraction_uid84_fpExpETest_in(22 downto 0));

    -- minusY_uid87_fpExpETest(BITJOIN,86)@9
    minusY_uid87_fpExpETest_q <= invYSign_uid86_fpExpETest_q & exp_uid85_fpExpETest_b & fraction_uid84_fpExpETest_b;

    -- yP_uid88_fpExpETest_impl(FPCOLUMN,275)@9
    -- out q0@12
    yP_uid88_fpExpETest_impl_ax0 <= STD_LOGIC_VECTOR(minusY_uid87_fpExpETest_q);
    yP_uid88_fpExpETest_impl_ay0 <= redist9_yP0_uid82_fpExpETest_impl_q0_1_q;
    yP_uid88_fpExpETest_impl_reset0 <= '0';
    yP_uid88_fpExpETest_impl_ena0 <= en(0) or yP_uid88_fpExpETest_impl_reset0;
    yP_uid88_fpExpETest_impl_DSP0 : tennm_fp_mac
    GENERIC MAP (
        operation_mode => "fp32_add",
        fp32_adder_a_clken => "0",
        fp32_adder_b_clken => "0",
        adder_input_clken => "0",
        output_clken => "0",
        clear_type => "none"
    )
    PORT MAP (
        clk => clk,
        ena(0) => yP_uid88_fpExpETest_impl_ena0,
        ena(1) => '0',
        ena(2) => '0',
        clr(0) => yP_uid88_fpExpETest_impl_reset0,
        clr(1) => yP_uid88_fpExpETest_impl_reset0,
        fp32_adder_a => yP_uid88_fpExpETest_impl_ax0,
        fp32_adder_b => yP_uid88_fpExpETest_impl_ay0,
        fp32_result => yP_uid88_fpExpETest_impl_q0
    );

    -- signYP_uid91_fpExpETest(BITSELECT,90)@12
    signYP_uid91_fpExpETest_b <= yP_uid88_fpExpETest_impl_q0(31 downto 31);

    -- redist14_signYP_uid91_fpExpETest_b_12(DELAY,342)
    redist14_signYP_uid91_fpExpETest_b_12 : dspba_delay
    GENERIC MAP ( width => 1, depth => 12, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => signYP_uid91_fpExpETest_b, xout => redist14_signYP_uid91_fpExpETest_b_12_q, ena => en(0), clk => clk, aclr => areset );

    -- redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt(COUNTER,357)
    -- low=0, high=8, step=1, init=0
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i <= TO_UNSIGNED(0, 4);
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i = TO_UNSIGNED(7, 4)) THEN
                        redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq <= '1';
                    ELSE
                        redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq <= '0';
                    END IF;
                    IF (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_eq = '1') THEN
                        redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i + 8;
                    ELSE
                        redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_i, 4));

    -- redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux(MUX,358)
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s <= en;
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_combproc: PROCESS (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s, redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q, redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q)
    BEGIN
        CASE (redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_s) IS
            WHEN "0" => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q;
            WHEN "1" => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdcnt_q;
            WHEN OTHERS => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest(BITSELECT,290)@13
    rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest_b <= STD_LOGIC_VECTOR(rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q(7 downto 4));

    -- rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest(BITJOIN,292)@13
    rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest_q <= rightShiftStage1Idx1Pad4_uid267_fxpXRed_uid47_fpExpETest_q & rightShiftStage1Idx1Rng4_uid291_fxpA_uid98_fpExpETest_b;

    -- rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest(BITSELECT,285)@12
    rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest_b <= STD_LOGIC_VECTOR(fxpAPreAlign_uid95_fpExpETest_q(7 downto 3));

    -- rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest(BITJOIN,287)@12
    rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx3Pad3_uid262_fxpXRed_uid47_fpExpETest_q & rightShiftStage0Idx3Rng3_uid286_fxpA_uid98_fpExpETest_b;

    -- rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest(BITSELECT,282)@12
    rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest_b <= STD_LOGIC_VECTOR(fxpAPreAlign_uid95_fpExpETest_q(7 downto 2));

    -- rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest(BITJOIN,284)@12
    rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx2Pad2_uid259_fxpXRed_uid47_fpExpETest_q & rightShiftStage0Idx2Rng2_uid283_fxpA_uid98_fpExpETest_b;

    -- rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest(BITSELECT,279)@12
    rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest_b <= STD_LOGIC_VECTOR(fxpAPreAlign_uid95_fpExpETest_q(7 downto 1));

    -- rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest(BITJOIN,281)@12
    rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest_q <= GND_q & rightShiftStage0Idx1Rng1_uid280_fxpA_uid98_fpExpETest_b;

    -- fracYP_uid89_fpExpETest(BITSELECT,88)@12
    fracYP_uid89_fpExpETest_b <= STD_LOGIC_VECTOR(yP_uid88_fpExpETest_impl_q0(22 downto 0));

    -- fracYPTop_uid93_fpExpETest(BITSELECT,92)@12
    fracYPTop_uid93_fpExpETest_b <= STD_LOGIC_VECTOR(fracYP_uid89_fpExpETest_b(22 downto 16));

    -- fxpAPreAlign_uid95_fpExpETest(BITJOIN,94)@12
    fxpAPreAlign_uid95_fpExpETest_q <= VCC_q & fracYPTop_uid93_fpExpETest_b;

    -- expYP_uid90_fpExpETest(BITSELECT,89)@12
    expYP_uid90_fpExpETest_b <= STD_LOGIC_VECTOR(yP_uid88_fpExpETest_impl_q0(30 downto 23));

    -- cstBiasM1_uid10_fpExpETest(CONSTANT,9)
    cstBiasM1_uid10_fpExpETest_q <= "01111110";

    -- shiftValFxpA_uid96_fpExpETest(SUB,95)@12
    shiftValFxpA_uid96_fpExpETest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & cstBiasM1_uid10_fpExpETest_q));
    shiftValFxpA_uid96_fpExpETest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & expYP_uid90_fpExpETest_b));
    shiftValFxpA_uid96_fpExpETest_o <= STD_LOGIC_VECTOR(SIGNED(shiftValFxpA_uid96_fpExpETest_a) - SIGNED(shiftValFxpA_uid96_fpExpETest_b));
    shiftValFxpA_uid96_fpExpETest_q <= STD_LOGIC_VECTOR(shiftValFxpA_uid96_fpExpETest_o(8 downto 0));

    -- shiftValFxpAR_uid97_fpExpETest(BITSELECT,96)@12
    shiftValFxpAR_uid97_fpExpETest_in <= shiftValFxpA_uid96_fpExpETest_q(3 downto 0);
    shiftValFxpAR_uid97_fpExpETest_b <= STD_LOGIC_VECTOR(shiftValFxpAR_uid97_fpExpETest_in(3 downto 0));

    -- rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged(BITSELECT,324)@12
    rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_b <= STD_LOGIC_VECTOR(shiftValFxpAR_uid97_fpExpETest_b(1 downto 0));
    rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c <= STD_LOGIC_VECTOR(shiftValFxpAR_uid97_fpExpETest_b(3 downto 2));

    -- rightShiftStage0_uid290_fxpA_uid98_fpExpETest(MUX,289)@12 + 1
    rightShiftStage0_uid290_fxpA_uid98_fpExpETest_s <= rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_b;
    rightShiftStage0_uid290_fxpA_uid98_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (rightShiftStage0_uid290_fxpA_uid98_fpExpETest_s) IS
                        WHEN "00" => rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= fxpAPreAlign_uid95_fpExpETest_q;
                        WHEN "01" => rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx1_uid282_fxpA_uid98_fpExpETest_q;
                        WHEN "10" => rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx2_uid285_fxpA_uid98_fpExpETest_q;
                        WHEN "11" => rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= rightShiftStage0Idx3_uid288_fxpA_uid98_fpExpETest_q;
                        WHEN OTHERS => rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1(DELAY,328)
    redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_q <= rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- rightShiftStage1_uid297_fxpA_uid98_fpExpETest(MUX,296)@13 + 1
    rightShiftStage1_uid297_fxpA_uid98_fpExpETest_s <= redist0_rightShiftStageSel0Dto0_uid289_fxpA_uid98_fpExpETest_bit_select_merged_c_1_q;
    rightShiftStage1_uid297_fxpA_uid98_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (rightShiftStage1_uid297_fxpA_uid98_fpExpETest_s) IS
                        WHEN "00" => rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= rightShiftStage0_uid290_fxpA_uid98_fpExpETest_q;
                        WHEN "01" => rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= rightShiftStage1Idx1_uid293_fxpA_uid98_fpExpETest_q;
                        WHEN "10" => rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= cstZeroWE_uid14_fpExpETest_q;
                        WHEN "11" => rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= cstZeroWE_uid14_fpExpETest_q;
                        WHEN OTHERS => rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr(REG,359)
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q <= "1000";
            ELSE
                redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem(DUALMEM,356)
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ia <= STD_LOGIC_VECTOR(rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q);
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_aa <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_wraddr_q;
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ab <= redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_rdmux_q;
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ena_OrRstB <= areset or en(0);
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 8,
        widthad_a => 4,
        numwords_a => 9,
        width_b => 8,
        widthad_b => 4,
        numwords_b => 9,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_sclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken1 => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_aa,
        data_a => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ia,
        wren_a => en(0),
        address_b => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_ab,
        q_b => redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_iq
    );
    redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_q <= STD_LOGIC_VECTOR(redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_iq(7 downto 0));

    -- addrEATable_uid99_fpExpETest(BITJOIN,98)@24
    addrEATable_uid99_fpExpETest_q <= redist14_signYP_uid91_fpExpETest_b_12_q & redist7_rightShiftStage1_uid297_fxpA_uid98_fpExpETest_q_11_mem_q;

    -- floatTable_eA_uid100_fpExpETest_lutmem(DUALMEM,298)@24 + 2
    floatTable_eA_uid100_fpExpETest_lutmem_aa <= addrEATable_uid99_fpExpETest_q;
    floatTable_eA_uid100_fpExpETest_lutmem_ena_NotRstA <= not (areset) and en(0);
    floatTable_eA_uid100_fpExpETest_lutmem_reset0 <= areset;
    floatTable_eA_uid100_fpExpETest_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 32,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_eA_uid100_fpExpETest_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => floatTable_eA_uid100_fpExpETest_lutmem_ena_NotRstA,
        sclr => floatTable_eA_uid100_fpExpETest_lutmem_reset0,
        clock0 => clk,
        address_a => floatTable_eA_uid100_fpExpETest_lutmem_aa,
        q_a => floatTable_eA_uid100_fpExpETest_lutmem_ir
    );
    floatTable_eA_uid100_fpExpETest_lutmem_r <= STD_LOGIC_VECTOR(floatTable_eA_uid100_fpExpETest_lutmem_ir(31 downto 0));

    -- udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319(CONSTANT,318)
    udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q <= "01111";

    -- expYPBottom_uid92_fpExpETest_bit_select_merged(BITSELECT,323)@12
    expYPBottom_uid92_fpExpETest_bit_select_merged_b <= STD_LOGIC_VECTOR(expYP_uid90_fpExpETest_b(2 downto 0));
    expYPBottom_uid92_fpExpETest_bit_select_merged_c <= STD_LOGIC_VECTOR(expYP_uid90_fpExpETest_b(7 downto 3));

    -- udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321(COMPARE,320)@12
    udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expYPBottom_uid92_fpExpETest_bit_select_merged_c));
    udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 5 => udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q(4)) & udfA_uid105_fpExpETest_new_compare_to_301_new_const_trz_319_q));
    udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_o <= STD_LOGIC_VECTOR(SIGNED(udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_a) - SIGNED(udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_b));
    udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c(0) <= udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_o(7);

    -- redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14(DELAY,330)
    redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14 : dspba_delay
    GENERIC MAP ( width => 1, depth => 14, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c, xout => redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14_q, ena => en(0), clk => clk, aclr => areset );

    -- eAPostUdfA_uid108_fpExpETest(MUX,107)@26 + 1
    eAPostUdfA_uid108_fpExpETest_s <= redist2_udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c_14_q;
    eAPostUdfA_uid108_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                eAPostUdfA_uid108_fpExpETest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (eAPostUdfA_uid108_fpExpETest_s) IS
                        WHEN "0" => eAPostUdfA_uid108_fpExpETest_q <= floatTable_eA_uid100_fpExpETest_lutmem_r;
                        WHEN "1" => eAPostUdfA_uid108_fpExpETest_q <= oneFP_uid107_fpExpETest_b_const_q;
                        WHEN OTHERS => eAPostUdfA_uid108_fpExpETest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt(COUNTER,353)
    -- low=0, high=3, step=1, init=0
    redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i <= TO_UNSIGNED(0, 2);
            ELSE
                IF (en = "1") THEN
                    redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i <= redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_i, 2));

    -- redist6_b_uid120_fpExpETest_impl_q0_6_rdmux(MUX,354)
    redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s <= en;
    redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_combproc: PROCESS (redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s, redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q, redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q)
    BEGIN
        CASE (redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_s) IS
            WHEN "0" => redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q <= redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q;
            WHEN "1" => redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q <= redist6_b_uid120_fpExpETest_impl_q0_6_rdcnt_q;
            WHEN OTHERS => redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist8_yP_uid88_fpExpETest_impl_q0_1(DELAY,336)
    redist8_yP_uid88_fpExpETest_impl_q0_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist8_yP_uid88_fpExpETest_impl_q0_1_q <= yP_uid88_fpExpETest_impl_q0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- newExpA_uid113_fpExpETest(MUX,112)@12
    newExpA_uid113_fpExpETest_s <= udfA_uid105_fpExpETest_new_compare_to_301_new_compare_trz_321_c;
    newExpA_uid113_fpExpETest_combproc: PROCESS (newExpA_uid113_fpExpETest_s, en, expYP_uid90_fpExpETest_b, cstZeroWE_uid14_fpExpETest_q)
    BEGIN
        CASE (newExpA_uid113_fpExpETest_s) IS
            WHEN "0" => newExpA_uid113_fpExpETest_q <= expYP_uid90_fpExpETest_b;
            WHEN "1" => newExpA_uid113_fpExpETest_q <= cstZeroWE_uid14_fpExpETest_q;
            WHEN OTHERS => newExpA_uid113_fpExpETest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- maskAFP_uid109_fpExpETest(LOOKUP,108)@12
    maskAFP_uid109_fpExpETest_combproc: PROCESS (expYPBottom_uid92_fpExpETest_bit_select_merged_b)
    BEGIN
        -- Begin reserved scope level
        CASE (expYPBottom_uid92_fpExpETest_bit_select_merged_b) IS
            WHEN "000" => maskAFP_uid109_fpExpETest_q <= "1000000";
            WHEN "001" => maskAFP_uid109_fpExpETest_q <= "1100000";
            WHEN "010" => maskAFP_uid109_fpExpETest_q <= "1110000";
            WHEN "011" => maskAFP_uid109_fpExpETest_q <= "1111000";
            WHEN "100" => maskAFP_uid109_fpExpETest_q <= "1111100";
            WHEN "101" => maskAFP_uid109_fpExpETest_q <= "1111110";
            WHEN "110" => maskAFP_uid109_fpExpETest_q <= "1111111";
            WHEN "111" => maskAFP_uid109_fpExpETest_q <= "0000000";
            WHEN OTHERS => -- unreachable
                           maskAFP_uid109_fpExpETest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- fracYPTopPostMask_uid110_fpExpETest(LOGICAL,109)@12
    fracYPTopPostMask_uid110_fpExpETest_q <= STD_LOGIC_VECTOR(fracYPTop_uid93_fpExpETest_b and maskAFP_uid109_fpExpETest_q);

    -- cst16z_uid111_fpExpETest(CONSTANT,110)
    cst16z_uid111_fpExpETest_q <= "0000000000000000";

    -- fracAFull_uid112_fpExpETest(BITJOIN,111)@12
    fracAFull_uid112_fpExpETest_q <= fracYPTopPostMask_uid110_fpExpETest_q & cst16z_uid111_fpExpETest_q;

    -- a_uid114_fpExpETest(BITJOIN,113)@12
    a_uid114_fpExpETest_q <= signYP_uid91_fpExpETest_b & newExpA_uid113_fpExpETest_q & fracAFull_uid112_fpExpETest_q;

    -- ySign_uid115_fpExpETest(BITSELECT,114)@12
    ySign_uid115_fpExpETest_b <= a_uid114_fpExpETest_q(31 downto 31);

    -- invYSign_uid118_fpExpETest(LOGICAL,117)@12
    invYSign_uid118_fpExpETest_q <= STD_LOGIC_VECTOR(not (ySign_uid115_fpExpETest_b));

    -- exp_uid117_fpExpETest(BITSELECT,116)@12
    exp_uid117_fpExpETest_in <= a_uid114_fpExpETest_q(30 downto 0);
    exp_uid117_fpExpETest_b <= STD_LOGIC_VECTOR(exp_uid117_fpExpETest_in(30 downto 23));

    -- fraction_uid116_fpExpETest(BITSELECT,115)@12
    fraction_uid116_fpExpETest_in <= a_uid114_fpExpETest_q(22 downto 0);
    fraction_uid116_fpExpETest_b <= STD_LOGIC_VECTOR(fraction_uid116_fpExpETest_in(22 downto 0));

    -- minusY_uid119_fpExpETest(BITJOIN,118)@12
    minusY_uid119_fpExpETest_q <= invYSign_uid118_fpExpETest_q & exp_uid117_fpExpETest_b & fraction_uid116_fpExpETest_b;

    -- redist13_minusY_uid119_fpExpETest_q_1(DELAY,341)
    redist13_minusY_uid119_fpExpETest_q_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist13_minusY_uid119_fpExpETest_q_1_q <= minusY_uid119_fpExpETest_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- b_uid120_fpExpETest_impl(FPCOLUMN,301)@13
    -- out q0@16
    b_uid120_fpExpETest_impl_ax0 <= STD_LOGIC_VECTOR(redist13_minusY_uid119_fpExpETest_q_1_q);
    b_uid120_fpExpETest_impl_ay0 <= redist8_yP_uid88_fpExpETest_impl_q0_1_q;
    b_uid120_fpExpETest_impl_reset0 <= '0';
    b_uid120_fpExpETest_impl_ena0 <= en(0) or b_uid120_fpExpETest_impl_reset0;
    b_uid120_fpExpETest_impl_DSP0 : tennm_fp_mac
    GENERIC MAP (
        operation_mode => "fp32_add",
        fp32_adder_a_clken => "0",
        fp32_adder_b_clken => "0",
        adder_input_clken => "0",
        output_clken => "0",
        clear_type => "none"
    )
    PORT MAP (
        clk => clk,
        ena(0) => b_uid120_fpExpETest_impl_ena0,
        ena(1) => '0',
        ena(2) => '0',
        clr(0) => b_uid120_fpExpETest_impl_reset0,
        clr(1) => b_uid120_fpExpETest_impl_reset0,
        fp32_adder_a => b_uid120_fpExpETest_impl_ax0,
        fp32_adder_b => b_uid120_fpExpETest_impl_ay0,
        fp32_result => b_uid120_fpExpETest_impl_q0
    );

    -- redist5_b_uid120_fpExpETest_impl_q0_1(DELAY,333)
    redist5_b_uid120_fpExpETest_impl_q0_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist5_b_uid120_fpExpETest_impl_q0_1_q <= b_uid120_fpExpETest_impl_q0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist6_b_uid120_fpExpETest_impl_q0_6_wraddr(REG,355)
    redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q <= "11";
            ELSE
                redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q <= redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist6_b_uid120_fpExpETest_impl_q0_6_mem(DUALMEM,352)
    redist6_b_uid120_fpExpETest_impl_q0_6_mem_ia <= STD_LOGIC_VECTOR(redist5_b_uid120_fpExpETest_impl_q0_1_q);
    redist6_b_uid120_fpExpETest_impl_q0_6_mem_aa <= redist6_b_uid120_fpExpETest_impl_q0_6_wraddr_q;
    redist6_b_uid120_fpExpETest_impl_q0_6_mem_ab <= redist6_b_uid120_fpExpETest_impl_q0_6_rdmux_q;
    redist6_b_uid120_fpExpETest_impl_q0_6_mem_ena_OrRstB <= areset or en(0);
    redist6_b_uid120_fpExpETest_impl_q0_6_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 32,
        widthad_a => 2,
        numwords_a => 4,
        width_b => 32,
        widthad_b => 2,
        numwords_b => 4,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_sclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken1 => redist6_b_uid120_fpExpETest_impl_q0_6_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist6_b_uid120_fpExpETest_impl_q0_6_mem_aa,
        data_a => redist6_b_uid120_fpExpETest_impl_q0_6_mem_ia,
        wren_a => en(0),
        address_b => redist6_b_uid120_fpExpETest_impl_q0_6_mem_ab,
        q_b => redist6_b_uid120_fpExpETest_impl_q0_6_mem_iq
    );
    redist6_b_uid120_fpExpETest_impl_q0_6_mem_q <= STD_LOGIC_VECTOR(redist6_b_uid120_fpExpETest_impl_q0_6_mem_iq(31 downto 0));

    -- cstHalfFP_uid122_fpExpETest_b_const(CONSTANT,247)
    cstHalfFP_uid122_fpExpETest_b_const_q <= "00111111000000000000000000000000";

    -- oPBo2_uid123_fpExpETest_impl(FPCOLUMN,303)@17
    -- out q0@21
    oPBo2_uid123_fpExpETest_impl_ax0 <= STD_LOGIC_VECTOR(oneFP_uid107_fpExpETest_b_const_q);
    oPBo2_uid123_fpExpETest_impl_ay0 <= cstHalfFP_uid122_fpExpETest_b_const_q;
    oPBo2_uid123_fpExpETest_impl_az0 <= redist5_b_uid120_fpExpETest_impl_q0_1_q;
    oPBo2_uid123_fpExpETest_impl_reset0 <= '0';
    oPBo2_uid123_fpExpETest_impl_ena0 <= en(0) or oPBo2_uid123_fpExpETest_impl_reset0;
    oPBo2_uid123_fpExpETest_impl_DSP0 : tennm_fp_mac
    GENERIC MAP (
        operation_mode => "fp32_mult_add",
        fp32_adder_a_clken => "0",
        fp32_mult_a_clken => "0",
        fp32_mult_b_clken => "0",
        mult_2nd_pipeline_clken => "0",
        adder_input_clken => "0",
        fp32_adder_a_chainin_pl_clken => "0",
        output_clken => "0",
        clear_type => "none"
    )
    PORT MAP (
        clk => clk,
        ena(0) => oPBo2_uid123_fpExpETest_impl_ena0,
        ena(1) => '0',
        ena(2) => '0',
        clr(0) => oPBo2_uid123_fpExpETest_impl_reset0,
        clr(1) => oPBo2_uid123_fpExpETest_impl_reset0,
        fp32_adder_a => oPBo2_uid123_fpExpETest_impl_ax0,
        fp32_mult_a => oPBo2_uid123_fpExpETest_impl_ay0,
        fp32_mult_b => oPBo2_uid123_fpExpETest_impl_az0,
        fp32_result => oPBo2_uid123_fpExpETest_impl_q0
    );

    -- redist4_oPBo2_uid123_fpExpETest_impl_q0_1(DELAY,332)
    redist4_oPBo2_uid123_fpExpETest_impl_q0_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist4_oPBo2_uid123_fpExpETest_impl_q0_1_q <= oPBo2_uid123_fpExpETest_impl_q0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- eB_uid124_fpExpETest_impl(FPCOLUMN,306)@22
    -- out q0@26
    eB_uid124_fpExpETest_impl_ax0 <= STD_LOGIC_VECTOR(oneFP_uid107_fpExpETest_b_const_q);
    eB_uid124_fpExpETest_impl_ay0 <= redist4_oPBo2_uid123_fpExpETest_impl_q0_1_q;
    eB_uid124_fpExpETest_impl_az0 <= redist6_b_uid120_fpExpETest_impl_q0_6_mem_q;
    eB_uid124_fpExpETest_impl_reset0 <= '0';
    eB_uid124_fpExpETest_impl_ena0 <= en(0) or eB_uid124_fpExpETest_impl_reset0;
    eB_uid124_fpExpETest_impl_DSP0 : tennm_fp_mac
    GENERIC MAP (
        operation_mode => "fp32_mult_add",
        fp32_adder_a_clken => "0",
        fp32_mult_a_clken => "0",
        fp32_mult_b_clken => "0",
        mult_2nd_pipeline_clken => "0",
        adder_input_clken => "0",
        fp32_adder_a_chainin_pl_clken => "0",
        output_clken => "0",
        clear_type => "none"
    )
    PORT MAP (
        clk => clk,
        ena(0) => eB_uid124_fpExpETest_impl_ena0,
        ena(1) => '0',
        ena(2) => '0',
        clr(0) => eB_uid124_fpExpETest_impl_reset0,
        clr(1) => eB_uid124_fpExpETest_impl_reset0,
        fp32_adder_a => eB_uid124_fpExpETest_impl_ax0,
        fp32_mult_a => eB_uid124_fpExpETest_impl_ay0,
        fp32_mult_b => eB_uid124_fpExpETest_impl_az0,
        fp32_result => eB_uid124_fpExpETest_impl_q0
    );

    -- redist3_eB_uid124_fpExpETest_impl_q0_1(DELAY,331)
    redist3_eB_uid124_fpExpETest_impl_q0_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist3_eB_uid124_fpExpETest_impl_q0_1_q <= eB_uid124_fpExpETest_impl_q0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- eY_uid125_fpExpETest_impl(FPCOLUMN,309)@27
    -- out q0@30
    eY_uid125_fpExpETest_impl_ay0 <= redist3_eB_uid124_fpExpETest_impl_q0_1_q;
    eY_uid125_fpExpETest_impl_az0 <= eAPostUdfA_uid108_fpExpETest_q;
    eY_uid125_fpExpETest_impl_reset0 <= '0';
    eY_uid125_fpExpETest_impl_ena0 <= en(0) or eY_uid125_fpExpETest_impl_reset0;
    eY_uid125_fpExpETest_impl_DSP0 : tennm_fp_mac
    GENERIC MAP (
        operation_mode => "fp32_mult",
        fp32_mult_a_clken => "0",
        fp32_mult_b_clken => "0",
        mult_2nd_pipeline_clken => "0",
        output_clken => "0",
        clear_type => "none"
    )
    PORT MAP (
        clk => clk,
        ena(0) => eY_uid125_fpExpETest_impl_ena0,
        ena(1) => '0',
        ena(2) => '0',
        clr(0) => eY_uid125_fpExpETest_impl_reset0,
        clr(1) => eY_uid125_fpExpETest_impl_reset0,
        fp32_mult_a => eY_uid125_fpExpETest_impl_ay0,
        fp32_mult_b => eY_uid125_fpExpETest_impl_az0,
        fp32_result => eY_uid125_fpExpETest_impl_q0
    );

    -- signEY_uid152_fpExpETest(BITSELECT,151)@30
    signEY_uid152_fpExpETest_b <= eY_uid125_fpExpETest_impl_q0(31 downto 31);

    -- redist10_signEY_uid152_fpExpETest_b_1(DELAY,338)
    redist10_signEY_uid152_fpExpETest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist10_signEY_uid152_fpExpETest_b_1_q <= signEY_uid152_fpExpETest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- cstAllOWE_uid17_fpExpETest(CONSTANT,16)
    cstAllOWE_uid17_fpExpETest_q <= "11111111";

    -- cstBias_uid9_fpExpETest(CONSTANT,8)
    cstBias_uid9_fpExpETest_q <= "01111111";

    -- biasM2_uid129_fpExpETest(CONSTANT,128)
    biasM2_uid129_fpExpETest_q <= "01111101";

    -- biasP1_uid130_fpExpETest(CONSTANT,129)
    biasP1_uid130_fpExpETest_q <= "10000000";

    -- expEY_uid126_fpExpETest(BITSELECT,125)@30
    expEY_uid126_fpExpETest_b <= STD_LOGIC_VECTOR(eY_uid125_fpExpETest_impl_q0(30 downto 23));

    -- lowerBitOfeY_uid127_fpExpETest(BITSELECT,126)@30
    lowerBitOfeY_uid127_fpExpETest_in <= expEY_uid126_fpExpETest_b(1 downto 0);
    lowerBitOfeY_uid127_fpExpETest_b <= STD_LOGIC_VECTOR(lowerBitOfeY_uid127_fpExpETest_in(1 downto 0));

    -- expUpdateVal_uid131_fpExpETest(MUX,130)@30 + 1
    expUpdateVal_uid131_fpExpETest_s <= lowerBitOfeY_uid127_fpExpETest_b;
    expUpdateVal_uid131_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                expUpdateVal_uid131_fpExpETest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (expUpdateVal_uid131_fpExpETest_s) IS
                        WHEN "00" => expUpdateVal_uid131_fpExpETest_q <= biasP1_uid130_fpExpETest_q;
                        WHEN "01" => expUpdateVal_uid131_fpExpETest_q <= biasM2_uid129_fpExpETest_q;
                        WHEN "10" => expUpdateVal_uid131_fpExpETest_q <= cstBiasM1_uid10_fpExpETest_q;
                        WHEN "11" => expUpdateVal_uid131_fpExpETest_q <= cstBias_uid9_fpExpETest_q;
                        WHEN OTHERS => expUpdateVal_uid131_fpExpETest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist18_expTmp_uid58_fpExpETest_b_28_rdcnt(COUNTER,366)
    -- low=0, high=21, step=1, init=0
    redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i <= TO_UNSIGNED(0, 5);
                redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i = TO_UNSIGNED(20, 5)) THEN
                        redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq <= '1';
                    ELSE
                        redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq <= '0';
                    END IF;
                    IF (redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_eq = '1') THEN
                        redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i <= redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i + 11;
                    ELSE
                        redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i <= redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_i, 5));

    -- redist18_expTmp_uid58_fpExpETest_b_28_rdmux(MUX,367)
    redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s <= en;
    redist18_expTmp_uid58_fpExpETest_b_28_rdmux_combproc: PROCESS (redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s, redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q, redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q)
    BEGIN
        CASE (redist18_expTmp_uid58_fpExpETest_b_28_rdmux_s) IS
            WHEN "0" => redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q <= redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q;
            WHEN "1" => redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q <= redist18_expTmp_uid58_fpExpETest_b_28_rdcnt_q;
            WHEN OTHERS => redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist18_expTmp_uid58_fpExpETest_b_28_wraddr(REG,368)
    redist18_expTmp_uid58_fpExpETest_b_28_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q <= "10101";
            ELSE
                redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q <= redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist18_expTmp_uid58_fpExpETest_b_28_mem(DUALMEM,365)
    redist18_expTmp_uid58_fpExpETest_b_28_mem_ia <= STD_LOGIC_VECTOR(redist17_expTmp_uid58_fpExpETest_b_4_q);
    redist18_expTmp_uid58_fpExpETest_b_28_mem_aa <= redist18_expTmp_uid58_fpExpETest_b_28_wraddr_q;
    redist18_expTmp_uid58_fpExpETest_b_28_mem_ab <= redist18_expTmp_uid58_fpExpETest_b_28_rdmux_q;
    redist18_expTmp_uid58_fpExpETest_b_28_mem_ena_OrRstB <= areset or en(0);
    redist18_expTmp_uid58_fpExpETest_b_28_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 8,
        widthad_a => 5,
        numwords_a => 22,
        width_b => 8,
        widthad_b => 5,
        numwords_b => 22,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_sclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken1 => redist18_expTmp_uid58_fpExpETest_b_28_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist18_expTmp_uid58_fpExpETest_b_28_mem_aa,
        data_a => redist18_expTmp_uid58_fpExpETest_b_28_mem_ia,
        wren_a => en(0),
        address_b => redist18_expTmp_uid58_fpExpETest_b_28_mem_ab,
        q_b => redist18_expTmp_uid58_fpExpETest_b_28_mem_iq
    );
    redist18_expTmp_uid58_fpExpETest_b_28_mem_q <= STD_LOGIC_VECTOR(redist18_expTmp_uid58_fpExpETest_b_28_mem_iq(7 downto 0));

    -- redist18_expTmp_uid58_fpExpETest_b_28_outputreg0(DELAY,364)
    redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q <= redist18_expTmp_uid58_fpExpETest_b_28_mem_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- updatedExponent_uid132_fpExpETest(ADD,131)@31
    updatedExponent_uid132_fpExpETest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 8 => redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q(7)) & redist18_expTmp_uid58_fpExpETest_b_28_outputreg0_q));
    updatedExponent_uid132_fpExpETest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expUpdateVal_uid131_fpExpETest_q));
    updatedExponent_uid132_fpExpETest_o <= STD_LOGIC_VECTOR(SIGNED(updatedExponent_uid132_fpExpETest_a) + SIGNED(updatedExponent_uid132_fpExpETest_b));
    updatedExponent_uid132_fpExpETest_q <= STD_LOGIC_VECTOR(updatedExponent_uid132_fpExpETest_o(9 downto 0));

    -- expR_uid133_fpExpETest(BITSELECT,132)@31
    expR_uid133_fpExpETest_in <= updatedExponent_uid132_fpExpETest_q(7 downto 0);
    expR_uid133_fpExpETest_b <= STD_LOGIC_VECTOR(expR_uid133_fpExpETest_in(7 downto 0));

    -- redist12_excREnc_uid142_fpExpETest_q_29_rdcnt(COUNTER,361)
    -- low=0, high=26, step=1, init=0
    redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i <= TO_UNSIGNED(0, 5);
                redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i = TO_UNSIGNED(25, 5)) THEN
                        redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq <= '1';
                    ELSE
                        redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq <= '0';
                    END IF;
                    IF (redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_eq = '1') THEN
                        redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i <= redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i + 6;
                    ELSE
                        redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i <= redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_i, 5));

    -- redist12_excREnc_uid142_fpExpETest_q_29_rdmux(MUX,362)
    redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s <= en;
    redist12_excREnc_uid142_fpExpETest_q_29_rdmux_combproc: PROCESS (redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s, redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q, redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q)
    BEGIN
        CASE (redist12_excREnc_uid142_fpExpETest_q_29_rdmux_s) IS
            WHEN "0" => redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q <= redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q;
            WHEN "1" => redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q <= redist12_excREnc_uid142_fpExpETest_q_29_rdcnt_q;
            WHEN OTHERS => redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- cstZeroWF_uid18_fpExpETest(CONSTANT,17)
    cstZeroWF_uid18_fpExpETest_q <= "00000000000000000000000";

    -- fracXIsZero_uid24_fpExpETest(LOGICAL,23)@1 + 1
    fracXIsZero_uid24_fpExpETest_qi <= "1" WHEN cstZeroWF_uid18_fpExpETest_q = fracX_uid8_fpExpETest_b ELSE "0";
    fracXIsZero_uid24_fpExpETest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracXIsZero_uid24_fpExpETest_qi, xout => fracXIsZero_uid24_fpExpETest_q, ena => en(0), clk => clk, aclr => areset );

    -- fracXIsNotZero_uid25_fpExpETest(LOGICAL,24)@2
    fracXIsNotZero_uid25_fpExpETest_q <= STD_LOGIC_VECTOR(not (fracXIsZero_uid24_fpExpETest_q));

    -- redist20_expX_uid6_fpExpETest_b_1(DELAY,348)
    redist20_expX_uid6_fpExpETest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist20_expX_uid6_fpExpETest_b_1_q <= expX_uid6_fpExpETest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expXIsMax_uid23_fpExpETest(LOGICAL,22)@1 + 1
    expXIsMax_uid23_fpExpETest_qi <= "1" WHEN redist20_expX_uid6_fpExpETest_b_1_q = cstAllOWE_uid17_fpExpETest_q ELSE "0";
    expXIsMax_uid23_fpExpETest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => expXIsMax_uid23_fpExpETest_qi, xout => expXIsMax_uid23_fpExpETest_q, ena => en(0), clk => clk, aclr => areset );

    -- excN_x_uid27_fpExpETest(LOGICAL,26)@2
    excN_x_uid27_fpExpETest_q <= STD_LOGIC_VECTOR(expXIsMax_uid23_fpExpETest_q and fracXIsNotZero_uid25_fpExpETest_q);

    -- expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313(CONSTANT,312)
    expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313_q <= "1000010101100010111001000011";

    -- expFracX_uid31_fpExpETest(BITJOIN,30)@1
    expFracX_uid31_fpExpETest_q <= redist20_expX_uid6_fpExpETest_b_1_q & fracX_uid8_fpExpETest_b;

    -- expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314(BITSELECT,313)@1
    expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314_b <= STD_LOGIC_VECTOR(expFracX_uid31_fpExpETest_q(30 downto 3));

    -- expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315(COMPARE,314)@1 + 1
    expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_a <= STD_LOGIC_VECTOR("00" & expMaxInput_uid33_fpExpETest_new_compare_to_250_bit_select_top_X_trz_314_b);
    expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_b <= STD_LOGIC_VECTOR("00" & expMaxInput_uid33_fpExpETest_new_compare_to_250_new_const_trz_313_q);
    expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o <= STD_LOGIC_VECTOR(UNSIGNED(expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_a) - UNSIGNED(expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_n(0) <= not (expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_o(29));

    -- invSignX_uid34_fpExpETest(LOGICAL,33)@2
    invSignX_uid34_fpExpETest_q <= STD_LOGIC_VECTOR(not (signX_uid7_fpExpETest_b));

    -- inputOverflow_uid35_fpExpETest(LOGICAL,34)@2
    inputOverflow_uid35_fpExpETest_q <= STD_LOGIC_VECTOR(invSignX_uid34_fpExpETest_q and expMaxInput_uid33_fpExpETest_new_compare_to_250_new_compare_trz_315_n);

    -- invExpXIsMax_uid28_fpExpETest(LOGICAL,27)@2
    invExpXIsMax_uid28_fpExpETest_q <= STD_LOGIC_VECTOR(not (expXIsMax_uid23_fpExpETest_q));

    -- excZ_x_uid22_fpExpETest(LOGICAL,21)@1 + 1
    excZ_x_uid22_fpExpETest_qi <= "1" WHEN redist20_expX_uid6_fpExpETest_b_1_q = cstZeroWE_uid14_fpExpETest_q ELSE "0";
    excZ_x_uid22_fpExpETest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => excZ_x_uid22_fpExpETest_qi, xout => excZ_x_uid22_fpExpETest_q, ena => en(0), clk => clk, aclr => areset );

    -- InvExpXIsZero_uid29_fpExpETest(LOGICAL,28)@2
    InvExpXIsZero_uid29_fpExpETest_q <= STD_LOGIC_VECTOR(not (excZ_x_uid22_fpExpETest_q));

    -- excR_x_uid30_fpExpETest(LOGICAL,29)@2
    excR_x_uid30_fpExpETest_q <= STD_LOGIC_VECTOR(InvExpXIsZero_uid29_fpExpETest_q and invExpXIsMax_uid28_fpExpETest_q);

    -- regXAndExpOverflowAndPos_uid137_fpExpETest(LOGICAL,136)@2
    regXAndExpOverflowAndPos_uid137_fpExpETest_q <= STD_LOGIC_VECTOR(excR_x_uid30_fpExpETest_q and inputOverflow_uid35_fpExpETest_q);

    -- excI_x_uid26_fpExpETest(LOGICAL,25)@2
    excI_x_uid26_fpExpETest_q <= STD_LOGIC_VECTOR(expXIsMax_uid23_fpExpETest_q and fracXIsZero_uid24_fpExpETest_q);

    -- posInf_uid139_fpExpETest(LOGICAL,138)@2
    posInf_uid139_fpExpETest_q <= STD_LOGIC_VECTOR(excI_x_uid26_fpExpETest_q and invSignX_uid34_fpExpETest_q);

    -- excRInf_uid140_fpExpETest(LOGICAL,139)@2
    excRInf_uid140_fpExpETest_q <= STD_LOGIC_VECTOR(posInf_uid139_fpExpETest_q or regXAndExpOverflowAndPos_uid137_fpExpETest_q);

    -- negInf_uid134_fpExpETest(LOGICAL,133)@2
    negInf_uid134_fpExpETest_q <= STD_LOGIC_VECTOR(excI_x_uid26_fpExpETest_q and signX_uid7_fpExpETest_b);

    -- expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316(CONSTANT,315)
    expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316_q <= "100001010101110101011000101";

    -- expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317(BITSELECT,316)@1
    expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317_b <= STD_LOGIC_VECTOR(expFracX_uid31_fpExpETest_q(30 downto 4));

    -- expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318(COMPARE,317)@1 + 1
    expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_a <= STD_LOGIC_VECTOR("00" & expMinInput_uid37_fpExpETest_new_compare_to_252_bit_select_top_X_trz_317_b);
    expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_b <= STD_LOGIC_VECTOR("00" & expMinInput_uid37_fpExpETest_new_compare_to_252_new_const_trz_316_q);
    expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o <= STD_LOGIC_VECTOR(UNSIGNED(expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_a) - UNSIGNED(expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_n(0) <= not (expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_o(28));

    -- inputUnderflow_uid38_fpExpETest(LOGICAL,37)@2
    inputUnderflow_uid38_fpExpETest_q <= STD_LOGIC_VECTOR(signX_uid7_fpExpETest_b and expMinInput_uid37_fpExpETest_new_compare_to_252_new_compare_trz_318_n);

    -- regXAndExpOverflowAndNeg_uid135_fpExpETest(LOGICAL,134)@2
    regXAndExpOverflowAndNeg_uid135_fpExpETest_q <= STD_LOGIC_VECTOR(excR_x_uid30_fpExpETest_q and inputUnderflow_uid38_fpExpETest_q);

    -- excRZero_uid136_fpExpETest(LOGICAL,135)@2
    excRZero_uid136_fpExpETest_q <= STD_LOGIC_VECTOR(regXAndExpOverflowAndNeg_uid135_fpExpETest_q or negInf_uid134_fpExpETest_q);

    -- concExc_uid141_fpExpETest(BITJOIN,140)@2
    concExc_uid141_fpExpETest_q <= excN_x_uid27_fpExpETest_q & excRInf_uid140_fpExpETest_q & excRZero_uid136_fpExpETest_q;

    -- excREnc_uid142_fpExpETest(LOOKUP,141)@2 + 1
    excREnc_uid142_fpExpETest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                excREnc_uid142_fpExpETest_q <= "01";
            ELSE
                IF (en = "1") THEN
                    CASE (concExc_uid141_fpExpETest_q) IS
                        WHEN "000" => excREnc_uid142_fpExpETest_q <= "01";
                        WHEN "001" => excREnc_uid142_fpExpETest_q <= "00";
                        WHEN "010" => excREnc_uid142_fpExpETest_q <= "10";
                        WHEN "011" => excREnc_uid142_fpExpETest_q <= "00";
                        WHEN "100" => excREnc_uid142_fpExpETest_q <= "11";
                        WHEN "101" => excREnc_uid142_fpExpETest_q <= "00";
                        WHEN "110" => excREnc_uid142_fpExpETest_q <= "00";
                        WHEN "111" => excREnc_uid142_fpExpETest_q <= "00";
                        WHEN OTHERS => -- unreachable
                                       excREnc_uid142_fpExpETest_q <= (others => '-');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist12_excREnc_uid142_fpExpETest_q_29_wraddr(REG,363)
    redist12_excREnc_uid142_fpExpETest_q_29_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q <= "11010";
            ELSE
                redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q <= redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist12_excREnc_uid142_fpExpETest_q_29_mem(DUALMEM,360)
    redist12_excREnc_uid142_fpExpETest_q_29_mem_ia <= STD_LOGIC_VECTOR(excREnc_uid142_fpExpETest_q);
    redist12_excREnc_uid142_fpExpETest_q_29_mem_aa <= redist12_excREnc_uid142_fpExpETest_q_29_wraddr_q;
    redist12_excREnc_uid142_fpExpETest_q_29_mem_ab <= redist12_excREnc_uid142_fpExpETest_q_29_rdmux_q;
    redist12_excREnc_uid142_fpExpETest_q_29_mem_ena_OrRstB <= areset or en(0);
    redist12_excREnc_uid142_fpExpETest_q_29_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 2,
        widthad_a => 5,
        numwords_a => 27,
        width_b => 2,
        widthad_b => 5,
        numwords_b => 27,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_sclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken1 => redist12_excREnc_uid142_fpExpETest_q_29_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist12_excREnc_uid142_fpExpETest_q_29_mem_aa,
        data_a => redist12_excREnc_uid142_fpExpETest_q_29_mem_ia,
        wren_a => en(0),
        address_b => redist12_excREnc_uid142_fpExpETest_q_29_mem_ab,
        q_b => redist12_excREnc_uid142_fpExpETest_q_29_mem_iq
    );
    redist12_excREnc_uid142_fpExpETest_q_29_mem_q <= STD_LOGIC_VECTOR(redist12_excREnc_uid142_fpExpETest_q_29_mem_iq(1 downto 0));

    -- expRPostExc_uid151_fpExpETest(MUX,150)@31
    expRPostExc_uid151_fpExpETest_s <= redist12_excREnc_uid142_fpExpETest_q_29_mem_q;
    expRPostExc_uid151_fpExpETest_combproc: PROCESS (expRPostExc_uid151_fpExpETest_s, en, cstZeroWE_uid14_fpExpETest_q, expR_uid133_fpExpETest_b, cstAllOWE_uid17_fpExpETest_q)
    BEGIN
        CASE (expRPostExc_uid151_fpExpETest_s) IS
            WHEN "00" => expRPostExc_uid151_fpExpETest_q <= cstZeroWE_uid14_fpExpETest_q;
            WHEN "01" => expRPostExc_uid151_fpExpETest_q <= expR_uid133_fpExpETest_b;
            WHEN "10" => expRPostExc_uid151_fpExpETest_q <= cstAllOWE_uid17_fpExpETest_q;
            WHEN "11" => expRPostExc_uid151_fpExpETest_q <= cstAllOWE_uid17_fpExpETest_q;
            WHEN OTHERS => expRPostExc_uid151_fpExpETest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid143_fpExpETest(CONSTANT,142)
    oneFracRPostExc2_uid143_fpExpETest_q <= "00000000000000000000001";

    -- fracEY_uid145_fpExpETest(BITSELECT,144)@30
    fracEY_uid145_fpExpETest_b <= STD_LOGIC_VECTOR(eY_uid125_fpExpETest_impl_q0(22 downto 0));

    -- redist11_fracEY_uid145_fpExpETest_b_1(DELAY,339)
    redist11_fracEY_uid145_fpExpETest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist11_fracEY_uid145_fpExpETest_b_1_q <= fracEY_uid145_fpExpETest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- fracRPostExc_uid147_fpExpETest(MUX,146)@31
    fracRPostExc_uid147_fpExpETest_s <= redist12_excREnc_uid142_fpExpETest_q_29_mem_q;
    fracRPostExc_uid147_fpExpETest_combproc: PROCESS (fracRPostExc_uid147_fpExpETest_s, en, cstZeroWF_uid18_fpExpETest_q, redist11_fracEY_uid145_fpExpETest_b_1_q, oneFracRPostExc2_uid143_fpExpETest_q)
    BEGIN
        CASE (fracRPostExc_uid147_fpExpETest_s) IS
            WHEN "00" => fracRPostExc_uid147_fpExpETest_q <= cstZeroWF_uid18_fpExpETest_q;
            WHEN "01" => fracRPostExc_uid147_fpExpETest_q <= redist11_fracEY_uid145_fpExpETest_b_1_q;
            WHEN "10" => fracRPostExc_uid147_fpExpETest_q <= cstZeroWF_uid18_fpExpETest_q;
            WHEN "11" => fracRPostExc_uid147_fpExpETest_q <= oneFracRPostExc2_uid143_fpExpETest_q;
            WHEN OTHERS => fracRPostExc_uid147_fpExpETest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- finalResult_uid153_fpExpETest(BITJOIN,152)@31
    finalResult_uid153_fpExpETest_q <= redist10_signEY_uid152_fpExpETest_b_1_q & expRPostExc_uid151_fpExpETest_q & fracRPostExc_uid147_fpExpETest_q;

    -- xOut(GPOUT,4)@31
    q <= finalResult_uid153_fpExpETest_q;

END normal;
