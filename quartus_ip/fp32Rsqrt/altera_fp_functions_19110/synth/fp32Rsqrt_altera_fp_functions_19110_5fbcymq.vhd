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

-- VHDL created from fp32Rsqrt_altera_fp_functions_19110_5fbcymq
-- VHDL created on Mon Jun  1 10:05:32 2026


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

entity fp32Rsqrt_altera_fp_functions_19110_5fbcymq is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        en : in std_logic_vector(0 downto 0);  -- ufix1
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fp32Rsqrt_altera_fp_functions_19110_5fbcymq;

architecture normal of fp32Rsqrt_altera_fp_functions_19110_5fbcymq is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid6_fpInvSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstAllZWF_uid7_fpInvSqrtTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstNaNWF_uid8_fpInvSqrtTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid9_fpInvSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cst3BiasM1o2M1_uid10_fpInvSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cst3BiasP1o2M1_uid11_fpInvSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal exp_x_uid16_fpInvSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid17_fpInvSqrtTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid18_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid19_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid20_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid21_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid22_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid23_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signX_uid28_fpInvSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal evenOddExp_uid30_fpInvSqrtTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal evenOddExp_uid30_fpInvSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal addrYFull_uid31_fpInvSqrtTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal yAddr_uid33_fpInvSqrtTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal yPPolyEval_uid34_fpInvSqrtTest_in : STD_LOGIC_VECTOR (14 downto 0);
    signal yPPolyEval_uid34_fpInvSqrtTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal fxpInvSqrtRes_uid36_fpInvSqrtTest_in : STD_LOGIC_VECTOR (29 downto 0);
    signal fxpInvSqrtRes_uid36_fpInvSqrtTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal cstSel_uid40_fpInvSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal cstSel_uid40_fpInvSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expRExt_uid41_fpInvSqrtTest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expR_uid43_fpInvSqrtTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expR_uid43_fpInvSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fxpInverseResFrac_uid44_fpInvSqrtTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fxpInverseResFrac_uid44_fpInvSqrtTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal invSignX_uid45_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid46_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXZ_uid47_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xRegNeg_uid48_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNOxRNeg_uid49_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRConc_uid50_fpInvSqrtTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal outMuxSelEnc_uid51_fpInvSqrtTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid53_fpInvSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid53_fpInvSqrtTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid54_fpInvSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid54_fpInvSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal signR_uid55_fpInvSqrtTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signR_uid55_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid56_fpInvSqrtTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yT1_uid70_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal lowRangeB_uid72_invPolyEval_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeB_uid72_invPolyEval_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highBBits_uid73_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal s1sumAHighB_uid74_invPolyEval_a : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid74_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid74_invPolyEval_o : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid74_invPolyEval_q : STD_LOGIC_VECTOR (21 downto 0);
    signal s1_uid75_invPolyEval_q : STD_LOGIC_VECTOR (22 downto 0);
    signal lowRangeB_uid78_invPolyEval_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowRangeB_uid78_invPolyEval_b : STD_LOGIC_VECTOR (1 downto 0);
    signal highBBits_uid79_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s2sumAHighB_uid80_invPolyEval_a : STD_LOGIC_VECTOR (30 downto 0);
    signal s2sumAHighB_uid80_invPolyEval_b : STD_LOGIC_VECTOR (30 downto 0);
    signal s2sumAHighB_uid80_invPolyEval_o : STD_LOGIC_VECTOR (30 downto 0);
    signal s2sumAHighB_uid80_invPolyEval_q : STD_LOGIC_VECTOR (30 downto 0);
    signal s2_uid81_invPolyEval_q : STD_LOGIC_VECTOR (32 downto 0);
    signal osig_uid84_pT1_uid71_invPolyEval_b : STD_LOGIC_VECTOR (12 downto 0);
    signal osig_uid87_pT2_uid77_invPolyEval_b : STD_LOGIC_VECTOR (23 downto 0);
    signal memoryC0_uid58_invSqrtTables_lutmem_reset0 : std_logic;
    signal memoryC0_uid58_invSqrtTables_lutmem_ena_NotRstA : std_logic;
    signal memoryC0_uid58_invSqrtTables_lutmem_ia : STD_LOGIC_VECTOR (29 downto 0);
    signal memoryC0_uid58_invSqrtTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid58_invSqrtTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid58_invSqrtTables_lutmem_ir : STD_LOGIC_VECTOR (29 downto 0);
    signal memoryC0_uid58_invSqrtTables_lutmem_r : STD_LOGIC_VECTOR (29 downto 0);
    signal memoryC1_uid61_invSqrtTables_lutmem_reset0 : std_logic;
    signal memoryC1_uid61_invSqrtTables_lutmem_ena_NotRstA : std_logic;
    signal memoryC1_uid61_invSqrtTables_lutmem_ia : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC1_uid61_invSqrtTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC1_uid61_invSqrtTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC1_uid61_invSqrtTables_lutmem_ir : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC1_uid61_invSqrtTables_lutmem_r : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC2_uid64_invSqrtTables_lutmem_reset0 : std_logic;
    signal memoryC2_uid64_invSqrtTables_lutmem_ena_NotRstA : std_logic;
    signal memoryC2_uid64_invSqrtTables_lutmem_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid64_invSqrtTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC2_uid64_invSqrtTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC2_uid64_invSqrtTables_lutmem_ir : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid64_invSqrtTables_lutmem_r : STD_LOGIC_VECTOR (11 downto 0);
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_reset : std_logic;
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_a0 : STD_LOGIC_VECTOR (11 downto 0);
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_c0 : STD_LOGIC_VECTOR (11 downto 0);
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_s0 : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_qq0 : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_q : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_ena1 : std_logic;
    signal prodXY_uid83_pT1_uid71_invPolyEval_cma_ena2 : std_logic;
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_reset : std_logic;
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_a0 : STD_LOGIC_VECTOR (14 downto 0);
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_c0 : STD_LOGIC_VECTOR (22 downto 0);
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_s0 : STD_LOGIC_VECTOR (37 downto 0);
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_qq0 : STD_LOGIC_VECTOR (37 downto 0);
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_q : STD_LOGIC_VECTOR (37 downto 0);
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_ena1 : std_logic;
    signal prodXY_uid86_pT2_uid77_invPolyEval_cma_ena2 : std_logic;
    signal redist0_s1_uid75_invPolyEval_q_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist1_signR_uid55_fpInvSqrtTest_q_14_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist5_expRExt_uid41_fpInvSqrtTest_b_1_q : STD_LOGIC_VECTOR (6 downto 0);
    signal redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q : STD_LOGIC_VECTOR (14 downto 0);
    signal redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_delay_0 : STD_LOGIC_VECTOR (14 downto 0);
    signal redist9_yAddr_uid33_fpInvSqrtTest_b_5_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_0 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_1 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_2 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_3 : STD_LOGIC_VECTOR (8 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_reset0 : std_logic;
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ena_OrRstB : std_logic;
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ia : STD_LOGIC_VECTOR (7 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_aa : STD_LOGIC_VECTOR (3 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ab : STD_LOGIC_VECTOR (3 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_iq : STD_LOGIC_VECTOR (7 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i : UNSIGNED (3 downto 0);
    attribute preserve_syn_only : boolean;
    attribute preserve_syn_only of redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i : signal is true;
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq : signal is true;
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q : STD_LOGIC_VECTOR (3 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_reset0 : std_logic;
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ena_OrRstB : std_logic;
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ia : STD_LOGIC_VECTOR (14 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_iq : STD_LOGIC_VECTOR (14 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_q : STD_LOGIC_VECTOR (14 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i : signal is true;
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq : signal is true;
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_reset0 : std_logic;
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ena_OrRstB : std_logic;
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ia : STD_LOGIC_VECTOR (8 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_iq : STD_LOGIC_VECTOR (8 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve_syn_only of redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i : signal is true;
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq : std_logic;
    attribute preserve_syn_only of redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq : signal is true;
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);

begin


    -- signX_uid28_fpInvSqrtTest(BITSELECT,27)@0
    signX_uid28_fpInvSqrtTest_b <= a(31 downto 31);

    -- cstAllZWE_uid9_fpInvSqrtTest(CONSTANT,8)
    cstAllZWE_uid9_fpInvSqrtTest_q <= "00000000";

    -- exp_x_uid16_fpInvSqrtTest(BITSELECT,15)@0
    exp_x_uid16_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(a(30 downto 23));

    -- excZ_x_uid18_fpInvSqrtTest(LOGICAL,17)@0
    excZ_x_uid18_fpInvSqrtTest_q <= "1" WHEN exp_x_uid16_fpInvSqrtTest_b = cstAllZWE_uid9_fpInvSqrtTest_q ELSE "0";

    -- signR_uid55_fpInvSqrtTest(LOGICAL,54)@0 + 1
    signR_uid55_fpInvSqrtTest_qi <= excZ_x_uid18_fpInvSqrtTest_q and signX_uid28_fpInvSqrtTest_b;
    signR_uid55_fpInvSqrtTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => signR_uid55_fpInvSqrtTest_qi, xout => signR_uid55_fpInvSqrtTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist1_signR_uid55_fpInvSqrtTest_q_14(DELAY,94)
    redist1_signR_uid55_fpInvSqrtTest_q_14 : dspba_delay
    GENERIC MAP ( width => 1, depth => 13, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => signR_uid55_fpInvSqrtTest_q, xout => redist1_signR_uid55_fpInvSqrtTest_q_14_q, ena => en(0), clk => clk, aclr => areset );

    -- cstAllOWE_uid6_fpInvSqrtTest(CONSTANT,5)
    cstAllOWE_uid6_fpInvSqrtTest_q <= "11111111";

    -- redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt(COUNTER,106)
    -- low=0, high=10, step=1, init=0
    redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i <= TO_UNSIGNED(0, 4);
                redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i = TO_UNSIGNED(9, 4)) THEN
                        redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq <= '1';
                    ELSE
                        redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq <= '0';
                    END IF;
                    IF (redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_eq = '1') THEN
                        redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i <= redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i + 6;
                    ELSE
                        redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i <= redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_i, 4));

    -- redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux(MUX,107)
    redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s <= en;
    redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_combproc: PROCESS (redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s, redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q, redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q)
    BEGIN
        CASE (redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_s) IS
            WHEN "0" => redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q <= redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q;
            WHEN "1" => redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q <= redist4_expR_uid43_fpInvSqrtTest_b_13_rdcnt_q;
            WHEN OTHERS => redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- expRExt_uid41_fpInvSqrtTest(BITSELECT,40)@0
    expRExt_uid41_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(exp_x_uid16_fpInvSqrtTest_b(7 downto 1));

    -- redist5_expRExt_uid41_fpInvSqrtTest_b_1(DELAY,98)
    redist5_expRExt_uid41_fpInvSqrtTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist5_expRExt_uid41_fpInvSqrtTest_b_1_q <= expRExt_uid41_fpInvSqrtTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- cst3BiasM1o2M1_uid10_fpInvSqrtTest(CONSTANT,9)
    cst3BiasM1o2M1_uid10_fpInvSqrtTest_q <= "10111101";

    -- cst3BiasP1o2M1_uid11_fpInvSqrtTest(CONSTANT,10)
    cst3BiasP1o2M1_uid11_fpInvSqrtTest_q <= "10111110";

    -- frac_x_uid17_fpInvSqrtTest(BITSELECT,16)@0
    frac_x_uid17_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(a(22 downto 0));

    -- cstAllZWF_uid7_fpInvSqrtTest(CONSTANT,6)
    cstAllZWF_uid7_fpInvSqrtTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid20_fpInvSqrtTest(LOGICAL,19)@0
    fracXIsZero_uid20_fpInvSqrtTest_q <= "1" WHEN cstAllZWF_uid7_fpInvSqrtTest_q = frac_x_uid17_fpInvSqrtTest_b ELSE "0";

    -- evenOddExp_uid30_fpInvSqrtTest(BITSELECT,29)@0
    evenOddExp_uid30_fpInvSqrtTest_in <= STD_LOGIC_VECTOR(exp_x_uid16_fpInvSqrtTest_b(0 downto 0));
    evenOddExp_uid30_fpInvSqrtTest_b <= evenOddExp_uid30_fpInvSqrtTest_in(0 downto 0);

    -- concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest(BITJOIN,38)@0
    concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q <= fracXIsZero_uid20_fpInvSqrtTest_q & evenOddExp_uid30_fpInvSqrtTest_b;

    -- redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1(DELAY,99)
    redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_q <= concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- cstSel_uid40_fpInvSqrtTest(MUX,39)@1
    cstSel_uid40_fpInvSqrtTest_s <= redist6_concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q_1_q;
    cstSel_uid40_fpInvSqrtTest_combproc: PROCESS (cstSel_uid40_fpInvSqrtTest_s, en, cst3BiasP1o2M1_uid11_fpInvSqrtTest_q, cst3BiasM1o2M1_uid10_fpInvSqrtTest_q)
    BEGIN
        CASE (cstSel_uid40_fpInvSqrtTest_s) IS
            WHEN "00" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            WHEN "01" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasM1o2M1_uid10_fpInvSqrtTest_q;
            WHEN "10" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            WHEN "11" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            WHEN OTHERS => cstSel_uid40_fpInvSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expRExt_uid42_fpInvSqrtTest(SUB,41)@1
    expRExt_uid42_fpInvSqrtTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & cstSel_uid40_fpInvSqrtTest_q));
    expRExt_uid42_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00" & redist5_expRExt_uid41_fpInvSqrtTest_b_1_q));
    expRExt_uid42_fpInvSqrtTest_o <= STD_LOGIC_VECTOR(SIGNED(expRExt_uid42_fpInvSqrtTest_a) - SIGNED(expRExt_uid42_fpInvSqrtTest_b));
    expRExt_uid42_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(expRExt_uid42_fpInvSqrtTest_o(8 downto 0));

    -- expR_uid43_fpInvSqrtTest(BITSELECT,42)@1
    expR_uid43_fpInvSqrtTest_in <= expRExt_uid42_fpInvSqrtTest_q(7 downto 0);
    expR_uid43_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(expR_uid43_fpInvSqrtTest_in(7 downto 0));

    -- redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0(DELAY,104)
    redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_q <= expR_uid43_fpInvSqrtTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr(REG,108)
    redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q <= "1010";
            ELSE
                redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q <= redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist4_expR_uid43_fpInvSqrtTest_b_13_mem(DUALMEM,105)
    redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ia <= STD_LOGIC_VECTOR(redist4_expR_uid43_fpInvSqrtTest_b_13_inputreg0_q);
    redist4_expR_uid43_fpInvSqrtTest_b_13_mem_aa <= redist4_expR_uid43_fpInvSqrtTest_b_13_wraddr_q;
    redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ab <= redist4_expR_uid43_fpInvSqrtTest_b_13_rdmux_q;
    redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ena_OrRstB <= areset or en(0);
    redist4_expR_uid43_fpInvSqrtTest_b_13_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 8,
        widthad_a => 4,
        numwords_a => 11,
        width_b => 8,
        widthad_b => 4,
        numwords_b => 11,
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
        clocken1 => redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist4_expR_uid43_fpInvSqrtTest_b_13_mem_aa,
        data_a => redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ia,
        wren_a => en(0),
        address_b => redist4_expR_uid43_fpInvSqrtTest_b_13_mem_ab,
        q_b => redist4_expR_uid43_fpInvSqrtTest_b_13_mem_iq
    );
    redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q <= STD_LOGIC_VECTOR(redist4_expR_uid43_fpInvSqrtTest_b_13_mem_iq(7 downto 0));

    -- invExcXZ_uid47_fpInvSqrtTest(LOGICAL,46)@0
    invExcXZ_uid47_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(not (excZ_x_uid18_fpInvSqrtTest_q));

    -- xRegNeg_uid48_fpInvSqrtTest(LOGICAL,47)@0
    xRegNeg_uid48_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(invExcXZ_uid47_fpInvSqrtTest_q and signX_uid28_fpInvSqrtTest_b);

    -- fracXIsNotZero_uid21_fpInvSqrtTest(LOGICAL,20)@0
    fracXIsNotZero_uid21_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(not (fracXIsZero_uid20_fpInvSqrtTest_q));

    -- expXIsMax_uid19_fpInvSqrtTest(LOGICAL,18)@0
    expXIsMax_uid19_fpInvSqrtTest_q <= "1" WHEN exp_x_uid16_fpInvSqrtTest_b = cstAllOWE_uid6_fpInvSqrtTest_q ELSE "0";

    -- excN_x_uid23_fpInvSqrtTest(LOGICAL,22)@0
    excN_x_uid23_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid19_fpInvSqrtTest_q and fracXIsNotZero_uid21_fpInvSqrtTest_q);

    -- xNOxRNeg_uid49_fpInvSqrtTest(LOGICAL,48)@0
    xNOxRNeg_uid49_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(excN_x_uid23_fpInvSqrtTest_q or xRegNeg_uid48_fpInvSqrtTest_q);

    -- excI_x_uid22_fpInvSqrtTest(LOGICAL,21)@0
    excI_x_uid22_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid19_fpInvSqrtTest_q and fracXIsZero_uid20_fpInvSqrtTest_q);

    -- invSignX_uid45_fpInvSqrtTest(LOGICAL,44)@0
    invSignX_uid45_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(not (signX_uid28_fpInvSqrtTest_b));

    -- excRZero_uid46_fpInvSqrtTest(LOGICAL,45)@0
    excRZero_uid46_fpInvSqrtTest_q <= STD_LOGIC_VECTOR(invSignX_uid45_fpInvSqrtTest_q and excI_x_uid22_fpInvSqrtTest_q);

    -- excRConc_uid50_fpInvSqrtTest(BITJOIN,49)@0
    excRConc_uid50_fpInvSqrtTest_q <= xNOxRNeg_uid49_fpInvSqrtTest_q & excZ_x_uid18_fpInvSqrtTest_q & excRZero_uid46_fpInvSqrtTest_q;

    -- outMuxSelEnc_uid51_fpInvSqrtTest(LOOKUP,50)@0 + 1
    outMuxSelEnc_uid51_fpInvSqrtTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                outMuxSelEnc_uid51_fpInvSqrtTest_q <= "01";
            ELSE
                IF (en = "1") THEN
                    CASE (excRConc_uid50_fpInvSqrtTest_q) IS
                        WHEN "000" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "01";
                        WHEN "001" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "00";
                        WHEN "010" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "10";
                        WHEN "011" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "00";
                        WHEN "100" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "11";
                        WHEN "101" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "00";
                        WHEN "110" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "10";
                        WHEN "111" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "01";
                        WHEN OTHERS => -- unreachable
                                       outMuxSelEnc_uid51_fpInvSqrtTest_q <= (others => '-');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14(DELAY,95)
    redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14 : dspba_delay
    GENERIC MAP ( width => 2, depth => 13, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => outMuxSelEnc_uid51_fpInvSqrtTest_q, xout => redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q, ena => en(0), clk => clk, aclr => areset );

    -- expRPostExc_uid54_fpInvSqrtTest(MUX,53)@14
    expRPostExc_uid54_fpInvSqrtTest_s <= redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q;
    expRPostExc_uid54_fpInvSqrtTest_combproc: PROCESS (expRPostExc_uid54_fpInvSqrtTest_s, en, cstAllZWE_uid9_fpInvSqrtTest_q, redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q, cstAllOWE_uid6_fpInvSqrtTest_q)
    BEGIN
        CASE (expRPostExc_uid54_fpInvSqrtTest_s) IS
            WHEN "00" => expRPostExc_uid54_fpInvSqrtTest_q <= cstAllZWE_uid9_fpInvSqrtTest_q;
            WHEN "01" => expRPostExc_uid54_fpInvSqrtTest_q <= redist4_expR_uid43_fpInvSqrtTest_b_13_mem_q;
            WHEN "10" => expRPostExc_uid54_fpInvSqrtTest_q <= cstAllOWE_uid6_fpInvSqrtTest_q;
            WHEN "11" => expRPostExc_uid54_fpInvSqrtTest_q <= cstAllOWE_uid6_fpInvSqrtTest_q;
            WHEN OTHERS => expRPostExc_uid54_fpInvSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- cstNaNWF_uid8_fpInvSqrtTest(CONSTANT,7)
    cstNaNWF_uid8_fpInvSqrtTest_q <= "00000000000000000000001";

    -- addrYFull_uid31_fpInvSqrtTest(BITJOIN,30)@0
    addrYFull_uid31_fpInvSqrtTest_q <= evenOddExp_uid30_fpInvSqrtTest_b & frac_x_uid17_fpInvSqrtTest_b;

    -- yAddr_uid33_fpInvSqrtTest(BITSELECT,32)@0
    yAddr_uid33_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(addrYFull_uid31_fpInvSqrtTest_q(23 downto 15));

    -- memoryC2_uid64_invSqrtTables_lutmem(DUALMEM,90)@0 + 2
    memoryC2_uid64_invSqrtTables_lutmem_aa <= yAddr_uid33_fpInvSqrtTest_b;
    memoryC2_uid64_invSqrtTables_lutmem_ena_NotRstA <= not (areset) and en(0);
    memoryC2_uid64_invSqrtTables_lutmem_reset0 <= areset;
    memoryC2_uid64_invSqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 12,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC2_uid64_invSqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => memoryC2_uid64_invSqrtTables_lutmem_ena_NotRstA,
        sclr => memoryC2_uid64_invSqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC2_uid64_invSqrtTables_lutmem_aa,
        q_a => memoryC2_uid64_invSqrtTables_lutmem_ir
    );
    memoryC2_uid64_invSqrtTables_lutmem_r <= STD_LOGIC_VECTOR(memoryC2_uid64_invSqrtTables_lutmem_ir(11 downto 0));

    -- yPPolyEval_uid34_fpInvSqrtTest(BITSELECT,33)@0
    yPPolyEval_uid34_fpInvSqrtTest_in <= frac_x_uid17_fpInvSqrtTest_b(14 downto 0);
    yPPolyEval_uid34_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(yPPolyEval_uid34_fpInvSqrtTest_in(14 downto 0));

    -- redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2(DELAY,100)
    redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_delay_0 <= STD_LOGIC_VECTOR(yPPolyEval_uid34_fpInvSqrtTest_b);
                    redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q <= STD_LOGIC_VECTOR(redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_delay_0);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- yT1_uid70_invPolyEval(BITSELECT,69)@2
    yT1_uid70_invPolyEval_b <= STD_LOGIC_VECTOR(redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q(14 downto 3));

    -- prodXY_uid83_pT1_uid71_invPolyEval_cma(CHAINMULTADD,91)@2 + 5
    -- in b@5
    prodXY_uid83_pT1_uid71_invPolyEval_cma_reset <= areset;
    prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0 <= en(0) or prodXY_uid83_pT1_uid71_invPolyEval_cma_reset;
    prodXY_uid83_pT1_uid71_invPolyEval_cma_ena1 <= prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0;
    prodXY_uid83_pT1_uid71_invPolyEval_cma_ena2 <= prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0;

    prodXY_uid83_pT1_uid71_invPolyEval_cma_a0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(yT1_uid70_invPolyEval_b),12));
    prodXY_uid83_pT1_uid71_invPolyEval_cma_c0 <= STD_LOGIC_VECTOR(RESIZE(SIGNED(memoryC2_uid64_invSqrtTables_lutmem_r),12));
    prodXY_uid83_pT1_uid71_invPolyEval_cma_DSP0 : tennm_mac
    GENERIC MAP (
        operation_mode => "m18x18_full",
        clear_type => "sclr",
        ay_scan_in_clken => "0",
        ay_scan_in_width => 12,
        ax_clken => "0",
        ax_width => 12,
        signed_may => "false",
        signed_max => "true",
        input_pipeline_clken => "2",
        second_pipeline_clken => "2",
        output_clken => "1",
        result_a_width => 24,
        bx_width => 0,
        by_width => 0,
        result_b_width => 0
    )
    PORT MAP (
        clk => clk,
        ena(0) => prodXY_uid83_pT1_uid71_invPolyEval_cma_ena0,
        ena(1) => prodXY_uid83_pT1_uid71_invPolyEval_cma_ena1,
        ena(2) => prodXY_uid83_pT1_uid71_invPolyEval_cma_ena2,
        clr(0) => prodXY_uid83_pT1_uid71_invPolyEval_cma_reset,
        clr(1) => prodXY_uid83_pT1_uid71_invPolyEval_cma_reset,
        ay => prodXY_uid83_pT1_uid71_invPolyEval_cma_a0,
        ax => prodXY_uid83_pT1_uid71_invPolyEval_cma_c0,
        resulta => prodXY_uid83_pT1_uid71_invPolyEval_cma_s0
    );
    prodXY_uid83_pT1_uid71_invPolyEval_cma_delay0 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => prodXY_uid83_pT1_uid71_invPolyEval_cma_s0, xout => prodXY_uid83_pT1_uid71_invPolyEval_cma_qq0, ena => en(0), clk => clk, aclr => areset );
    prodXY_uid83_pT1_uid71_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid83_pT1_uid71_invPolyEval_cma_qq0(23 downto 0));

    -- osig_uid84_pT1_uid71_invPolyEval(BITSELECT,83)@7
    osig_uid84_pT1_uid71_invPolyEval_b <= prodXY_uid83_pT1_uid71_invPolyEval_cma_q(23 downto 11);

    -- highBBits_uid73_invPolyEval(BITSELECT,72)@7
    highBBits_uid73_invPolyEval_b <= osig_uid84_pT1_uid71_invPolyEval_b(12 downto 1);

    -- redist9_yAddr_uid33_fpInvSqrtTest_b_5(DELAY,102)
    redist9_yAddr_uid33_fpInvSqrtTest_b_5_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_0 <= STD_LOGIC_VECTOR(yAddr_uid33_fpInvSqrtTest_b);
                    redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_1 <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_0;
                    redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_2 <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_1;
                    redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_3 <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_2;
                    redist9_yAddr_uid33_fpInvSqrtTest_b_5_q <= STD_LOGIC_VECTOR(redist9_yAddr_uid33_fpInvSqrtTest_b_5_delay_3);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- memoryC1_uid61_invSqrtTables_lutmem(DUALMEM,89)@5 + 2
    memoryC1_uid61_invSqrtTables_lutmem_aa <= redist9_yAddr_uid33_fpInvSqrtTest_b_5_q;
    memoryC1_uid61_invSqrtTables_lutmem_ena_NotRstA <= not (areset) and en(0);
    memoryC1_uid61_invSqrtTables_lutmem_reset0 <= areset;
    memoryC1_uid61_invSqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 21,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC1_uid61_invSqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => memoryC1_uid61_invSqrtTables_lutmem_ena_NotRstA,
        sclr => memoryC1_uid61_invSqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC1_uid61_invSqrtTables_lutmem_aa,
        q_a => memoryC1_uid61_invSqrtTables_lutmem_ir
    );
    memoryC1_uid61_invSqrtTables_lutmem_r <= STD_LOGIC_VECTOR(memoryC1_uid61_invSqrtTables_lutmem_ir(20 downto 0));

    -- s1sumAHighB_uid74_invPolyEval(ADD,73)@7
    s1sumAHighB_uid74_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 21 => memoryC1_uid61_invSqrtTables_lutmem_r(20)) & memoryC1_uid61_invSqrtTables_lutmem_r));
    s1sumAHighB_uid74_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 12 => highBBits_uid73_invPolyEval_b(11)) & highBBits_uid73_invPolyEval_b));
    s1sumAHighB_uid74_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s1sumAHighB_uid74_invPolyEval_a) + SIGNED(s1sumAHighB_uid74_invPolyEval_b));
    s1sumAHighB_uid74_invPolyEval_q <= STD_LOGIC_VECTOR(s1sumAHighB_uid74_invPolyEval_o(21 downto 0));

    -- lowRangeB_uid72_invPolyEval(BITSELECT,71)@7
    lowRangeB_uid72_invPolyEval_in <= osig_uid84_pT1_uid71_invPolyEval_b(0 downto 0);
    lowRangeB_uid72_invPolyEval_b <= STD_LOGIC_VECTOR(lowRangeB_uid72_invPolyEval_in(0 downto 0));

    -- s1_uid75_invPolyEval(BITJOIN,74)@7
    s1_uid75_invPolyEval_q <= s1sumAHighB_uid74_invPolyEval_q & lowRangeB_uid72_invPolyEval_b;

    -- redist0_s1_uid75_invPolyEval_q_1(DELAY,93)
    redist0_s1_uid75_invPolyEval_q_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist0_s1_uid75_invPolyEval_q_1_q <= s1_uid75_invPolyEval_q;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt(COUNTER,110)
    -- low=0, high=4, step=1, init=0
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                        redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq <= '1';
                    ELSE
                        redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq <= '0';
                    END IF;
                    IF (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_eq = '1') THEN
                        redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i + 4;
                    ELSE
                        redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_i, 3));

    -- redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux(MUX,111)
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s <= en;
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_combproc: PROCESS (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s, redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q, redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q)
    BEGIN
        CASE (redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_s) IS
            WHEN "0" => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q;
            WHEN "1" => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdcnt_q;
            WHEN OTHERS => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr(REG,112)
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q <= "100";
            ELSE
                redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem(DUALMEM,109)
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ia <= STD_LOGIC_VECTOR(redist7_yPPolyEval_uid34_fpInvSqrtTest_b_2_q);
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_aa <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_wraddr_q;
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ab <= redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_rdmux_q;
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ena_OrRstB <= areset or en(0);
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 15,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 15,
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
        clocken1 => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_aa,
        data_a => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ia,
        wren_a => en(0),
        address_b => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_ab,
        q_b => redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_iq
    );
    redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_q <= STD_LOGIC_VECTOR(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_iq(14 downto 0));

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- prodXY_uid86_pT2_uid77_invPolyEval_cma(CHAINMULTADD,92)@8 + 5
    -- in b@11
    prodXY_uid86_pT2_uid77_invPolyEval_cma_reset <= areset;
    prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0 <= en(0) or prodXY_uid86_pT2_uid77_invPolyEval_cma_reset;
    prodXY_uid86_pT2_uid77_invPolyEval_cma_ena1 <= prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0;
    prodXY_uid86_pT2_uid77_invPolyEval_cma_ena2 <= prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0;

    prodXY_uid86_pT2_uid77_invPolyEval_cma_a0 <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(redist8_yPPolyEval_uid34_fpInvSqrtTest_b_8_mem_q),15));
    prodXY_uid86_pT2_uid77_invPolyEval_cma_c0 <= STD_LOGIC_VECTOR(RESIZE(SIGNED(redist0_s1_uid75_invPolyEval_q_1_q),23));
    prodXY_uid86_pT2_uid77_invPolyEval_cma_DSP0 : tennm_mac
    GENERIC MAP (
        operation_mode => "m27x27",
        clear_type => "sclr",
        use_chainadder => "false",
        ay_scan_in_clken => "0",
        ay_scan_in_width => 15,
        ax_clken => "0",
        ax_width => 23,
        signed_may => "false",
        signed_max => "true",
        input_pipeline_clken => "2",
        second_pipeline_clken => "2",
        output_clken => "1",
        result_a_width => 38
    )
    PORT MAP (
        clk => clk,
        ena(0) => prodXY_uid86_pT2_uid77_invPolyEval_cma_ena0,
        ena(1) => prodXY_uid86_pT2_uid77_invPolyEval_cma_ena1,
        ena(2) => prodXY_uid86_pT2_uid77_invPolyEval_cma_ena2,
        clr(0) => prodXY_uid86_pT2_uid77_invPolyEval_cma_reset,
        clr(1) => prodXY_uid86_pT2_uid77_invPolyEval_cma_reset,
        ay => prodXY_uid86_pT2_uid77_invPolyEval_cma_a0,
        ax => prodXY_uid86_pT2_uid77_invPolyEval_cma_c0,
        resulta => prodXY_uid86_pT2_uid77_invPolyEval_cma_s0
    );
    prodXY_uid86_pT2_uid77_invPolyEval_cma_delay0 : dspba_delay
    GENERIC MAP ( width => 38, depth => 1, reset_kind => "SYNC", phase => 0, modulus => 1 )
    PORT MAP ( xin => prodXY_uid86_pT2_uid77_invPolyEval_cma_s0, xout => prodXY_uid86_pT2_uid77_invPolyEval_cma_qq0, ena => en(0), clk => clk, aclr => areset );
    prodXY_uid86_pT2_uid77_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid86_pT2_uid77_invPolyEval_cma_qq0(37 downto 0));

    -- osig_uid87_pT2_uid77_invPolyEval(BITSELECT,86)@13
    osig_uid87_pT2_uid77_invPolyEval_b <= prodXY_uid86_pT2_uid77_invPolyEval_cma_q(37 downto 14);

    -- highBBits_uid79_invPolyEval(BITSELECT,78)@13
    highBBits_uid79_invPolyEval_b <= osig_uid87_pT2_uid77_invPolyEval_b(23 downto 2);

    -- redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt(COUNTER,114)
    -- low=0, high=4, step=1, init=0
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i <= TO_UNSIGNED(0, 3);
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq <= '0';
            ELSE
                IF (en = "1") THEN
                    IF (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                        redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq <= '1';
                    ELSE
                        redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq <= '0';
                    END IF;
                    IF (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_eq = '1') THEN
                        redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i + 4;
                    ELSE
                        redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q <= STD_LOGIC_VECTOR(RESIZE(redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_i, 3));

    -- redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux(MUX,115)
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s <= en;
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_combproc: PROCESS (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s, redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q, redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q)
    BEGIN
        CASE (redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_s) IS
            WHEN "0" => redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q;
            WHEN "1" => redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdcnt_q;
            WHEN OTHERS => redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr(REG,116)
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (areset = '1') THEN
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q <= "100";
            ELSE
                redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q;
            END IF;
        END IF;
    END PROCESS;

    -- redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem(DUALMEM,113)
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ia <= STD_LOGIC_VECTOR(redist9_yAddr_uid33_fpInvSqrtTest_b_5_q);
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_aa <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_wraddr_q;
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ab <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_rdmux_q;
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ena_OrRstB <= areset or en(0);
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_dmem : altera_syncram
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
        clocken1 => redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ena_OrRstB,
        clocken0 => '1',
        clock0 => clk,
        clock1 => clk,
        address_a => redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_aa,
        data_a => redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ia,
        wren_a => en(0),
        address_b => redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_ab,
        q_b => redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_iq
    );
    redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_q <= STD_LOGIC_VECTOR(redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_iq(8 downto 0));

    -- memoryC0_uid58_invSqrtTables_lutmem(DUALMEM,88)@11 + 2
    memoryC0_uid58_invSqrtTables_lutmem_aa <= redist10_yAddr_uid33_fpInvSqrtTest_b_11_mem_q;
    memoryC0_uid58_invSqrtTables_lutmem_ena_NotRstA <= not (areset) and en(0);
    memoryC0_uid58_invSqrtTables_lutmem_reset0 <= areset;
    memoryC0_uid58_invSqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "ROM",
        width_a => 30,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_sclr_a => "SCLEAR",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC0_uid58_invSqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Agilex 5"
    )
    PORT MAP (
        clocken0 => memoryC0_uid58_invSqrtTables_lutmem_ena_NotRstA,
        sclr => memoryC0_uid58_invSqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC0_uid58_invSqrtTables_lutmem_aa,
        q_a => memoryC0_uid58_invSqrtTables_lutmem_ir
    );
    memoryC0_uid58_invSqrtTables_lutmem_r <= STD_LOGIC_VECTOR(memoryC0_uid58_invSqrtTables_lutmem_ir(29 downto 0));

    -- s2sumAHighB_uid80_invPolyEval(ADD,79)@13
    s2sumAHighB_uid80_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 30 => memoryC0_uid58_invSqrtTables_lutmem_r(29)) & memoryC0_uid58_invSqrtTables_lutmem_r));
    s2sumAHighB_uid80_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 22 => highBBits_uid79_invPolyEval_b(21)) & highBBits_uid79_invPolyEval_b));
    s2sumAHighB_uid80_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s2sumAHighB_uid80_invPolyEval_a) + SIGNED(s2sumAHighB_uid80_invPolyEval_b));
    s2sumAHighB_uid80_invPolyEval_q <= STD_LOGIC_VECTOR(s2sumAHighB_uid80_invPolyEval_o(30 downto 0));

    -- lowRangeB_uid78_invPolyEval(BITSELECT,77)@13
    lowRangeB_uid78_invPolyEval_in <= osig_uid87_pT2_uid77_invPolyEval_b(1 downto 0);
    lowRangeB_uid78_invPolyEval_b <= STD_LOGIC_VECTOR(lowRangeB_uid78_invPolyEval_in(1 downto 0));

    -- s2_uid81_invPolyEval(BITJOIN,80)@13
    s2_uid81_invPolyEval_q <= s2sumAHighB_uid80_invPolyEval_q & lowRangeB_uid78_invPolyEval_b;

    -- fxpInvSqrtRes_uid36_fpInvSqrtTest(BITSELECT,35)@13
    fxpInvSqrtRes_uid36_fpInvSqrtTest_in <= s2_uid81_invPolyEval_q(29 downto 0);
    fxpInvSqrtRes_uid36_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(fxpInvSqrtRes_uid36_fpInvSqrtTest_in(29 downto 6));

    -- fxpInverseResFrac_uid44_fpInvSqrtTest(BITSELECT,43)@13
    fxpInverseResFrac_uid44_fpInvSqrtTest_in <= fxpInvSqrtRes_uid36_fpInvSqrtTest_b(22 downto 0);
    fxpInverseResFrac_uid44_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(fxpInverseResFrac_uid44_fpInvSqrtTest_in(22 downto 0));

    -- redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1(DELAY,96)
    redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                IF (en = "1") THEN
                    redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q <= fxpInverseResFrac_uid44_fpInvSqrtTest_b;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- fracRPostExc_uid53_fpInvSqrtTest(MUX,52)@14
    fracRPostExc_uid53_fpInvSqrtTest_s <= redist2_outMuxSelEnc_uid51_fpInvSqrtTest_q_14_q;
    fracRPostExc_uid53_fpInvSqrtTest_combproc: PROCESS (fracRPostExc_uid53_fpInvSqrtTest_s, en, cstAllZWF_uid7_fpInvSqrtTest_q, redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q, cstNaNWF_uid8_fpInvSqrtTest_q)
    BEGIN
        CASE (fracRPostExc_uid53_fpInvSqrtTest_s) IS
            WHEN "00" => fracRPostExc_uid53_fpInvSqrtTest_q <= cstAllZWF_uid7_fpInvSqrtTest_q;
            WHEN "01" => fracRPostExc_uid53_fpInvSqrtTest_q <= redist3_fxpInverseResFrac_uid44_fpInvSqrtTest_b_1_q;
            WHEN "10" => fracRPostExc_uid53_fpInvSqrtTest_q <= cstAllZWF_uid7_fpInvSqrtTest_q;
            WHEN "11" => fracRPostExc_uid53_fpInvSqrtTest_q <= cstNaNWF_uid8_fpInvSqrtTest_q;
            WHEN OTHERS => fracRPostExc_uid53_fpInvSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid56_fpInvSqrtTest(BITJOIN,55)@14
    R_uid56_fpInvSqrtTest_q <= redist1_signR_uid55_fpInvSqrtTest_q_14_q & expRPostExc_uid54_fpInvSqrtTest_q & fracRPostExc_uid53_fpInvSqrtTest_q;

    -- xOut(GPOUT,4)@14
    q <= R_uid56_fpInvSqrtTest_q;

END normal;
