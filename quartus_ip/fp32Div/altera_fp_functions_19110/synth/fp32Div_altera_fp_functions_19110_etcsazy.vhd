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

-- VHDL created from fp32Div_altera_fp_functions_19110_etcsazy
-- VHDL created on Tue Jun 30 04:21:25 2026


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

entity fp32Div_altera_fp_functions_19110_etcsazy is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        en : in std_logic_vector(0 downto 0);  -- ufix1
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fp32Div_altera_fp_functions_19110_etcsazy;

architecture normal of fp32Div_altera_fp_functions_19110_etcsazy is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstBias_uid7_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expX_uid9_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracX_uid10_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal signX_uid11_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expY_uid12_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracY_uid13_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal signY_uid14_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracYZero_uid15_fpDivTest_a : STD_LOGIC_VECTOR (23 downto 0);
    signal fracYZero_uid15_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracYZero_uid15_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid18_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid19_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid20_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal excZ_x_uid23_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_x_uid23_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid24_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid24_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid25_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid25_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid26_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid27_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid28_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid29_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid30_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid31_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_y_uid37_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid38_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid38_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid39_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid39_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid40_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_y_uid41_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid42_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid43_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid44_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_y_uid45_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signR_uid46_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signR_uid46_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXmY_uid47_fpDivTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expXmY_uid47_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expXmY_uid47_fpDivTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expXmY_uid47_fpDivTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal yAddr_uid51_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal yPE_uid52_fpDivTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal invY_uid54_fpDivTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal invY_uid54_fpDivTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal invYO_uid55_fpDivTest_in : STD_LOGIC_VECTOR (32 downto 0);
    signal invYO_uid55_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal lOAdded_uid57_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal z4_uid60_fpDivTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal oFracXZ4_uid61_fpDivTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal divValPreNormYPow2Exc_uid63_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal divValPreNormYPow2Exc_uid63_fpDivTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal norm_uid64_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal divValPreNormHigh_uid65_fpDivTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal divValPreNormHigh_uid65_fpDivTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal divValPreNormLow_uid66_fpDivTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal divValPreNormLow_uid66_fpDivTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal normFracRnd_uid67_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal normFracRnd_uid67_fpDivTest_q : STD_LOGIC_VECTOR (24 downto 0);
    signal expFracRnd_uid68_fpDivTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal zeroPaddingInAddition_uid74_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracPostRnd_uid75_fpDivTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_a : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_o : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_q : STD_LOGIC_VECTOR (35 downto 0);
    signal fracXExt_uid77_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal fracPostRndF_uid79_fpDivTest_in : STD_LOGIC_VECTOR (24 downto 0);
    signal fracPostRndF_uid79_fpDivTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracPostRndF_uid80_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostRndF_uid80_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expPostRndFR_uid81_fpDivTest_in : STD_LOGIC_VECTOR (32 downto 0);
    signal expPostRndFR_uid81_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expPostRndF_uid82_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal expPostRndF_uid82_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal lOAdded_uid84_fpDivTest_q : STD_LOGIC_VECTOR (24 downto 0);
    signal lOAdded_uid87_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal qDivProdNorm_uid90_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal qDivProdFracHigh_uid91_fpDivTest_in : STD_LOGIC_VECTOR (47 downto 0);
    signal qDivProdFracHigh_uid91_fpDivTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal qDivProdFracLow_uid92_fpDivTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal qDivProdFracLow_uid92_fpDivTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal qDivProdFrac_uid93_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal qDivProdFrac_uid93_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal qDivProdExp_opA_uid94_fpDivTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opA_uid94_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opA_uid94_fpDivTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opA_uid94_fpDivTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opBs_uid95_fpDivTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opBs_uid95_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opBs_uid95_fpDivTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_opBs_uid95_fpDivTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal qDivProdExp_uid96_fpDivTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal qDivProdExp_uid96_fpDivTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal qDivProdExp_uid96_fpDivTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal qDivProdExp_uid96_fpDivTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal qDivProdFracWF_uid97_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal qDivProdLTX_opA_uid98_fpDivTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal qDivProdLTX_opA_uid98_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal qDivProdLTX_opA_uid99_fpDivTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal qDivProdLTX_opB_uid100_fpDivTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal qDividerProdLTX_uid101_fpDivTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal qDividerProdLTX_uid101_fpDivTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal qDividerProdLTX_uid101_fpDivTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal qDividerProdLTX_uid101_fpDivTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal betweenFPwF_uid102_fpDivTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal betweenFPwF_uid102_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal extraUlp_uid103_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal extraUlp_uid103_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostRndFT_uid104_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPreExcExt_uid105_fpDivTest_a : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExcExt_uid105_fpDivTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExcExt_uid105_fpDivTest_o : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExcExt_uid105_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal fracPostRndFPostUlp_uid106_fpDivTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fracPostRndFPostUlp_uid106_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPreExc_uid107_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExc_uid107_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal ovfIncRnd_uid109_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracPostRndInc_uid110_fpDivTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expFracPostRndInc_uid110_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expFracPostRndInc_uid110_fpDivTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expFracPostRndInc_uid110_fpDivTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expFracPostRndR_uid111_fpDivTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expFracPostRndR_uid111_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid112_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal expRPreExc_uid112_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expRExt_uid114_fpDivTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expUdf_uid115_fpDivTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal expUdf_uid115_fpDivTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal expUdf_uid115_fpDivTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal expUdf_uid115_fpDivTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expOvf_uid118_fpDivTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal expOvf_uid118_fpDivTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal expOvf_uid118_fpDivTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal expOvf_uid118_fpDivTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal zeroOverReg_uid119_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regOverRegWithUf_uid120_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xRegOrZero_uid121_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regOrZeroOverInf_uid122_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid123_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid123_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRYZ_uid124_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRYROvf_uid125_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIYZ_uid126_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIYR_uid127_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid128_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid128_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZYZ_uid129_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIYI_uid130_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid131_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid131_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid132_fpDivTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid133_fpDivTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oneFracRPostExc2_uid134_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid137_fpDivTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid137_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid141_fpDivTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid141_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal invExcRNaN_uid142_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sRPostExc_uid143_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal sRPostExc_uid143_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal divR_uid144_fpDivTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yT1_uid158_invPolyEval_b : STD_LOGIC_VECTOR (12 downto 0);
    signal lowRangeB_uid160_invPolyEval_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeB_uid160_invPolyEval_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highBBits_uid161_invPolyEval_b : STD_LOGIC_VECTOR (12 downto 0);
    signal s1sumAHighB_uid162_invPolyEval_a : STD_LOGIC_VECTOR (22 downto 0);
    signal s1sumAHighB_uid162_invPolyEval_b : STD_LOGIC_VECTOR (22 downto 0);
    signal s1sumAHighB_uid162_invPolyEval_o : STD_LOGIC_VECTOR (22 downto 0);
    signal s1sumAHighB_uid162_invPolyEval_q : STD_LOGIC_VECTOR (22 downto 0);
    signal s1_uid163_invPolyEval_q : STD_LOGIC_VECTOR (23 downto 0);
    signal lowRangeB_uid166_invPolyEval_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowRangeB_uid166_invPolyEval_b : STD_LOGIC_VECTOR (1 downto 0);
    signal highBBits_uid167_invPolyEval_b : STD_LOGIC_VECTOR (22 downto 0);
    signal s2sumAHighB_uid168_invPolyEval_a : STD_LOGIC_VECTOR (32 downto 0);
    signal s2sumAHighB_uid168_invPolyEval_b : STD_LOGIC_VECTOR (32 downto 0);
    signal s2sumAHighB_uid168_invPolyEval_o : STD_LOGIC_VECTOR (32 downto 0);
    signal s2sumAHighB_uid168_invPolyEval_q : STD_LOGIC_VECTOR (32 downto 0);
    signal s2_uid169_invPolyEval_q : STD_LOGIC_VECTOR (34 downto 0);
    signal osig_uid172_divValPreNorm_uid59_fpDivTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal osig_uid175_pT1_uid159_invPolyEval_b : STD_LOGIC_VECTOR (13 downto 0);
    signal osig_uid178_pT2_uid165_invPolyEval_b : STD_LOGIC_VECTOR (24 downto 0);
    signal expR_uid48_fpDivTest_MSBs_sums_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expR_uid48_fpDivTest_MSBs_sums_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expR_uid48_fpDivTest_MSBs_sums_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expR_uid48_fpDivTest_MSBs_sums_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expR_uid48_fpDivTest_split_join_q : STD_LOGIC_VECTOR (9 downto 0);
    signal memoryC0_uid146_invTables_lutmem_reset0 : std_logic;
    signal memoryC0_uid146_invTables_lutmem_ena_NotRstA : std_logic;
    signal memoryC0_uid146_invTables_lutmem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal memoryC0_uid146_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid146_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid146_invTables_lutmem_ir : STD_LOGIC_VECTOR (31 downto 0);
    signal memoryC0_uid146_invTables_lutmem_r : STD_LOGIC_VECTOR (31 downto 0);
    signal memoryC1_uid149_invTables_lutmem_reset0 : std_logic;
    signal memoryC1_uid149_invTables_lutmem_ena_NotRstA : std_logic;
    signal memoryC1_uid149_invTables_lutmem_ia : STD_LOGIC_VECTOR (21 downto 0);
    signal memoryC1_uid149_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC1_uid149_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC1_uid149_invTables_lutmem_ir : STD_LOGIC_VECTOR (21 downto 0);
    signal memoryC1_uid149_invTables_lutmem_r : STD_LOGIC_VECTOR (21 downto 0);
    signal memoryC2_uid152_invTables_lutmem_reset0 : std_logic;
    signal memoryC2_uid152_invTables_lutmem_ena_NotRstA : std_logic;
    signal memoryC2_uid152_invTables_lutmem_ia : STD_LOGIC_VECTOR (12 downto 0);
    signal memoryC2_uid152_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC2_uid152_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC2_uid152_invTables_lutmem_ir : STD_LOGIC_VECTOR (12 downto 0);
    signal memoryC2_uid152_invTables_lutmem_r : STD_LOGIC_VECTOR (12 downto 0);
    signal expR_uid48_fpDivTest_lhsMSBs_select_b_const_q : STD_LOGIC_VECTOR (6 downto 0);
    signal qDivProd_uid89_fpDivTest_cma_reset : std_logic;
    signal qDivProd_uid89_fpDivTest_cma_a0 : STD_LOGIC_VECTOR (24 downto 0);
    signal qDivProd_uid89_fpDivTest_cma_c0 : STD_LOGIC_VECTOR (23 downto 0);
    signal qDivProd_uid89_fpDivTest_cma_s0 : STD_LOGIC_VECTOR (48 downto 0);
    signal qDivProd_uid89_fpDivTest_cma_qq0 : STD_LOGIC_VECTOR (48 downto 0);
    signal qDivProd_uid89_fpDivTest_cma_q : STD_LOGIC_VECTOR (48 downto 0);
    signal qDivProd_uid89_fpDivTest_cma_ena0 : std_logic;
    signal qDivProd_uid89_fpDivTest_cma_ena1 : std_logic;
    signal qDivProd_uid89_fpDivTest_cma_ena2 : std_logic;
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset : std_logic;
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_a0 : STD_LOGIC_VECTOR (26 downto 0);
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_c0 : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_s0 : STD_LOGIC_VECTOR (50 downto 0);
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_qq0 : STD_LOGIC_VECTOR (50 downto 0);
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_q : STD_LOGIC_VECTOR (50 downto 0);
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0 : std_logic;
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena1 : std_logic;
    signal prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena2 : std_logic;
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_reset : std_logic;
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_a0 : STD_LOGIC_VECTOR (12 downto 0);
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_c0 : STD_LOGIC_VECTOR (12 downto 0);
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_s0 : STD_LOGIC_VECTOR (25 downto 0);
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_qq0 : STD_LOGIC_VECTOR (25 downto 0);
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_q : STD_LOGIC_VECTOR (25 downto 0);
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_ena1 : std_logic;
    signal prodXY_uid174_pT1_uid159_invPolyEval_cma_ena2 : std_logic;
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_reset : std_logic;
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_a0 : STD_LOGIC_VECTOR (13 downto 0);
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_c0 : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_s0 : STD_LOGIC_VECTOR (37 downto 0);
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_qq0 : STD_LOGIC_VECTOR (37 downto 0);
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_q : STD_LOGIC_VECTOR (37 downto 0);
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_ena1 : std_logic;
    signal prodXY_uid177_pT2_uid165_invPolyEval_cma_ena2 : std_logic;
    signal expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_c : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_s1_uid163_invPolyEval_q_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist1_sRPostExc_uid143_fpDivTest_q_8_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist2_excREnc_uid133_fpDivTest_q_8_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist3_expRExt_uid114_fpDivTest_b_1_q : STD_LOGIC_VECTOR (10 downto 0);
    signal redist4_ovfIncRnd_uid109_fpDivTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_extraUlp_uid103_fpDivTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_betweenFPwF_uid102_fpDivTest_b_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_q : STD_LOGIC_VECTOR (30 downto 0);
    signal redist10_qDivProdFracWF_uid97_fpDivTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_0 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_1 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_2 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_3 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist14_expFracRnd_uid68_fpDivTest_q_1_q : STD_LOGIC_VECTOR (34 downto 0);
    signal redist15_norm_uid64_fpDivTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_lOAdded_uid57_fpDivTest_q_5_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist16_lOAdded_uid57_fpDivTest_q_5_delay_0 : STD_LOGIC_VECTOR (23 downto 0);
    signal redist16_lOAdded_uid57_fpDivTest_q_5_delay_1 : STD_LOGIC_VECTOR (23 downto 0);
    signal redist16_lOAdded_uid57_fpDivTest_q_5_delay_2 : STD_LOGIC_VECTOR (23 downto 0);
    signal redist17_invYO_uid55_fpDivTest_b_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist18_invY_uid54_fpDivTest_b_1_q : STD_LOGIC_VECTOR (26 downto 0);
    signal redist19_yPE_uid52_fpDivTest_b_2_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist19_yPE_uid52_fpDivTest_b_2_delay_0 : STD_LOGIC_VECTOR (13 downto 0);
    signal redist21_yAddr_uid51_fpDivTest_b_5_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist21_yAddr_uid51_fpDivTest_b_5_delay_0 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist21_yAddr_uid51_fpDivTest_b_5_delay_1 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist21_yAddr_uid51_fpDivTest_b_5_delay_2 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist21_yAddr_uid51_fpDivTest_b_5_delay_3 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist23_signR_uid46_fpDivTest_q_22_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist24_fracXIsZero_uid39_fpDivTest_q_21_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist25_fracYZero_uid15_fpDivTest_q_19_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist27_expY_uid12_fpDivTest_b_20_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist27_expY_uid12_fpDivTest_b_20_delay_0 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist28_expY_uid12_fpDivTest_b_21_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist30_expX_uid9_fpDivTest_b_4_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist30_expX_uid9_fpDivTest_b_4_delay_0 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist30_expX_uid9_fpDivTest_b_4_delay_1 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist30_expX_uid9_fpDivTest_b_4_delay_2 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist31_expX_uid9_fpDivTest_b_6_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist31_expX_uid9_fpDivTest_b_6_delay_0 : STD_LOGIC_VECTOR (7 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_reset0 : std_logic;
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ena_OrRstB : std_logic;
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ia : STD_LOGIC_VECTOR (22 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_iq : STD_LOGIC_VECTOR (22 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only : boolean;
    attribute preserve_syn_only of redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i : signal is true;
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq : signal is true;
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_q : STD_LOGIC_VECTOR (30 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_reset0 : std_logic;
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ena_OrRstB : std_logic;
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ia : STD_LOGIC_VECTOR (30 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_iq : STD_LOGIC_VECTOR (30 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_q : STD_LOGIC_VECTOR (30 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i : signal is true;
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq : signal is true;
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_reset0 : std_logic;
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_ena_OrRstB : std_logic;
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_ia : STD_LOGIC_VECTOR (23 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_aa : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_ab : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_iq : STD_LOGIC_VECTOR (23 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_mem_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i : UNSIGNED (4 downto 0);
    attribute preserve_syn_only of redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i : signal is true;
    signal redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq : signal is true;
    signal redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_reset0 : std_logic;
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ena_OrRstB : std_logic;
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ia : STD_LOGIC_VECTOR (7 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_iq : STD_LOGIC_VECTOR (7 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i : signal is true;
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq : signal is true;
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_reset0 : std_logic;
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_ena_OrRstB : std_logic;
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_ia : STD_LOGIC_VECTOR (13 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_iq : STD_LOGIC_VECTOR (13 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_mem_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i : signal is true;
    signal redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq : signal is true;
    signal redist20_yPE_uid52_fpDivTest_b_8_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist20_yPE_uid52_fpDivTest_b_8_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_reset0 : std_logic;
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_ena_OrRstB : std_logic;
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_ia : STD_LOGIC_VECTOR (8 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_iq : STD_LOGIC_VECTOR (8 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_mem_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i : signal is true;
    signal redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq : signal is true;
    signal redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_mem_reset0 : std_logic;
    signal redist26_expY_uid12_fpDivTest_b_18_mem_ena_OrRstB : std_logic;
    signal redist26_expY_uid12_fpDivTest_b_18_mem_ia : STD_LOGIC_VECTOR (7 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_mem_aa : STD_LOGIC_VECTOR (4 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_mem_ab : STD_LOGIC_VECTOR (4 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_mem_iq : STD_LOGIC_VECTOR (7 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_mem_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_rdcnt_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_rdcnt_i : UNSIGNED (4 downto 0);
    attribute preserve_syn_only of redist26_expY_uid12_fpDivTest_b_18_rdcnt_i : signal is true;
    signal redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq : signal is true;
    signal redist26_expY_uid12_fpDivTest_b_18_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_rdmux_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist26_expY_uid12_fpDivTest_b_18_wraddr_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_reset0 : std_logic;
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_ena_OrRstB : std_logic;
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_ia : STD_LOGIC_VECTOR (22 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_iq : STD_LOGIC_VECTOR (22 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_mem_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i : signal is true;
    signal redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq : signal is true;
    signal redist29_fracX_uid10_fpDivTest_b_6_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist29_fracX_uid10_fpDivTest_b_6_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist32_xIn_a_14_mem_reset0 : std_logic;
    signal redist32_xIn_a_14_mem_ena_OrRstB : std_logic;
    signal redist32_xIn_a_14_mem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal redist32_xIn_a_14_mem_aa : STD_LOGIC_VECTOR (3 downto 0);
    signal redist32_xIn_a_14_mem_ab : STD_LOGIC_VECTOR (3 downto 0);
    signal redist32_xIn_a_14_mem_iq : STD_LOGIC_VECTOR (31 downto 0);
    signal redist32_xIn_a_14_mem_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist32_xIn_a_14_rdcnt_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist32_xIn_a_14_rdcnt_i : UNSIGNED (3 downto 0);
    attribute preserve_syn_only of redist32_xIn_a_14_rdcnt_i : signal is true;
    signal redist32_xIn_a_14_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist32_xIn_a_14_rdcnt_eq : signal is true;
    signal redist32_xIn_a_14_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist32_xIn_a_14_rdmux_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist32_xIn_a_14_wraddr_q : STD_LOGIC_VECTOR (3 downto 0);

begin


    -- fracY_uid13_fpDivTest(BITSELECT,12)@0
    fracY_uid13_fpDivTest_b <= STD_LOGIC_VECTOR(b(22 downto 0));

    -- cstZeroWF_uid19_fpDivTest(CONSTANT,18)
    cstZeroWF_uid19_fpDivTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid39_fpDivTest(LOGICAL,38)@0 + 1
    fracXIsZero_uid39_fpDivTest_qi <= "1" WHEN cstZeroWF_uid19_fpDivTest_q = fracY_uid13_fpDivTest_b ELSE "0";
    fracXIsZero_uid39_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracXIsZero_uid39_fpDivTest_qi, xout => fracXIsZero_uid39_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist24_fracXIsZero_uid39_fpDivTest_q_21(DELAY,219)
    redist24_fracXIsZero_uid39_fpDivTest_q_21 : dspba_delay
    GENERIC MAP ( width => 1, depth => 20, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracXIsZero_uid39_fpDivTest_q, xout => redist24_fracXIsZero_uid39_fpDivTest_q_21_q, ena => en(0), clk => clk, aclr => areset );

    -- cstAllOWE_uid18_fpDivTest(CONSTANT,17)
    cstAllOWE_uid18_fpDivTest_q <= "11111111";

    -- redist26_expY_uid12_fpDivTest_b_18_rdcnt(COUNTER,258)
    -- low=0, high=16, step=1, init=0
    redist26_expY_uid12_fpDivTest_b_18_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist26_expY_uid12_fpDivTest_b_18_rdcnt_i <= TO_UNSIGNED(0, 5);
                redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist26_expY_uid12_fpDivTest_b_18_rdcnt_i = TO_UNSIGNED(15, 5)) THEN
                        redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq <= '1';
                    ELSE
                        redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq <= '0';
                    END IF;
                    IF (redist26_expY_uid12_fpDivTest_b_18_rdcnt_eq = '1') THEN
                        redist26_expY_uid12_fpDivTest_b_18_rdcnt_i <= redist26_expY_uid12_fpDivTest_b_18_rdcnt_i + 16;
                    ELSE
                        redist26_expY_uid12_fpDivTest_b_18_rdcnt_i <= redist26_expY_uid12_fpDivTest_b_18_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist26_expY_uid12_fpDivTest_b_18_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist26_expY_uid12_fpDivTest_b_18_rdcnt_i, 5));

    -- redist26_expY_uid12_fpDivTest_b_18_rdmux(MUX,259)
    redist26_expY_uid12_fpDivTest_b_18_rdmux_s <= en;
    redist26_expY_uid12_fpDivTest_b_18_rdmux_combproc: PROCESS (redist26_expY_uid12_fpDivTest_b_18_rdmux_s, redist26_expY_uid12_fpDivTest_b_18_wraddr_q, redist26_expY_uid12_fpDivTest_b_18_rdcnt_q)
    BEGIN
        CASE (redist26_expY_uid12_fpDivTest_b_18_rdmux_s) IS
            WHEN "0" => redist26_expY_uid12_fpDivTest_b_18_rdmux_q <= redist26_expY_uid12_fpDivTest_b_18_wraddr_q;
            WHEN "1" => redist26_expY_uid12_fpDivTest_b_18_rdmux_q <= redist26_expY_uid12_fpDivTest_b_18_rdcnt_q;
            WHEN OTHERS => redist26_expY_uid12_fpDivTest_b_18_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- expY_uid12_fpDivTest(BITSELECT,11)@0
    expY_uid12_fpDivTest_b <= STD_LOGIC_VECTOR(b(30 downto 23));

    -- redist26_expY_uid12_fpDivTest_b_18_wraddr(REG,260)
    redist26_expY_uid12_fpDivTest_b_18_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist26_expY_uid12_fpDivTest_b_18_wraddr_q <= "10000";
            ELSE
                redist26_expY_uid12_fpDivTest_b_18_wraddr_q <= redist26_expY_uid12_fpDivTest_b_18_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist26_expY_uid12_fpDivTest_b_18_mem(DUALMEM,257)
    redist26_expY_uid12_fpDivTest_b_18_mem_ia <= STD_LOGIC_VECTOR(expY_uid12_fpDivTest_b);
    redist26_expY_uid12_fpDivTest_b_18_mem_aa <= redist26_expY_uid12_fpDivTest_b_18_wraddr_q;
    redist26_expY_uid12_fpDivTest_b_18_mem_ab <= redist26_expY_uid12_fpDivTest_b_18_rdmux_q;
    redist26_expY_uid12_fpDivTest_b_18_mem_ena_OrRstB <= areset or en(0);
    redist26_expY_uid12_fpDivTest_b_18_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 8,
        widthad_a => 5,
        numwords_a => 17,
        width_b => 8,
        widthad_b => 5,
        numwords_b => 17,
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
        clocken1 => redist26_expY_uid12_fpDivTest_b_18_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist26_expY_uid12_fpDivTest_b_18_mem_aa,
        data_a => redist26_expY_uid12_fpDivTest_b_18_mem_ia,
        wren_a => en(0),
        address_b => redist26_expY_uid12_fpDivTest_b_18_mem_ab,
        q_b => redist26_expY_uid12_fpDivTest_b_18_mem_iq
    );
    redist26_expY_uid12_fpDivTest_b_18_mem_q <= STD_LOGIC_VECTOR(redist26_expY_uid12_fpDivTest_b_18_mem_iq(7 downto 0));

    -- redist27_expY_uid12_fpDivTest_b_20(DELAY,222)
    redist27_expY_uid12_fpDivTest_b_20_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist27_expY_uid12_fpDivTest_b_20_delay_0 <= STD_LOGIC_VECTOR(redist26_expY_uid12_fpDivTest_b_18_mem_q);
                    redist27_expY_uid12_fpDivTest_b_20_q <= STD_LOGIC_VECTOR(redist27_expY_uid12_fpDivTest_b_20_delay_0);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expXIsMax_uid38_fpDivTest(LOGICAL,37)@20 + 1
    expXIsMax_uid38_fpDivTest_qi <= "1" WHEN redist27_expY_uid12_fpDivTest_b_20_q = cstAllOWE_uid18_fpDivTest_q ELSE "0";
    expXIsMax_uid38_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => expXIsMax_uid38_fpDivTest_qi, xout => expXIsMax_uid38_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- excI_y_uid41_fpDivTest(LOGICAL,40)@21
    excI_y_uid41_fpDivTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid38_fpDivTest_q and redist24_fracXIsZero_uid39_fpDivTest_q_21_q);

    -- redist29_fracX_uid10_fpDivTest_b_6_rdcnt(COUNTER,262)
    -- low=0, high=4, step=1, init=0
    redist29_fracX_uid10_fpDivTest_b_6_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                        redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= '1';
                    ELSE
                        redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= '0';
                    END IF;
                    IF (redist29_fracX_uid10_fpDivTest_b_6_rdcnt_eq = '1') THEN
                        redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i <= redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i + 4;
                    ELSE
                        redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i <= redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist29_fracX_uid10_fpDivTest_b_6_rdcnt_i, 3));

    -- redist29_fracX_uid10_fpDivTest_b_6_rdmux(MUX,263)
    redist29_fracX_uid10_fpDivTest_b_6_rdmux_s <= en;
    redist29_fracX_uid10_fpDivTest_b_6_rdmux_combproc: PROCESS (redist29_fracX_uid10_fpDivTest_b_6_rdmux_s, redist29_fracX_uid10_fpDivTest_b_6_wraddr_q, redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q)
    BEGIN
        CASE (redist29_fracX_uid10_fpDivTest_b_6_rdmux_s) IS
            WHEN "0" => redist29_fracX_uid10_fpDivTest_b_6_rdmux_q <= redist29_fracX_uid10_fpDivTest_b_6_wraddr_q;
            WHEN "1" => redist29_fracX_uid10_fpDivTest_b_6_rdmux_q <= redist29_fracX_uid10_fpDivTest_b_6_rdcnt_q;
            WHEN OTHERS => redist29_fracX_uid10_fpDivTest_b_6_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist32_xIn_a_14_rdcnt(COUNTER,266)
    -- low=0, high=12, step=1, init=0
    redist32_xIn_a_14_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist32_xIn_a_14_rdcnt_i <= TO_UNSIGNED(0, 4);
                redist32_xIn_a_14_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist32_xIn_a_14_rdcnt_i = TO_UNSIGNED(11, 4)) THEN
                        redist32_xIn_a_14_rdcnt_eq <= '1';
                    ELSE
                        redist32_xIn_a_14_rdcnt_eq <= '0';
                    END IF;
                    IF (redist32_xIn_a_14_rdcnt_eq = '1') THEN
                        redist32_xIn_a_14_rdcnt_i <= redist32_xIn_a_14_rdcnt_i + 4;
                    ELSE
                        redist32_xIn_a_14_rdcnt_i <= redist32_xIn_a_14_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist32_xIn_a_14_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist32_xIn_a_14_rdcnt_i, 4));

    -- redist32_xIn_a_14_rdmux(MUX,267)
    redist32_xIn_a_14_rdmux_s <= en;
    redist32_xIn_a_14_rdmux_combproc: PROCESS (redist32_xIn_a_14_rdmux_s, redist32_xIn_a_14_wraddr_q, redist32_xIn_a_14_rdcnt_q)
    BEGIN
        CASE (redist32_xIn_a_14_rdmux_s) IS
            WHEN "0" => redist32_xIn_a_14_rdmux_q <= redist32_xIn_a_14_wraddr_q;
            WHEN "1" => redist32_xIn_a_14_rdmux_q <= redist32_xIn_a_14_rdcnt_q;
            WHEN OTHERS => redist32_xIn_a_14_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist32_xIn_a_14_wraddr(REG,268)
    redist32_xIn_a_14_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist32_xIn_a_14_wraddr_q <= "1100";
            ELSE
                redist32_xIn_a_14_wraddr_q <= redist32_xIn_a_14_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist32_xIn_a_14_mem(DUALMEM,265)
    redist32_xIn_a_14_mem_ia <= STD_LOGIC_VECTOR(a);
    redist32_xIn_a_14_mem_aa <= redist32_xIn_a_14_wraddr_q;
    redist32_xIn_a_14_mem_ab <= redist32_xIn_a_14_rdmux_q;
    redist32_xIn_a_14_mem_ena_OrRstB <= areset or en(0);
    redist32_xIn_a_14_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 32,
        widthad_a => 4,
        numwords_a => 13,
        width_b => 32,
        widthad_b => 4,
        numwords_b => 13,
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
        clocken1 => redist32_xIn_a_14_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist32_xIn_a_14_mem_aa,
        data_a => redist32_xIn_a_14_mem_ia,
        wren_a => en(0),
        address_b => redist32_xIn_a_14_mem_ab,
        q_b => redist32_xIn_a_14_mem_iq
    );
    redist32_xIn_a_14_mem_q <= STD_LOGIC_VECTOR(redist32_xIn_a_14_mem_iq(31 downto 0));

    -- fracX_uid10_fpDivTest(BITSELECT,9)@14
    fracX_uid10_fpDivTest_b <= STD_LOGIC_VECTOR(redist32_xIn_a_14_mem_q(22 downto 0));

    -- redist29_fracX_uid10_fpDivTest_b_6_wraddr(REG,264)
    redist29_fracX_uid10_fpDivTest_b_6_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist29_fracX_uid10_fpDivTest_b_6_wraddr_q <= "100";
            ELSE
                redist29_fracX_uid10_fpDivTest_b_6_wraddr_q <= redist29_fracX_uid10_fpDivTest_b_6_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist29_fracX_uid10_fpDivTest_b_6_mem(DUALMEM,261)
    redist29_fracX_uid10_fpDivTest_b_6_mem_ia <= STD_LOGIC_VECTOR(fracX_uid10_fpDivTest_b);
    redist29_fracX_uid10_fpDivTest_b_6_mem_aa <= redist29_fracX_uid10_fpDivTest_b_6_wraddr_q;
    redist29_fracX_uid10_fpDivTest_b_6_mem_ab <= redist29_fracX_uid10_fpDivTest_b_6_rdmux_q;
    redist29_fracX_uid10_fpDivTest_b_6_mem_ena_OrRstB <= areset or en(0);
    redist29_fracX_uid10_fpDivTest_b_6_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 23,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 23,
        widthad_b => 3,
        numwords_b => 5,
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
        clocken1 => redist29_fracX_uid10_fpDivTest_b_6_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist29_fracX_uid10_fpDivTest_b_6_mem_aa,
        data_a => redist29_fracX_uid10_fpDivTest_b_6_mem_ia,
        wren_a => en(0),
        address_b => redist29_fracX_uid10_fpDivTest_b_6_mem_ab,
        q_b => redist29_fracX_uid10_fpDivTest_b_6_mem_iq
    );
    redist29_fracX_uid10_fpDivTest_b_6_mem_q <= STD_LOGIC_VECTOR(redist29_fracX_uid10_fpDivTest_b_6_mem_iq(22 downto 0));

    -- fracXIsZero_uid25_fpDivTest(LOGICAL,24)@20 + 1
    fracXIsZero_uid25_fpDivTest_qi <= "1" WHEN cstZeroWF_uid19_fpDivTest_q = redist29_fracX_uid10_fpDivTest_b_6_mem_q ELSE "0";
    fracXIsZero_uid25_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracXIsZero_uid25_fpDivTest_qi, xout => fracXIsZero_uid25_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- expX_uid9_fpDivTest(BITSELECT,8)@14
    expX_uid9_fpDivTest_b <= STD_LOGIC_VECTOR(redist32_xIn_a_14_mem_q(30 downto 23));

    -- redist30_expX_uid9_fpDivTest_b_4(DELAY,225)
    redist30_expX_uid9_fpDivTest_b_4_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist30_expX_uid9_fpDivTest_b_4_delay_0 <= STD_LOGIC_VECTOR(expX_uid9_fpDivTest_b);
                    redist30_expX_uid9_fpDivTest_b_4_delay_1 <= redist30_expX_uid9_fpDivTest_b_4_delay_0;
                    redist30_expX_uid9_fpDivTest_b_4_delay_2 <= redist30_expX_uid9_fpDivTest_b_4_delay_1;
                    redist30_expX_uid9_fpDivTest_b_4_q <= STD_LOGIC_VECTOR(redist30_expX_uid9_fpDivTest_b_4_delay_2);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist31_expX_uid9_fpDivTest_b_6(DELAY,226)
    redist31_expX_uid9_fpDivTest_b_6_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist31_expX_uid9_fpDivTest_b_6_delay_0 <= STD_LOGIC_VECTOR(redist30_expX_uid9_fpDivTest_b_4_q);
                    redist31_expX_uid9_fpDivTest_b_6_q <= STD_LOGIC_VECTOR(redist31_expX_uid9_fpDivTest_b_6_delay_0);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expXIsMax_uid24_fpDivTest(LOGICAL,23)@20 + 1
    expXIsMax_uid24_fpDivTest_qi <= "1" WHEN redist31_expX_uid9_fpDivTest_b_6_q = cstAllOWE_uid18_fpDivTest_q ELSE "0";
    expXIsMax_uid24_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => expXIsMax_uid24_fpDivTest_qi, xout => expXIsMax_uid24_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- excI_x_uid27_fpDivTest(LOGICAL,26)@21
    excI_x_uid27_fpDivTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid24_fpDivTest_q and fracXIsZero_uid25_fpDivTest_q);

    -- excXIYI_uid130_fpDivTest(LOGICAL,129)@21
    excXIYI_uid130_fpDivTest_q <= STD_LOGIC_VECTOR(excI_x_uid27_fpDivTest_q and excI_y_uid41_fpDivTest_q);

    -- fracXIsNotZero_uid40_fpDivTest(LOGICAL,39)@21
    fracXIsNotZero_uid40_fpDivTest_q <= STD_LOGIC_VECTOR(not (redist24_fracXIsZero_uid39_fpDivTest_q_21_q));

    -- excN_y_uid42_fpDivTest(LOGICAL,41)@21
    excN_y_uid42_fpDivTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid38_fpDivTest_q and fracXIsNotZero_uid40_fpDivTest_q);

    -- fracXIsNotZero_uid26_fpDivTest(LOGICAL,25)@21
    fracXIsNotZero_uid26_fpDivTest_q <= STD_LOGIC_VECTOR(not (fracXIsZero_uid25_fpDivTest_q));

    -- excN_x_uid28_fpDivTest(LOGICAL,27)@21
    excN_x_uid28_fpDivTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid24_fpDivTest_q and fracXIsNotZero_uid26_fpDivTest_q);

    -- cstAllZWE_uid20_fpDivTest(CONSTANT,19)
    cstAllZWE_uid20_fpDivTest_q <= "00000000";

    -- redist28_expY_uid12_fpDivTest_b_21(DELAY,223)
    redist28_expY_uid12_fpDivTest_b_21_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist28_expY_uid12_fpDivTest_b_21_q <= redist27_expY_uid12_fpDivTest_b_20_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- excZ_y_uid37_fpDivTest(LOGICAL,36)@21
    excZ_y_uid37_fpDivTest_q <= "1" WHEN redist28_expY_uid12_fpDivTest_b_21_q = cstAllZWE_uid20_fpDivTest_q ELSE "0";

    -- excZ_x_uid23_fpDivTest(LOGICAL,22)@20 + 1
    excZ_x_uid23_fpDivTest_qi <= "1" WHEN redist31_expX_uid9_fpDivTest_b_6_q = cstAllZWE_uid20_fpDivTest_q ELSE "0";
    excZ_x_uid23_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => excZ_x_uid23_fpDivTest_qi, xout => excZ_x_uid23_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- excXZYZ_uid129_fpDivTest(LOGICAL,128)@21
    excXZYZ_uid129_fpDivTest_q <= STD_LOGIC_VECTOR(excZ_x_uid23_fpDivTest_q and excZ_y_uid37_fpDivTest_q);

    -- excRNaN_uid131_fpDivTest(LOGICAL,130)@21 + 1
    excRNaN_uid131_fpDivTest_qi <= excXZYZ_uid129_fpDivTest_q or excN_x_uid28_fpDivTest_q or excN_y_uid42_fpDivTest_q or excXIYI_uid130_fpDivTest_q;
    excRNaN_uid131_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => excRNaN_uid131_fpDivTest_qi, xout => excRNaN_uid131_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- invExcRNaN_uid142_fpDivTest(LOGICAL,141)@22
    invExcRNaN_uid142_fpDivTest_q <= STD_LOGIC_VECTOR(not (excRNaN_uid131_fpDivTest_q));

    -- signY_uid14_fpDivTest(BITSELECT,13)@0
    signY_uid14_fpDivTest_b <= b(31 downto 31);

    -- signX_uid11_fpDivTest(BITSELECT,10)@0
    signX_uid11_fpDivTest_b <= a(31 downto 31);

    -- signR_uid46_fpDivTest(LOGICAL,45)@0 + 1
    signR_uid46_fpDivTest_qi <= signX_uid11_fpDivTest_b xor signY_uid14_fpDivTest_b;
    signR_uid46_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => signR_uid46_fpDivTest_qi, xout => signR_uid46_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist23_signR_uid46_fpDivTest_q_22(DELAY,218)
    redist23_signR_uid46_fpDivTest_q_22 : dspba_delay
    GENERIC MAP ( width => 1, depth => 21, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => signR_uid46_fpDivTest_q, xout => redist23_signR_uid46_fpDivTest_q_22_q, ena => en(0), clk => clk, aclr => areset );

    -- sRPostExc_uid143_fpDivTest(LOGICAL,142)@22 + 1
    sRPostExc_uid143_fpDivTest_qi <= redist23_signR_uid46_fpDivTest_q_22_q and invExcRNaN_uid142_fpDivTest_q;
    sRPostExc_uid143_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => sRPostExc_uid143_fpDivTest_qi, xout => sRPostExc_uid143_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist1_sRPostExc_uid143_fpDivTest_q_8(DELAY,196)
    redist1_sRPostExc_uid143_fpDivTest_q_8 : dspba_delay
    GENERIC MAP ( width => 1, depth => 7, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => sRPostExc_uid143_fpDivTest_q, xout => redist1_sRPostExc_uid143_fpDivTest_q_8_q, ena => en(0), clk => clk, aclr => areset );

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- fracXExt_uid77_fpDivTest(BITJOIN,76)@20
    fracXExt_uid77_fpDivTest_q <= redist29_fracX_uid10_fpDivTest_b_6_mem_q & GND_q;

    -- lOAdded_uid57_fpDivTest(BITJOIN,56)@14
    lOAdded_uid57_fpDivTest_q <= VCC_q & fracX_uid10_fpDivTest_b;

    -- redist16_lOAdded_uid57_fpDivTest_q_5(DELAY,211)
    redist16_lOAdded_uid57_fpDivTest_q_5_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist16_lOAdded_uid57_fpDivTest_q_5_delay_0 <= STD_LOGIC_VECTOR(lOAdded_uid57_fpDivTest_q);
                    redist16_lOAdded_uid57_fpDivTest_q_5_delay_1 <= redist16_lOAdded_uid57_fpDivTest_q_5_delay_0;
                    redist16_lOAdded_uid57_fpDivTest_q_5_delay_2 <= redist16_lOAdded_uid57_fpDivTest_q_5_delay_1;
                    redist16_lOAdded_uid57_fpDivTest_q_5_q <= STD_LOGIC_VECTOR(redist16_lOAdded_uid57_fpDivTest_q_5_delay_2);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0(DELAY,248)
    redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_q <= redist16_lOAdded_uid57_fpDivTest_q_5_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- z4_uid60_fpDivTest(CONSTANT,59)
    z4_uid60_fpDivTest_q <= "0000";

    -- oFracXZ4_uid61_fpDivTest(BITJOIN,60)@19
    oFracXZ4_uid61_fpDivTest_q <= redist16_lOAdded_uid57_fpDivTest_q_5_outputreg0_q & z4_uid60_fpDivTest_q;

    -- yAddr_uid51_fpDivTest(BITSELECT,50)@0
    yAddr_uid51_fpDivTest_b <= STD_LOGIC_VECTOR(fracY_uid13_fpDivTest_b(22 downto 14));

    -- memoryC2_uid152_invTables_lutmem(DUALMEM,188)@0 + 2
    memoryC2_uid152_invTables_lutmem_aa <= yAddr_uid51_fpDivTest_b;
    memoryC2_uid152_invTables_lutmem_ena_NotRstA <= not (areset) and en(0);
    memoryC2_uid152_invTables_lutmem_reset0 <= areset;
    memoryC2_uid152_invTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 13,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Div_altera_fp_functions_19110_etcsazy_memoryC2_uid152_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => memoryC2_uid152_invTables_lutmem_ena_NotRstA,
        sclr => memoryC2_uid152_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC2_uid152_invTables_lutmem_aa,
        q_a => memoryC2_uid152_invTables_lutmem_ir
    );
    memoryC2_uid152_invTables_lutmem_r <= STD_LOGIC_VECTOR(memoryC2_uid152_invTables_lutmem_ir(12 downto 0));

    -- yPE_uid52_fpDivTest(BITSELECT,51)@0
    yPE_uid52_fpDivTest_b <= STD_LOGIC_VECTOR(b(13 downto 0));

    -- redist19_yPE_uid52_fpDivTest_b_2(DELAY,214)
    redist19_yPE_uid52_fpDivTest_b_2_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist19_yPE_uid52_fpDivTest_b_2_delay_0 <= STD_LOGIC_VECTOR(yPE_uid52_fpDivTest_b);
                    redist19_yPE_uid52_fpDivTest_b_2_q <= STD_LOGIC_VECTOR(redist19_yPE_uid52_fpDivTest_b_2_delay_0);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- yT1_uid158_invPolyEval(BITSELECT,157)@2
    yT1_uid158_invPolyEval_b <= STD_LOGIC_VECTOR(redist19_yPE_uid52_fpDivTest_b_2_q(13 downto 1));

    -- prodXY_uid174_pT1_uid159_invPolyEval_cma(CHAINMULTADD,192)@2 + 5
    -- in b@5
    prodXY_uid174_pT1_uid159_invPolyEval_cma_reset <= areset;
    prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0 <= en(0) or prodXY_uid174_pT1_uid159_invPolyEval_cma_reset;
    prodXY_uid174_pT1_uid159_invPolyEval_cma_ena1 <= prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0;
    prodXY_uid174_pT1_uid159_invPolyEval_cma_ena2 <= prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0;

    prodXY_uid174_pT1_uid159_invPolyEval_cma_a0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(yT1_uid158_invPolyEval_b),13));
    prodXY_uid174_pT1_uid159_invPolyEval_cma_c0 <= STD_LOGIC_VECTOR(RESIZE(SIGNED(memoryC2_uid152_invTables_lutmem_r),13));
    prodXY_uid174_pT1_uid159_invPolyEval_cma_DSP0 : tennm_mac
    GENERIC MAP (
        operation_mode => "m18x18_full",
        clear_type => "sclr",
        ay_scan_in_clken => "0",
        ay_scan_in_width => 13,
        ax_clken => "0",
        ax_width => 13,
        signed_may => "false",
        signed_max => "true",
        input_pipeline_clken => "2",
        second_pipeline_clken => "2",
        output_clken => "1",
        result_a_width => 26,
        bx_width => 0,
        by_width => 0,
        result_b_width => 0
    )
    PORT MAP (
        clk => clk,
        ena(0) => prodXY_uid174_pT1_uid159_invPolyEval_cma_ena0,
        ena(1) => prodXY_uid174_pT1_uid159_invPolyEval_cma_ena1,
        ena(2) => prodXY_uid174_pT1_uid159_invPolyEval_cma_ena2,
        clr(0) => prodXY_uid174_pT1_uid159_invPolyEval_cma_reset,
        clr(1) => prodXY_uid174_pT1_uid159_invPolyEval_cma_reset,
        ay => prodXY_uid174_pT1_uid159_invPolyEval_cma_a0,
        ax => prodXY_uid174_pT1_uid159_invPolyEval_cma_c0,
        resulta => prodXY_uid174_pT1_uid159_invPolyEval_cma_s0
    );
    prodXY_uid174_pT1_uid159_invPolyEval_cma_delay0 : dspba_delay
    GENERIC MAP ( width => 26, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => prodXY_uid174_pT1_uid159_invPolyEval_cma_s0, xout => prodXY_uid174_pT1_uid159_invPolyEval_cma_qq0, ena => en(0), clk => clk, aclr => areset );
    prodXY_uid174_pT1_uid159_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid174_pT1_uid159_invPolyEval_cma_qq0(25 downto 0));

    -- osig_uid175_pT1_uid159_invPolyEval(BITSELECT,174)@7
    osig_uid175_pT1_uid159_invPolyEval_b <= prodXY_uid174_pT1_uid159_invPolyEval_cma_q(25 downto 12);

    -- highBBits_uid161_invPolyEval(BITSELECT,160)@7
    highBBits_uid161_invPolyEval_b <= osig_uid175_pT1_uid159_invPolyEval_b(13 downto 1);

    -- redist21_yAddr_uid51_fpDivTest_b_5(DELAY,216)
    redist21_yAddr_uid51_fpDivTest_b_5_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist21_yAddr_uid51_fpDivTest_b_5_delay_0 <= STD_LOGIC_VECTOR(yAddr_uid51_fpDivTest_b);
                    redist21_yAddr_uid51_fpDivTest_b_5_delay_1 <= redist21_yAddr_uid51_fpDivTest_b_5_delay_0;
                    redist21_yAddr_uid51_fpDivTest_b_5_delay_2 <= redist21_yAddr_uid51_fpDivTest_b_5_delay_1;
                    redist21_yAddr_uid51_fpDivTest_b_5_delay_3 <= redist21_yAddr_uid51_fpDivTest_b_5_delay_2;
                    redist21_yAddr_uid51_fpDivTest_b_5_q <= STD_LOGIC_VECTOR(redist21_yAddr_uid51_fpDivTest_b_5_delay_3);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- memoryC1_uid149_invTables_lutmem(DUALMEM,187)@5 + 2
    memoryC1_uid149_invTables_lutmem_aa <= redist21_yAddr_uid51_fpDivTest_b_5_q;
    memoryC1_uid149_invTables_lutmem_ena_NotRstA <= not (areset) and en(0);
    memoryC1_uid149_invTables_lutmem_reset0 <= areset;
    memoryC1_uid149_invTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 22,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Div_altera_fp_functions_19110_etcsazy_memoryC1_uid149_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => memoryC1_uid149_invTables_lutmem_ena_NotRstA,
        sclr => memoryC1_uid149_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC1_uid149_invTables_lutmem_aa,
        q_a => memoryC1_uid149_invTables_lutmem_ir
    );
    memoryC1_uid149_invTables_lutmem_r <= STD_LOGIC_VECTOR(memoryC1_uid149_invTables_lutmem_ir(21 downto 0));

    -- s1sumAHighB_uid162_invPolyEval(ADD,161)@7
    s1sumAHighB_uid162_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => memoryC1_uid149_invTables_lutmem_r(21)) & memoryC1_uid149_invTables_lutmem_r));
    s1sumAHighB_uid162_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 13 => highBBits_uid161_invPolyEval_b(12)) & highBBits_uid161_invPolyEval_b));
    s1sumAHighB_uid162_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s1sumAHighB_uid162_invPolyEval_a) + SIGNED(s1sumAHighB_uid162_invPolyEval_b));
    s1sumAHighB_uid162_invPolyEval_q <= STD_LOGIC_VECTOR(s1sumAHighB_uid162_invPolyEval_o(22 downto 0));

    -- lowRangeB_uid160_invPolyEval(BITSELECT,159)@7
    lowRangeB_uid160_invPolyEval_in <= osig_uid175_pT1_uid159_invPolyEval_b(0 downto 0);
    lowRangeB_uid160_invPolyEval_b <= STD_LOGIC_VECTOR(lowRangeB_uid160_invPolyEval_in(0 downto 0));

    -- s1_uid163_invPolyEval(BITJOIN,162)@7
    s1_uid163_invPolyEval_q <= s1sumAHighB_uid162_invPolyEval_q & lowRangeB_uid160_invPolyEval_b;

    -- redist0_s1_uid163_invPolyEval_q_1(DELAY,195)
    redist0_s1_uid163_invPolyEval_q_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist0_s1_uid163_invPolyEval_q_1_q <= s1_uid163_invPolyEval_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist20_yPE_uid52_fpDivTest_b_8_rdcnt(COUNTER,250)
    -- low=0, high=4, step=1, init=0
    redist20_yPE_uid52_fpDivTest_b_8_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                        redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq <= '1';
                    ELSE
                        redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq <= '0';
                    END IF;
                    IF (redist20_yPE_uid52_fpDivTest_b_8_rdcnt_eq = '1') THEN
                        redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i <= redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i + 4;
                    ELSE
                        redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i <= redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist20_yPE_uid52_fpDivTest_b_8_rdcnt_i, 3));

    -- redist20_yPE_uid52_fpDivTest_b_8_rdmux(MUX,251)
    redist20_yPE_uid52_fpDivTest_b_8_rdmux_s <= en;
    redist20_yPE_uid52_fpDivTest_b_8_rdmux_combproc: PROCESS (redist20_yPE_uid52_fpDivTest_b_8_rdmux_s, redist20_yPE_uid52_fpDivTest_b_8_wraddr_q, redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q)
    BEGIN
        CASE (redist20_yPE_uid52_fpDivTest_b_8_rdmux_s) IS
            WHEN "0" => redist20_yPE_uid52_fpDivTest_b_8_rdmux_q <= redist20_yPE_uid52_fpDivTest_b_8_wraddr_q;
            WHEN "1" => redist20_yPE_uid52_fpDivTest_b_8_rdmux_q <= redist20_yPE_uid52_fpDivTest_b_8_rdcnt_q;
            WHEN OTHERS => redist20_yPE_uid52_fpDivTest_b_8_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist20_yPE_uid52_fpDivTest_b_8_wraddr(REG,252)
    redist20_yPE_uid52_fpDivTest_b_8_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist20_yPE_uid52_fpDivTest_b_8_wraddr_q <= "100";
            ELSE
                redist20_yPE_uid52_fpDivTest_b_8_wraddr_q <= redist20_yPE_uid52_fpDivTest_b_8_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist20_yPE_uid52_fpDivTest_b_8_mem(DUALMEM,249)
    redist20_yPE_uid52_fpDivTest_b_8_mem_ia <= STD_LOGIC_VECTOR(redist19_yPE_uid52_fpDivTest_b_2_q);
    redist20_yPE_uid52_fpDivTest_b_8_mem_aa <= redist20_yPE_uid52_fpDivTest_b_8_wraddr_q;
    redist20_yPE_uid52_fpDivTest_b_8_mem_ab <= redist20_yPE_uid52_fpDivTest_b_8_rdmux_q;
    redist20_yPE_uid52_fpDivTest_b_8_mem_ena_OrRstB <= areset or en(0);
    redist20_yPE_uid52_fpDivTest_b_8_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 14,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 14,
        widthad_b => 3,
        numwords_b => 5,
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
        clocken1 => redist20_yPE_uid52_fpDivTest_b_8_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist20_yPE_uid52_fpDivTest_b_8_mem_aa,
        data_a => redist20_yPE_uid52_fpDivTest_b_8_mem_ia,
        wren_a => en(0),
        address_b => redist20_yPE_uid52_fpDivTest_b_8_mem_ab,
        q_b => redist20_yPE_uid52_fpDivTest_b_8_mem_iq
    );
    redist20_yPE_uid52_fpDivTest_b_8_mem_q <= STD_LOGIC_VECTOR(redist20_yPE_uid52_fpDivTest_b_8_mem_iq(13 downto 0));

    -- prodXY_uid177_pT2_uid165_invPolyEval_cma(CHAINMULTADD,193)@8 + 5
    -- in b@11
    prodXY_uid177_pT2_uid165_invPolyEval_cma_reset <= areset;
    prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0 <= en(0) or prodXY_uid177_pT2_uid165_invPolyEval_cma_reset;
    prodXY_uid177_pT2_uid165_invPolyEval_cma_ena1 <= prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0;
    prodXY_uid177_pT2_uid165_invPolyEval_cma_ena2 <= prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0;

    prodXY_uid177_pT2_uid165_invPolyEval_cma_a0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(redist20_yPE_uid52_fpDivTest_b_8_mem_q),14));
    prodXY_uid177_pT2_uid165_invPolyEval_cma_c0 <= STD_LOGIC_VECTOR(RESIZE(SIGNED(redist0_s1_uid163_invPolyEval_q_1_q),24));
    prodXY_uid177_pT2_uid165_invPolyEval_cma_DSP0 : tennm_mac
    GENERIC MAP (
        operation_mode => "m27x27",
        clear_type => "sclr",
        use_chainadder => "false",
        ay_scan_in_clken => "0",
        ay_scan_in_width => 14,
        ax_clken => "0",
        ax_width => 24,
        signed_may => "false",
        signed_max => "true",
        input_pipeline_clken => "2",
        second_pipeline_clken => "2",
        output_clken => "1",
        result_a_width => 38
    )
    PORT MAP (
        clk => clk,
        ena(0) => prodXY_uid177_pT2_uid165_invPolyEval_cma_ena0,
        ena(1) => prodXY_uid177_pT2_uid165_invPolyEval_cma_ena1,
        ena(2) => prodXY_uid177_pT2_uid165_invPolyEval_cma_ena2,
        clr(0) => prodXY_uid177_pT2_uid165_invPolyEval_cma_reset,
        clr(1) => prodXY_uid177_pT2_uid165_invPolyEval_cma_reset,
        ay => prodXY_uid177_pT2_uid165_invPolyEval_cma_a0,
        ax => prodXY_uid177_pT2_uid165_invPolyEval_cma_c0,
        resulta => prodXY_uid177_pT2_uid165_invPolyEval_cma_s0
    );
    prodXY_uid177_pT2_uid165_invPolyEval_cma_delay0 : dspba_delay
    GENERIC MAP ( width => 38, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => prodXY_uid177_pT2_uid165_invPolyEval_cma_s0, xout => prodXY_uid177_pT2_uid165_invPolyEval_cma_qq0, ena => en(0), clk => clk, aclr => areset );
    prodXY_uid177_pT2_uid165_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid177_pT2_uid165_invPolyEval_cma_qq0(37 downto 0));

    -- osig_uid178_pT2_uid165_invPolyEval(BITSELECT,177)@13
    osig_uid178_pT2_uid165_invPolyEval_b <= prodXY_uid177_pT2_uid165_invPolyEval_cma_q(37 downto 13);

    -- highBBits_uid167_invPolyEval(BITSELECT,166)@13
    highBBits_uid167_invPolyEval_b <= osig_uid178_pT2_uid165_invPolyEval_b(24 downto 2);

    -- redist22_yAddr_uid51_fpDivTest_b_11_rdcnt(COUNTER,254)
    -- low=0, high=4, step=1, init=0
    redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                        redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq <= '1';
                    ELSE
                        redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq <= '0';
                    END IF;
                    IF (redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_eq = '1') THEN
                        redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i <= redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i + 4;
                    ELSE
                        redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i <= redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_i, 3));

    -- redist22_yAddr_uid51_fpDivTest_b_11_rdmux(MUX,255)
    redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s <= en;
    redist22_yAddr_uid51_fpDivTest_b_11_rdmux_combproc: PROCESS (redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s, redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q, redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q)
    BEGIN
        CASE (redist22_yAddr_uid51_fpDivTest_b_11_rdmux_s) IS
            WHEN "0" => redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q <= redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q;
            WHEN "1" => redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q <= redist22_yAddr_uid51_fpDivTest_b_11_rdcnt_q;
            WHEN OTHERS => redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist22_yAddr_uid51_fpDivTest_b_11_wraddr(REG,256)
    redist22_yAddr_uid51_fpDivTest_b_11_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q <= "100";
            ELSE
                redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q <= redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist22_yAddr_uid51_fpDivTest_b_11_mem(DUALMEM,253)
    redist22_yAddr_uid51_fpDivTest_b_11_mem_ia <= STD_LOGIC_VECTOR(redist21_yAddr_uid51_fpDivTest_b_5_q);
    redist22_yAddr_uid51_fpDivTest_b_11_mem_aa <= redist22_yAddr_uid51_fpDivTest_b_11_wraddr_q;
    redist22_yAddr_uid51_fpDivTest_b_11_mem_ab <= redist22_yAddr_uid51_fpDivTest_b_11_rdmux_q;
    redist22_yAddr_uid51_fpDivTest_b_11_mem_ena_OrRstB <= areset or en(0);
    redist22_yAddr_uid51_fpDivTest_b_11_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 9,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 9,
        widthad_b => 3,
        numwords_b => 5,
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
        clocken1 => redist22_yAddr_uid51_fpDivTest_b_11_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist22_yAddr_uid51_fpDivTest_b_11_mem_aa,
        data_a => redist22_yAddr_uid51_fpDivTest_b_11_mem_ia,
        wren_a => en(0),
        address_b => redist22_yAddr_uid51_fpDivTest_b_11_mem_ab,
        q_b => redist22_yAddr_uid51_fpDivTest_b_11_mem_iq
    );
    redist22_yAddr_uid51_fpDivTest_b_11_mem_q <= STD_LOGIC_VECTOR(redist22_yAddr_uid51_fpDivTest_b_11_mem_iq(8 downto 0));

    -- memoryC0_uid146_invTables_lutmem(DUALMEM,186)@11 + 2
    memoryC0_uid146_invTables_lutmem_aa <= redist22_yAddr_uid51_fpDivTest_b_11_mem_q;
    memoryC0_uid146_invTables_lutmem_ena_NotRstA <= not (areset) and en(0);
    memoryC0_uid146_invTables_lutmem_reset0 <= areset;
    memoryC0_uid146_invTables_lutmem_dmem : altera_syncram
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
        init_file => "fp32Div_altera_fp_functions_19110_etcsazy_memoryC0_uid146_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => memoryC0_uid146_invTables_lutmem_ena_NotRstA,
        sclr => memoryC0_uid146_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC0_uid146_invTables_lutmem_aa,
        q_a => memoryC0_uid146_invTables_lutmem_ir
    );
    memoryC0_uid146_invTables_lutmem_r <= STD_LOGIC_VECTOR(memoryC0_uid146_invTables_lutmem_ir(31 downto 0));

    -- s2sumAHighB_uid168_invPolyEval(ADD,167)@13
    s2sumAHighB_uid168_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => memoryC0_uid146_invTables_lutmem_r(31)) & memoryC0_uid146_invTables_lutmem_r));
    s2sumAHighB_uid168_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 23 => highBBits_uid167_invPolyEval_b(22)) & highBBits_uid167_invPolyEval_b));
    s2sumAHighB_uid168_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s2sumAHighB_uid168_invPolyEval_a) + SIGNED(s2sumAHighB_uid168_invPolyEval_b));
    s2sumAHighB_uid168_invPolyEval_q <= STD_LOGIC_VECTOR(s2sumAHighB_uid168_invPolyEval_o(32 downto 0));

    -- lowRangeB_uid166_invPolyEval(BITSELECT,165)@13
    lowRangeB_uid166_invPolyEval_in <= osig_uid178_pT2_uid165_invPolyEval_b(1 downto 0);
    lowRangeB_uid166_invPolyEval_b <= STD_LOGIC_VECTOR(lowRangeB_uid166_invPolyEval_in(1 downto 0));

    -- s2_uid169_invPolyEval(BITJOIN,168)@13
    s2_uid169_invPolyEval_q <= s2sumAHighB_uid168_invPolyEval_q & lowRangeB_uid166_invPolyEval_b;

    -- invY_uid54_fpDivTest(BITSELECT,53)@13
    invY_uid54_fpDivTest_in <= s2_uid169_invPolyEval_q(31 downto 0);
    invY_uid54_fpDivTest_b <= STD_LOGIC_VECTOR(invY_uid54_fpDivTest_in(31 downto 5));

    -- redist18_invY_uid54_fpDivTest_b_1(DELAY,213)
    redist18_invY_uid54_fpDivTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist18_invY_uid54_fpDivTest_b_1_q <= invY_uid54_fpDivTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma(CHAINMULTADD,191)@14 + 5
    -- in b@17
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset <= areset;
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0 <= en(0) or prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset;
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena1 <= prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0;
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena2 <= prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0;

    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_a0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(redist18_invY_uid54_fpDivTest_b_1_q),27));
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_c0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(lOAdded_uid57_fpDivTest_q),24));
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_DSP0 : tennm_mac
    GENERIC MAP (
        operation_mode => "m27x27",
        clear_type => "sclr",
        use_chainadder => "false",
        ay_scan_in_clken => "0",
        ay_scan_in_width => 27,
        ax_clken => "0",
        ax_width => 24,
        signed_may => "false",
        signed_max => "false",
        input_pipeline_clken => "2",
        second_pipeline_clken => "2",
        output_clken => "1",
        result_a_width => 51
    )
    PORT MAP (
        clk => clk,
        ena(0) => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena0,
        ena(1) => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena1,
        ena(2) => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_ena2,
        clr(0) => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset,
        clr(1) => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_reset,
        ay => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_a0,
        ax => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_c0,
        resulta => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_s0
    );
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_delay0 : dspba_delay
    GENERIC MAP ( width => 51, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_s0, xout => prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_qq0, ena => en(0), clk => clk, aclr => areset );
    prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_qq0(50 downto 0));

    -- osig_uid172_divValPreNorm_uid59_fpDivTest(BITSELECT,171)@19
    osig_uid172_divValPreNorm_uid59_fpDivTest_b <= STD_LOGIC_VECTOR(prodXY_uid171_divValPreNorm_uid59_fpDivTest_cma_q(50 downto 23));

    -- fracYZero_uid15_fpDivTest(LOGICAL,16)@0 + 1
    fracYZero_uid15_fpDivTest_a <= STD_LOGIC_VECTOR("0" & fracY_uid13_fpDivTest_b);
    fracYZero_uid15_fpDivTest_qi <= "1" WHEN fracYZero_uid15_fpDivTest_a = zeroPaddingInAddition_uid74_fpDivTest_q ELSE "0";
    fracYZero_uid15_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracYZero_uid15_fpDivTest_qi, xout => fracYZero_uid15_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist25_fracYZero_uid15_fpDivTest_q_19(DELAY,220)
    redist25_fracYZero_uid15_fpDivTest_q_19 : dspba_delay
    GENERIC MAP ( width => 1, depth => 18, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracYZero_uid15_fpDivTest_q, xout => redist25_fracYZero_uid15_fpDivTest_q_19_q, ena => en(0), clk => clk, aclr => areset );

    -- divValPreNormYPow2Exc_uid63_fpDivTest(MUX,62)@19
    divValPreNormYPow2Exc_uid63_fpDivTest_s <= redist25_fracYZero_uid15_fpDivTest_q_19_q;
    divValPreNormYPow2Exc_uid63_fpDivTest_combproc: PROCESS (divValPreNormYPow2Exc_uid63_fpDivTest_s, en, osig_uid172_divValPreNorm_uid59_fpDivTest_b, oFracXZ4_uid61_fpDivTest_q)
    BEGIN
        CASE (divValPreNormYPow2Exc_uid63_fpDivTest_s) IS
            WHEN "0" => divValPreNormYPow2Exc_uid63_fpDivTest_q <= osig_uid172_divValPreNorm_uid59_fpDivTest_b;
            WHEN "1" => divValPreNormYPow2Exc_uid63_fpDivTest_q <= oFracXZ4_uid61_fpDivTest_q;
            WHEN OTHERS => divValPreNormYPow2Exc_uid63_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- norm_uid64_fpDivTest(BITSELECT,63)@19
    norm_uid64_fpDivTest_b <= divValPreNormYPow2Exc_uid63_fpDivTest_q(27 downto 27);

    -- redist15_norm_uid64_fpDivTest_b_1(DELAY,210)
    redist15_norm_uid64_fpDivTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist15_norm_uid64_fpDivTest_b_1_q <= norm_uid64_fpDivTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- zeroPaddingInAddition_uid74_fpDivTest(CONSTANT,73)
    zeroPaddingInAddition_uid74_fpDivTest_q <= "000000000000000000000000";

    -- expFracPostRnd_uid75_fpDivTest(BITJOIN,74)@20
    expFracPostRnd_uid75_fpDivTest_q <= redist15_norm_uid64_fpDivTest_b_1_q & zeroPaddingInAddition_uid74_fpDivTest_q & VCC_q;

    -- expR_uid48_fpDivTest_lhsMSBs_select_b_const(CONSTANT,189)
    expR_uid48_fpDivTest_lhsMSBs_select_b_const_q <= "0111111";

    -- expR_uid48_fpDivTest_MSBs_sums(ADD,184)@19
    expR_uid48_fpDivTest_MSBs_sums_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expR_uid48_fpDivTest_lhsMSBs_select_b_const_q));
    expR_uid48_fpDivTest_MSBs_sums_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((9 downto 8 => expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b(7)) & expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b));
    expR_uid48_fpDivTest_MSBs_sums_o <= STD_LOGIC_VECTOR(SIGNED(expR_uid48_fpDivTest_MSBs_sums_a) + SIGNED(expR_uid48_fpDivTest_MSBs_sums_b));
    expR_uid48_fpDivTest_MSBs_sums_q <= STD_LOGIC_VECTOR(expR_uid48_fpDivTest_MSBs_sums_o(8 downto 0));

    -- expXmY_uid47_fpDivTest(SUB,46)@18 + 1
    expXmY_uid47_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & redist30_expX_uid9_fpDivTest_b_4_q));
    expXmY_uid47_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & redist26_expY_uid12_fpDivTest_b_18_mem_q));
    expXmY_uid47_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                expXmY_uid47_fpDivTest_o <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    expXmY_uid47_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expXmY_uid47_fpDivTest_a) - SIGNED(expXmY_uid47_fpDivTest_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    expXmY_uid47_fpDivTest_q <= STD_LOGIC_VECTOR(expXmY_uid47_fpDivTest_o(8 downto 0));

    -- expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged(BITSELECT,194)@19
    expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_b <= expXmY_uid47_fpDivTest_q(8 downto 1);
    expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_c <= expXmY_uid47_fpDivTest_q(0 downto 0);

    -- expR_uid48_fpDivTest_split_join(BITJOIN,185)@19
    expR_uid48_fpDivTest_split_join_q <= expR_uid48_fpDivTest_MSBs_sums_q & expR_uid48_fpDivTest_rhsMSBs_select_bit_select_merged_c;

    -- divValPreNormHigh_uid65_fpDivTest(BITSELECT,64)@19
    divValPreNormHigh_uid65_fpDivTest_in <= divValPreNormYPow2Exc_uid63_fpDivTest_q(26 downto 0);
    divValPreNormHigh_uid65_fpDivTest_b <= STD_LOGIC_VECTOR(divValPreNormHigh_uid65_fpDivTest_in(26 downto 2));

    -- divValPreNormLow_uid66_fpDivTest(BITSELECT,65)@19
    divValPreNormLow_uid66_fpDivTest_in <= divValPreNormYPow2Exc_uid63_fpDivTest_q(25 downto 0);
    divValPreNormLow_uid66_fpDivTest_b <= STD_LOGIC_VECTOR(divValPreNormLow_uid66_fpDivTest_in(25 downto 1));

    -- normFracRnd_uid67_fpDivTest(MUX,66)@19
    normFracRnd_uid67_fpDivTest_s <= norm_uid64_fpDivTest_b;
    normFracRnd_uid67_fpDivTest_combproc: PROCESS (normFracRnd_uid67_fpDivTest_s, en, divValPreNormLow_uid66_fpDivTest_b, divValPreNormHigh_uid65_fpDivTest_b)
    BEGIN
        CASE (normFracRnd_uid67_fpDivTest_s) IS
            WHEN "0" => normFracRnd_uid67_fpDivTest_q <= divValPreNormLow_uid66_fpDivTest_b;
            WHEN "1" => normFracRnd_uid67_fpDivTest_q <= divValPreNormHigh_uid65_fpDivTest_b;
            WHEN OTHERS => normFracRnd_uid67_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expFracRnd_uid68_fpDivTest(BITJOIN,67)@19
    expFracRnd_uid68_fpDivTest_q <= expR_uid48_fpDivTest_split_join_q & normFracRnd_uid67_fpDivTest_q;

    -- redist14_expFracRnd_uid68_fpDivTest_q_1(DELAY,209)
    redist14_expFracRnd_uid68_fpDivTest_q_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist14_expFracRnd_uid68_fpDivTest_q_1_q <= expFracRnd_uid68_fpDivTest_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expFracPostRnd_uid76_fpDivTest(ADD,75)@20
    expFracPostRnd_uid76_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => redist14_expFracRnd_uid68_fpDivTest_q_1_q(34)) & redist14_expFracRnd_uid68_fpDivTest_q_1_q));
    expFracPostRnd_uid76_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & expFracPostRnd_uid75_fpDivTest_q));
    expFracPostRnd_uid76_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracPostRnd_uid76_fpDivTest_a) + SIGNED(expFracPostRnd_uid76_fpDivTest_b));
    expFracPostRnd_uid76_fpDivTest_q <= STD_LOGIC_VECTOR(expFracPostRnd_uid76_fpDivTest_o(35 downto 0));

    -- fracPostRndF_uid79_fpDivTest(BITSELECT,78)@20
    fracPostRndF_uid79_fpDivTest_in <= expFracPostRnd_uid76_fpDivTest_q(24 downto 0);
    fracPostRndF_uid79_fpDivTest_b <= STD_LOGIC_VECTOR(fracPostRndF_uid79_fpDivTest_in(24 downto 1));

    -- invYO_uid55_fpDivTest(BITSELECT,54)@13
    invYO_uid55_fpDivTest_in <= STD_LOGIC_VECTOR(s2_uid169_invPolyEval_q(32 downto 0));
    invYO_uid55_fpDivTest_b <= invYO_uid55_fpDivTest_in(32 downto 32);

    -- redist17_invYO_uid55_fpDivTest_b_7(DELAY,212)
    redist17_invYO_uid55_fpDivTest_b_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 7, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => invYO_uid55_fpDivTest_b, xout => redist17_invYO_uid55_fpDivTest_b_7_q, ena => en(0), clk => clk, aclr => areset );

    -- fracPostRndF_uid80_fpDivTest(MUX,79)@20 + 1
    fracPostRndF_uid80_fpDivTest_s <= redist17_invYO_uid55_fpDivTest_b_7_q;
    fracPostRndF_uid80_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                fracPostRndF_uid80_fpDivTest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (fracPostRndF_uid80_fpDivTest_s) IS
                        WHEN "0" => fracPostRndF_uid80_fpDivTest_q <= fracPostRndF_uid79_fpDivTest_b;
                        WHEN "1" => fracPostRndF_uid80_fpDivTest_q <= fracXExt_uid77_fpDivTest_q;
                        WHEN OTHERS => fracPostRndF_uid80_fpDivTest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- betweenFPwF_uid102_fpDivTest(BITSELECT,101)@21
    betweenFPwF_uid102_fpDivTest_in <= STD_LOGIC_VECTOR(fracPostRndF_uid80_fpDivTest_q(0 downto 0));
    betweenFPwF_uid102_fpDivTest_b <= betweenFPwF_uid102_fpDivTest_in(0 downto 0);

    -- redist7_betweenFPwF_uid102_fpDivTest_b_7(DELAY,202)
    redist7_betweenFPwF_uid102_fpDivTest_b_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 7, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => betweenFPwF_uid102_fpDivTest_b, xout => redist7_betweenFPwF_uid102_fpDivTest_b_7_q, ena => en(0), clk => clk, aclr => areset );

    -- redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt(COUNTER,235)
    -- low=0, high=5, step=1, init=0
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i = TO_UNSIGNED(4, 3)) THEN
                        redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq <= '1';
                    ELSE
                        redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq <= '0';
                    END IF;
                    IF (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_eq = '1') THEN
                        redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i + 3;
                    ELSE
                        redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_i, 3));

    -- redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux(MUX,236)
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s <= en;
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_combproc: PROCESS (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s, redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q, redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q)
    BEGIN
        CASE (redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_s) IS
            WHEN "0" => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q;
            WHEN "1" => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdcnt_q;
            WHEN OTHERS => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- qDivProdLTX_opB_uid100_fpDivTest(BITJOIN,99)@20
    qDivProdLTX_opB_uid100_fpDivTest_q <= redist31_expX_uid9_fpDivTest_b_6_q & redist29_fracX_uid10_fpDivTest_b_6_mem_q;

    -- redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr(REG,237)
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q <= "101";
            ELSE
                redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem(DUALMEM,234)
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ia <= STD_LOGIC_VECTOR(qDivProdLTX_opB_uid100_fpDivTest_q);
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_aa <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_wraddr_q;
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ab <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_rdmux_q;
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ena_OrRstB <= areset or en(0);
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 31,
        widthad_a => 3,
        numwords_a => 6,
        width_b => 31,
        widthad_b => 3,
        numwords_b => 6,
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
        clocken1 => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_aa,
        data_a => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ia,
        wren_a => en(0),
        address_b => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_ab,
        q_b => redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_iq
    );
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_q <= STD_LOGIC_VECTOR(redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_iq(30 downto 0));

    -- redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0(DELAY,233)
    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_q <= redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_mem_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt(COUNTER,239)
    -- low=0, high=19, step=1, init=0
    redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i <= TO_UNSIGNED(0, 5);
                redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i = TO_UNSIGNED(18, 5)) THEN
                        redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq <= '1';
                    ELSE
                        redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq <= '0';
                    END IF;
                    IF (redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_eq = '1') THEN
                        redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i <= redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i + 13;
                    ELSE
                        redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i <= redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_i, 5));

    -- redist12_lOAdded_uid87_fpDivTest_q_21_rdmux(MUX,240)
    redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s <= en;
    redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_combproc: PROCESS (redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s, redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q, redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q)
    BEGIN
        CASE (redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_s) IS
            WHEN "0" => redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q <= redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q;
            WHEN "1" => redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q <= redist12_lOAdded_uid87_fpDivTest_q_21_rdcnt_q;
            WHEN OTHERS => redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- lOAdded_uid87_fpDivTest(BITJOIN,86)@0
    lOAdded_uid87_fpDivTest_q <= VCC_q & fracY_uid13_fpDivTest_b;

    -- redist12_lOAdded_uid87_fpDivTest_q_21_wraddr(REG,241)
    redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q <= "10011";
            ELSE
                redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q <= redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist12_lOAdded_uid87_fpDivTest_q_21_mem(DUALMEM,238)
    redist12_lOAdded_uid87_fpDivTest_q_21_mem_ia <= STD_LOGIC_VECTOR(lOAdded_uid87_fpDivTest_q);
    redist12_lOAdded_uid87_fpDivTest_q_21_mem_aa <= redist12_lOAdded_uid87_fpDivTest_q_21_wraddr_q;
    redist12_lOAdded_uid87_fpDivTest_q_21_mem_ab <= redist12_lOAdded_uid87_fpDivTest_q_21_rdmux_q;
    redist12_lOAdded_uid87_fpDivTest_q_21_mem_ena_OrRstB <= areset or en(0);
    redist12_lOAdded_uid87_fpDivTest_q_21_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 24,
        widthad_a => 5,
        numwords_a => 20,
        width_b => 24,
        widthad_b => 5,
        numwords_b => 20,
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
        clocken1 => redist12_lOAdded_uid87_fpDivTest_q_21_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist12_lOAdded_uid87_fpDivTest_q_21_mem_aa,
        data_a => redist12_lOAdded_uid87_fpDivTest_q_21_mem_ia,
        wren_a => en(0),
        address_b => redist12_lOAdded_uid87_fpDivTest_q_21_mem_ab,
        q_b => redist12_lOAdded_uid87_fpDivTest_q_21_mem_iq
    );
    redist12_lOAdded_uid87_fpDivTest_q_21_mem_q <= STD_LOGIC_VECTOR(redist12_lOAdded_uid87_fpDivTest_q_21_mem_iq(23 downto 0));

    -- lOAdded_uid84_fpDivTest(BITJOIN,83)@21
    lOAdded_uid84_fpDivTest_q <= VCC_q & fracPostRndF_uid80_fpDivTest_q;

    -- qDivProd_uid89_fpDivTest_cma(CHAINMULTADD,190)@21 + 5
    -- in b@24
    qDivProd_uid89_fpDivTest_cma_reset <= areset;
    qDivProd_uid89_fpDivTest_cma_ena0 <= en(0) or qDivProd_uid89_fpDivTest_cma_reset;
    qDivProd_uid89_fpDivTest_cma_ena1 <= qDivProd_uid89_fpDivTest_cma_ena0;
    qDivProd_uid89_fpDivTest_cma_ena2 <= qDivProd_uid89_fpDivTest_cma_ena0;

    qDivProd_uid89_fpDivTest_cma_a0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(lOAdded_uid84_fpDivTest_q),25));
    qDivProd_uid89_fpDivTest_cma_c0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(redist12_lOAdded_uid87_fpDivTest_q_21_mem_q),24));
    qDivProd_uid89_fpDivTest_cma_DSP0 : tennm_mac
    GENERIC MAP (
        operation_mode => "m27x27",
        clear_type => "sclr",
        use_chainadder => "false",
        ay_scan_in_clken => "0",
        ay_scan_in_width => 25,
        ax_clken => "0",
        ax_width => 24,
        signed_may => "false",
        signed_max => "false",
        input_pipeline_clken => "2",
        second_pipeline_clken => "2",
        output_clken => "1",
        result_a_width => 49
    )
    PORT MAP (
        clk => clk,
        ena(0) => qDivProd_uid89_fpDivTest_cma_ena0,
        ena(1) => qDivProd_uid89_fpDivTest_cma_ena1,
        ena(2) => qDivProd_uid89_fpDivTest_cma_ena2,
        clr(0) => qDivProd_uid89_fpDivTest_cma_reset,
        clr(1) => qDivProd_uid89_fpDivTest_cma_reset,
        ay => qDivProd_uid89_fpDivTest_cma_a0,
        ax => qDivProd_uid89_fpDivTest_cma_c0,
        resulta => qDivProd_uid89_fpDivTest_cma_s0
    );
    qDivProd_uid89_fpDivTest_cma_delay0 : dspba_delay
    GENERIC MAP ( width => 49, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => qDivProd_uid89_fpDivTest_cma_s0, xout => qDivProd_uid89_fpDivTest_cma_qq0, ena => en(0), clk => clk, aclr => areset );
    qDivProd_uid89_fpDivTest_cma_q <= STD_LOGIC_VECTOR(qDivProd_uid89_fpDivTest_cma_qq0(48 downto 0));

    -- qDivProdNorm_uid90_fpDivTest(BITSELECT,89)@26
    qDivProdNorm_uid90_fpDivTest_b <= qDivProd_uid89_fpDivTest_cma_q(48 downto 48);

    -- cstBias_uid7_fpDivTest(CONSTANT,6)
    cstBias_uid7_fpDivTest_q <= "01111111";

    -- qDivProdExp_opBs_uid95_fpDivTest(SUB,94)@26 + 1
    qDivProdExp_opBs_uid95_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & cstBias_uid7_fpDivTest_q));
    qDivProdExp_opBs_uid95_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000" & qDivProdNorm_uid90_fpDivTest_b));
    qDivProdExp_opBs_uid95_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                qDivProdExp_opBs_uid95_fpDivTest_o <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    qDivProdExp_opBs_uid95_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(qDivProdExp_opBs_uid95_fpDivTest_a) - SIGNED(qDivProdExp_opBs_uid95_fpDivTest_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    qDivProdExp_opBs_uid95_fpDivTest_q <= STD_LOGIC_VECTOR(qDivProdExp_opBs_uid95_fpDivTest_o(8 downto 0));

    -- expPostRndFR_uid81_fpDivTest(BITSELECT,80)@20
    expPostRndFR_uid81_fpDivTest_in <= expFracPostRnd_uid76_fpDivTest_q(32 downto 0);
    expPostRndFR_uid81_fpDivTest_b <= STD_LOGIC_VECTOR(expPostRndFR_uid81_fpDivTest_in(32 downto 25));

    -- expPostRndF_uid82_fpDivTest(MUX,81)@20 + 1
    expPostRndF_uid82_fpDivTest_s <= redist17_invYO_uid55_fpDivTest_b_7_q;
    expPostRndF_uid82_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                expPostRndF_uid82_fpDivTest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (expPostRndF_uid82_fpDivTest_s) IS
                        WHEN "0" => expPostRndF_uid82_fpDivTest_q <= expPostRndFR_uid81_fpDivTest_b;
                        WHEN "1" => expPostRndF_uid82_fpDivTest_q <= redist31_expX_uid9_fpDivTest_b_6_q;
                        WHEN OTHERS => expPostRndF_uid82_fpDivTest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- qDivProdExp_opA_uid94_fpDivTest(ADD,93)@21 + 1
    qDivProdExp_opA_uid94_fpDivTest_a <= STD_LOGIC_VECTOR("0" & redist28_expY_uid12_fpDivTest_b_21_q);
    qDivProdExp_opA_uid94_fpDivTest_b <= STD_LOGIC_VECTOR("0" & expPostRndF_uid82_fpDivTest_q);
    qDivProdExp_opA_uid94_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                qDivProdExp_opA_uid94_fpDivTest_o <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    qDivProdExp_opA_uid94_fpDivTest_o <= STD_LOGIC_VECTOR(UNSIGNED(qDivProdExp_opA_uid94_fpDivTest_a) + UNSIGNED(qDivProdExp_opA_uid94_fpDivTest_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    qDivProdExp_opA_uid94_fpDivTest_q <= STD_LOGIC_VECTOR(qDivProdExp_opA_uid94_fpDivTest_o(8 downto 0));

    -- redist11_qDivProdExp_opA_uid94_fpDivTest_q_6(DELAY,206)
    redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_0 <= STD_LOGIC_VECTOR(qDivProdExp_opA_uid94_fpDivTest_q);
                    redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_1 <= redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_0;
                    redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_2 <= redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_1;
                    redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_3 <= redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_2;
                    redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_q <= STD_LOGIC_VECTOR(redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_delay_3);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- qDivProdExp_uid96_fpDivTest(SUB,95)@27
    qDivProdExp_uid96_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & redist11_qDivProdExp_opA_uid94_fpDivTest_q_6_q));
    qDivProdExp_uid96_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 9 => qDivProdExp_opBs_uid95_fpDivTest_q(8)) & qDivProdExp_opBs_uid95_fpDivTest_q));
    qDivProdExp_uid96_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(qDivProdExp_uid96_fpDivTest_a) - SIGNED(qDivProdExp_uid96_fpDivTest_b));
    qDivProdExp_uid96_fpDivTest_q <= STD_LOGIC_VECTOR(qDivProdExp_uid96_fpDivTest_o(10 downto 0));

    -- qDivProdLTX_opA_uid98_fpDivTest(BITSELECT,97)@27
    qDivProdLTX_opA_uid98_fpDivTest_in <= qDivProdExp_uid96_fpDivTest_q(7 downto 0);
    qDivProdLTX_opA_uid98_fpDivTest_b <= STD_LOGIC_VECTOR(qDivProdLTX_opA_uid98_fpDivTest_in(7 downto 0));

    -- qDivProdFracHigh_uid91_fpDivTest(BITSELECT,90)@26
    qDivProdFracHigh_uid91_fpDivTest_in <= qDivProd_uid89_fpDivTest_cma_q(47 downto 0);
    qDivProdFracHigh_uid91_fpDivTest_b <= STD_LOGIC_VECTOR(qDivProdFracHigh_uid91_fpDivTest_in(47 downto 24));

    -- qDivProdFracLow_uid92_fpDivTest(BITSELECT,91)@26
    qDivProdFracLow_uid92_fpDivTest_in <= qDivProd_uid89_fpDivTest_cma_q(46 downto 0);
    qDivProdFracLow_uid92_fpDivTest_b <= STD_LOGIC_VECTOR(qDivProdFracLow_uid92_fpDivTest_in(46 downto 23));

    -- qDivProdFrac_uid93_fpDivTest(MUX,92)@26
    qDivProdFrac_uid93_fpDivTest_s <= qDivProdNorm_uid90_fpDivTest_b;
    qDivProdFrac_uid93_fpDivTest_combproc: PROCESS (qDivProdFrac_uid93_fpDivTest_s, en, qDivProdFracLow_uid92_fpDivTest_b, qDivProdFracHigh_uid91_fpDivTest_b)
    BEGIN
        CASE (qDivProdFrac_uid93_fpDivTest_s) IS
            WHEN "0" => qDivProdFrac_uid93_fpDivTest_q <= qDivProdFracLow_uid92_fpDivTest_b;
            WHEN "1" => qDivProdFrac_uid93_fpDivTest_q <= qDivProdFracHigh_uid91_fpDivTest_b;
            WHEN OTHERS => qDivProdFrac_uid93_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- qDivProdFracWF_uid97_fpDivTest(BITSELECT,96)@26
    qDivProdFracWF_uid97_fpDivTest_b <= STD_LOGIC_VECTOR(qDivProdFrac_uid93_fpDivTest_q(23 downto 1));

    -- redist10_qDivProdFracWF_uid97_fpDivTest_b_1(DELAY,205)
    redist10_qDivProdFracWF_uid97_fpDivTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist10_qDivProdFracWF_uid97_fpDivTest_b_1_q <= qDivProdFracWF_uid97_fpDivTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- qDivProdLTX_opA_uid99_fpDivTest(BITJOIN,98)@27
    qDivProdLTX_opA_uid99_fpDivTest_q <= qDivProdLTX_opA_uid98_fpDivTest_b & redist10_qDivProdFracWF_uid97_fpDivTest_b_1_q;

    -- redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1(DELAY,204)
    redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_q <= qDivProdLTX_opA_uid99_fpDivTest_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- qDividerProdLTX_uid101_fpDivTest(COMPARE,100)@28
    qDividerProdLTX_uid101_fpDivTest_a <= STD_LOGIC_VECTOR("00" & redist9_qDivProdLTX_opA_uid99_fpDivTest_q_1_q);
    qDividerProdLTX_uid101_fpDivTest_b <= STD_LOGIC_VECTOR("00" & redist8_qDivProdLTX_opB_uid100_fpDivTest_q_8_outputreg0_q);
    qDividerProdLTX_uid101_fpDivTest_o <= STD_LOGIC_VECTOR(UNSIGNED(qDividerProdLTX_uid101_fpDivTest_a) - UNSIGNED(qDividerProdLTX_uid101_fpDivTest_b));
    qDividerProdLTX_uid101_fpDivTest_c(0) <= qDividerProdLTX_uid101_fpDivTest_o(32);

    -- extraUlp_uid103_fpDivTest(LOGICAL,102)@28 + 1
    extraUlp_uid103_fpDivTest_qi <= qDividerProdLTX_uid101_fpDivTest_c and redist7_betweenFPwF_uid102_fpDivTest_b_7_q;
    extraUlp_uid103_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => extraUlp_uid103_fpDivTest_qi, xout => extraUlp_uid103_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt(COUNTER,230)
    -- low=0, high=5, step=1, init=0
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i = TO_UNSIGNED(4, 3)) THEN
                        redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq <= '1';
                    ELSE
                        redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq <= '0';
                    END IF;
                    IF (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_eq = '1') THEN
                        redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i + 3;
                    ELSE
                        redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_i, 3));

    -- redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux(MUX,231)
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s <= en;
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_combproc: PROCESS (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s, redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q, redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q)
    BEGIN
        CASE (redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_s) IS
            WHEN "0" => redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q;
            WHEN "1" => redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdcnt_q;
            WHEN OTHERS => redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracPostRndFT_uid104_fpDivTest(BITSELECT,103)@21
    fracPostRndFT_uid104_fpDivTest_b <= STD_LOGIC_VECTOR(fracPostRndF_uid80_fpDivTest_q(23 downto 1));

    -- redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr(REG,232)
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q <= "101";
            ELSE
                redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem(DUALMEM,229)
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ia <= STD_LOGIC_VECTOR(fracPostRndFT_uid104_fpDivTest_b);
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_aa <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_wraddr_q;
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ab <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_rdmux_q;
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ena_OrRstB <= areset or en(0);
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 23,
        widthad_a => 3,
        numwords_a => 6,
        width_b => 23,
        widthad_b => 3,
        numwords_b => 6,
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
        clocken1 => redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_aa,
        data_a => redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ia,
        wren_a => en(0),
        address_b => redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_ab,
        q_b => redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_iq
    );
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_q <= STD_LOGIC_VECTOR(redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_iq(22 downto 0));

    -- redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0(DELAY,228)
    redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_mem_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- fracRPreExcExt_uid105_fpDivTest(ADD,104)@29
    fracRPreExcExt_uid105_fpDivTest_a <= STD_LOGIC_VECTOR("0" & redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q);
    fracRPreExcExt_uid105_fpDivTest_b <= STD_LOGIC_VECTOR("00000000000000000000000" & extraUlp_uid103_fpDivTest_q);
    fracRPreExcExt_uid105_fpDivTest_o <= STD_LOGIC_VECTOR(UNSIGNED(fracRPreExcExt_uid105_fpDivTest_a) + UNSIGNED(fracRPreExcExt_uid105_fpDivTest_b));
    fracRPreExcExt_uid105_fpDivTest_q <= STD_LOGIC_VECTOR(fracRPreExcExt_uid105_fpDivTest_o(23 downto 0));

    -- ovfIncRnd_uid109_fpDivTest(BITSELECT,108)@29
    ovfIncRnd_uid109_fpDivTest_b <= fracRPreExcExt_uid105_fpDivTest_q(23 downto 23);

    -- redist4_ovfIncRnd_uid109_fpDivTest_b_1(DELAY,199)
    redist4_ovfIncRnd_uid109_fpDivTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist4_ovfIncRnd_uid109_fpDivTest_b_1_q <= ovfIncRnd_uid109_fpDivTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expFracPostRndInc_uid110_fpDivTest(ADD,109)@30
    expFracPostRndInc_uid110_fpDivTest_a <= STD_LOGIC_VECTOR("0" & redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q);
    expFracPostRndInc_uid110_fpDivTest_b <= STD_LOGIC_VECTOR("00000000" & redist4_ovfIncRnd_uid109_fpDivTest_b_1_q);
    expFracPostRndInc_uid110_fpDivTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expFracPostRndInc_uid110_fpDivTest_a) + UNSIGNED(expFracPostRndInc_uid110_fpDivTest_b));
    expFracPostRndInc_uid110_fpDivTest_q <= STD_LOGIC_VECTOR(expFracPostRndInc_uid110_fpDivTest_o(8 downto 0));

    -- expFracPostRndR_uid111_fpDivTest(BITSELECT,110)@30
    expFracPostRndR_uid111_fpDivTest_in <= expFracPostRndInc_uid110_fpDivTest_q(7 downto 0);
    expFracPostRndR_uid111_fpDivTest_b <= STD_LOGIC_VECTOR(expFracPostRndR_uid111_fpDivTest_in(7 downto 0));

    -- redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt(COUNTER,245)
    -- low=0, high=6, step=1, init=0
    redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i = TO_UNSIGNED(5, 3)) THEN
                        redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq <= '1';
                    ELSE
                        redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq <= '0';
                    END IF;
                    IF (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_eq = '1') THEN
                        redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i <= redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i + 2;
                    ELSE
                        redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i <= redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_i, 3));

    -- redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux(MUX,246)
    redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s <= en;
    redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_combproc: PROCESS (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s, redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q, redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q)
    BEGIN
        CASE (redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_s) IS
            WHEN "0" => redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q;
            WHEN "1" => redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_rdcnt_q;
            WHEN OTHERS => redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0(DELAY,242)
    redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_q <= expPostRndFR_uid81_fpDivTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr(REG,247)
    redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q <= "110";
            ELSE
                redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist13_expPostRndFR_uid81_fpDivTest_b_10_mem(DUALMEM,244)
    redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ia <= STD_LOGIC_VECTOR(redist13_expPostRndFR_uid81_fpDivTest_b_10_inputreg0_q);
    redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_aa <= redist13_expPostRndFR_uid81_fpDivTest_b_10_wraddr_q;
    redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ab <= redist13_expPostRndFR_uid81_fpDivTest_b_10_rdmux_q;
    redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ena_OrRstB <= areset or en(0);
    redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 8,
        widthad_a => 3,
        numwords_a => 7,
        width_b => 8,
        widthad_b => 3,
        numwords_b => 7,
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
        clocken1 => redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_aa,
        data_a => redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ia,
        wren_a => en(0),
        address_b => redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_ab,
        q_b => redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_iq
    );
    redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_q <= STD_LOGIC_VECTOR(redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_iq(7 downto 0));

    -- redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0(DELAY,243)
    redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_mem_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist6_extraUlp_uid103_fpDivTest_q_2(DELAY,201)
    redist6_extraUlp_uid103_fpDivTest_q_2_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist6_extraUlp_uid103_fpDivTest_q_2_q <= extraUlp_uid103_fpDivTest_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expRPreExc_uid112_fpDivTest(MUX,111)@30
    expRPreExc_uid112_fpDivTest_s <= redist6_extraUlp_uid103_fpDivTest_q_2_q;
    expRPreExc_uid112_fpDivTest_combproc: PROCESS (expRPreExc_uid112_fpDivTest_s, en, redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q, expFracPostRndR_uid111_fpDivTest_b)
    BEGIN
        CASE (expRPreExc_uid112_fpDivTest_s) IS
            WHEN "0" => expRPreExc_uid112_fpDivTest_q <= redist13_expPostRndFR_uid81_fpDivTest_b_10_outputreg0_q;
            WHEN "1" => expRPreExc_uid112_fpDivTest_q <= expFracPostRndR_uid111_fpDivTest_b;
            WHEN OTHERS => expRPreExc_uid112_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- invExpXIsMax_uid43_fpDivTest(LOGICAL,42)@21
    invExpXIsMax_uid43_fpDivTest_q <= STD_LOGIC_VECTOR(not (expXIsMax_uid38_fpDivTest_q));

    -- InvExpXIsZero_uid44_fpDivTest(LOGICAL,43)@21
    InvExpXIsZero_uid44_fpDivTest_q <= STD_LOGIC_VECTOR(not (excZ_y_uid37_fpDivTest_q));

    -- excR_y_uid45_fpDivTest(LOGICAL,44)@21
    excR_y_uid45_fpDivTest_q <= STD_LOGIC_VECTOR(InvExpXIsZero_uid44_fpDivTest_q and invExpXIsMax_uid43_fpDivTest_q);

    -- excXIYR_uid127_fpDivTest(LOGICAL,126)@21
    excXIYR_uid127_fpDivTest_q <= STD_LOGIC_VECTOR(excI_x_uid27_fpDivTest_q and excR_y_uid45_fpDivTest_q);

    -- excXIYZ_uid126_fpDivTest(LOGICAL,125)@21
    excXIYZ_uid126_fpDivTest_q <= STD_LOGIC_VECTOR(excI_x_uid27_fpDivTest_q and excZ_y_uid37_fpDivTest_q);

    -- expRExt_uid114_fpDivTest(BITSELECT,113)@20
    expRExt_uid114_fpDivTest_b <= expFracPostRnd_uid76_fpDivTest_q(35 downto 25);

    -- redist3_expRExt_uid114_fpDivTest_b_1(DELAY,198)
    redist3_expRExt_uid114_fpDivTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist3_expRExt_uid114_fpDivTest_b_1_q <= expRExt_uid114_fpDivTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- expOvf_uid118_fpDivTest(COMPARE,117)@21
    expOvf_uid118_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => redist3_expRExt_uid114_fpDivTest_b_1_q(10)) & redist3_expRExt_uid114_fpDivTest_b_1_q));
    expOvf_uid118_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000" & cstAllOWE_uid18_fpDivTest_q));
    expOvf_uid118_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid118_fpDivTest_a) - SIGNED(expOvf_uid118_fpDivTest_b));
    expOvf_uid118_fpDivTest_n(0) <= not (expOvf_uid118_fpDivTest_o(12));

    -- invExpXIsMax_uid29_fpDivTest(LOGICAL,28)@21
    invExpXIsMax_uid29_fpDivTest_q <= STD_LOGIC_VECTOR(not (expXIsMax_uid24_fpDivTest_q));

    -- InvExpXIsZero_uid30_fpDivTest(LOGICAL,29)@21
    InvExpXIsZero_uid30_fpDivTest_q <= STD_LOGIC_VECTOR(not (excZ_x_uid23_fpDivTest_q));

    -- excR_x_uid31_fpDivTest(LOGICAL,30)@21
    excR_x_uid31_fpDivTest_q <= STD_LOGIC_VECTOR(InvExpXIsZero_uid30_fpDivTest_q and invExpXIsMax_uid29_fpDivTest_q);

    -- excXRYROvf_uid125_fpDivTest(LOGICAL,124)@21
    excXRYROvf_uid125_fpDivTest_q <= STD_LOGIC_VECTOR(excR_x_uid31_fpDivTest_q and excR_y_uid45_fpDivTest_q and expOvf_uid118_fpDivTest_n);

    -- excXRYZ_uid124_fpDivTest(LOGICAL,123)@21
    excXRYZ_uid124_fpDivTest_q <= STD_LOGIC_VECTOR(excR_x_uid31_fpDivTest_q and excZ_y_uid37_fpDivTest_q);

    -- excRInf_uid128_fpDivTest(LOGICAL,127)@21 + 1
    excRInf_uid128_fpDivTest_qi <= excXRYZ_uid124_fpDivTest_q or excXRYROvf_uid125_fpDivTest_q or excXIYZ_uid126_fpDivTest_q or excXIYR_uid127_fpDivTest_q;
    excRInf_uid128_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => excRInf_uid128_fpDivTest_qi, xout => excRInf_uid128_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- xRegOrZero_uid121_fpDivTest(LOGICAL,120)@21
    xRegOrZero_uid121_fpDivTest_q <= STD_LOGIC_VECTOR(excR_x_uid31_fpDivTest_q or excZ_x_uid23_fpDivTest_q);

    -- regOrZeroOverInf_uid122_fpDivTest(LOGICAL,121)@21
    regOrZeroOverInf_uid122_fpDivTest_q <= STD_LOGIC_VECTOR(xRegOrZero_uid121_fpDivTest_q and excI_y_uid41_fpDivTest_q);

    -- expUdf_uid115_fpDivTest(COMPARE,114)@21
    expUdf_uid115_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000000000" & GND_q));
    expUdf_uid115_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => redist3_expRExt_uid114_fpDivTest_b_1_q(10)) & redist3_expRExt_uid114_fpDivTest_b_1_q));
    expUdf_uid115_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expUdf_uid115_fpDivTest_a) - SIGNED(expUdf_uid115_fpDivTest_b));
    expUdf_uid115_fpDivTest_n(0) <= not (expUdf_uid115_fpDivTest_o(12));

    -- regOverRegWithUf_uid120_fpDivTest(LOGICAL,119)@21
    regOverRegWithUf_uid120_fpDivTest_q <= STD_LOGIC_VECTOR(expUdf_uid115_fpDivTest_n and excR_x_uid31_fpDivTest_q and excR_y_uid45_fpDivTest_q);

    -- zeroOverReg_uid119_fpDivTest(LOGICAL,118)@21
    zeroOverReg_uid119_fpDivTest_q <= STD_LOGIC_VECTOR(excZ_x_uid23_fpDivTest_q and excR_y_uid45_fpDivTest_q);

    -- excRZero_uid123_fpDivTest(LOGICAL,122)@21 + 1
    excRZero_uid123_fpDivTest_qi <= zeroOverReg_uid119_fpDivTest_q or regOverRegWithUf_uid120_fpDivTest_q or regOrZeroOverInf_uid122_fpDivTest_q;
    excRZero_uid123_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => excRZero_uid123_fpDivTest_qi, xout => excRZero_uid123_fpDivTest_q, ena => en(0), clk => clk, aclr => areset );

    -- concExc_uid132_fpDivTest(BITJOIN,131)@22
    concExc_uid132_fpDivTest_q <= excRNaN_uid131_fpDivTest_q & excRInf_uid128_fpDivTest_q & excRZero_uid123_fpDivTest_q;

    -- excREnc_uid133_fpDivTest(LOOKUP,132)@22 + 1
    excREnc_uid133_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                excREnc_uid133_fpDivTest_q <= "01";
            ELSE
                IF (en = "1") THEN
                    CASE (concExc_uid132_fpDivTest_q) IS
                        WHEN "000" => excREnc_uid133_fpDivTest_q <= "01";
                        WHEN "001" => excREnc_uid133_fpDivTest_q <= "00";
                        WHEN "010" => excREnc_uid133_fpDivTest_q <= "10";
                        WHEN "011" => excREnc_uid133_fpDivTest_q <= "00";
                        WHEN "100" => excREnc_uid133_fpDivTest_q <= "11";
                        WHEN "101" => excREnc_uid133_fpDivTest_q <= "00";
                        WHEN "110" => excREnc_uid133_fpDivTest_q <= "00";
                        WHEN "111" => excREnc_uid133_fpDivTest_q <= "00";
                        WHEN OTHERS => -- unreachable
                                       excREnc_uid133_fpDivTest_q <= (others => '-');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist2_excREnc_uid133_fpDivTest_q_8(DELAY,197)
    redist2_excREnc_uid133_fpDivTest_q_8 : dspba_delay
    GENERIC MAP ( width => 2, depth => 7, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => excREnc_uid133_fpDivTest_q, xout => redist2_excREnc_uid133_fpDivTest_q_8_q, ena => en(0), clk => clk, aclr => areset );

    -- expRPostExc_uid141_fpDivTest(MUX,140)@30
    expRPostExc_uid141_fpDivTest_s <= redist2_excREnc_uid133_fpDivTest_q_8_q;
    expRPostExc_uid141_fpDivTest_combproc: PROCESS (expRPostExc_uid141_fpDivTest_s, en, cstAllZWE_uid20_fpDivTest_q, expRPreExc_uid112_fpDivTest_q, cstAllOWE_uid18_fpDivTest_q)
    BEGIN
        CASE (expRPostExc_uid141_fpDivTest_s) IS
            WHEN "00" => expRPostExc_uid141_fpDivTest_q <= cstAllZWE_uid20_fpDivTest_q;
            WHEN "01" => expRPostExc_uid141_fpDivTest_q <= expRPreExc_uid112_fpDivTest_q;
            WHEN "10" => expRPostExc_uid141_fpDivTest_q <= cstAllOWE_uid18_fpDivTest_q;
            WHEN "11" => expRPostExc_uid141_fpDivTest_q <= cstAllOWE_uid18_fpDivTest_q;
            WHEN OTHERS => expRPostExc_uid141_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid134_fpDivTest(CONSTANT,133)
    oneFracRPostExc2_uid134_fpDivTest_q <= "00000000000000000000001";

    -- fracPostRndFPostUlp_uid106_fpDivTest(BITSELECT,105)@29
    fracPostRndFPostUlp_uid106_fpDivTest_in <= fracRPreExcExt_uid105_fpDivTest_q(22 downto 0);
    fracPostRndFPostUlp_uid106_fpDivTest_b <= STD_LOGIC_VECTOR(fracPostRndFPostUlp_uid106_fpDivTest_in(22 downto 0));

    -- fracRPreExc_uid107_fpDivTest(MUX,106)@29 + 1
    fracRPreExc_uid107_fpDivTest_s <= extraUlp_uid103_fpDivTest_q;
    fracRPreExc_uid107_fpDivTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                fracRPreExc_uid107_fpDivTest_q <= (others => '0');
            ELSE
                IF (en = "1") THEN
                    CASE (fracRPreExc_uid107_fpDivTest_s) IS
                        WHEN "0" => fracRPreExc_uid107_fpDivTest_q <= redist5_fracPostRndFT_uid104_fpDivTest_b_8_outputreg0_q;
                        WHEN "1" => fracRPreExc_uid107_fpDivTest_q <= fracPostRndFPostUlp_uid106_fpDivTest_b;
                        WHEN OTHERS => fracRPreExc_uid107_fpDivTest_q <= (others => '0');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- fracRPostExc_uid137_fpDivTest(MUX,136)@30
    fracRPostExc_uid137_fpDivTest_s <= redist2_excREnc_uid133_fpDivTest_q_8_q;
    fracRPostExc_uid137_fpDivTest_combproc: PROCESS (fracRPostExc_uid137_fpDivTest_s, en, cstZeroWF_uid19_fpDivTest_q, fracRPreExc_uid107_fpDivTest_q, oneFracRPostExc2_uid134_fpDivTest_q)
    BEGIN
        CASE (fracRPostExc_uid137_fpDivTest_s) IS
            WHEN "00" => fracRPostExc_uid137_fpDivTest_q <= cstZeroWF_uid19_fpDivTest_q;
            WHEN "01" => fracRPostExc_uid137_fpDivTest_q <= fracRPreExc_uid107_fpDivTest_q;
            WHEN "10" => fracRPostExc_uid137_fpDivTest_q <= cstZeroWF_uid19_fpDivTest_q;
            WHEN "11" => fracRPostExc_uid137_fpDivTest_q <= oneFracRPostExc2_uid134_fpDivTest_q;
            WHEN OTHERS => fracRPostExc_uid137_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- divR_uid144_fpDivTest(BITJOIN,143)@30
    divR_uid144_fpDivTest_q <= redist1_sRPostExc_uid143_fpDivTest_q_8_q & expRPostExc_uid141_fpDivTest_q & fracRPostExc_uid137_fpDivTest_q;

    -- xOut(GPOUT,4)@30
    q <= divR_uid144_fpDivTest_q;

END normal;
