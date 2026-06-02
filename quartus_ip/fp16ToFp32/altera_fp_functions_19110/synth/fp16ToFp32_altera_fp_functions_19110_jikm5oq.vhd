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

-- VHDL created from fp16ToFp32_altera_fp_functions_19110_jikm5oq
-- VHDL created on Mon Jun  1 12:09:13 2026


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

entity fp16ToFp32_altera_fp_functions_19110_jikm5oq is
    port (
        a : in std_logic_vector(15 downto 0);  -- float16_m10
        en : in std_logic_vector(0 downto 0);  -- ufix1
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fp16ToFp32_altera_fp_functions_19110_jikm5oq;

architecture normal of fp16ToFp32_altera_fp_functions_19110_jikm5oq is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid7_fpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cstZeroWF_uid8_fpToFPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal cstAllZWE_uid9_fpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal exp_x_uid10_fpToFPTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal frac_x_uid11_fpToFPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal excZ_x_uid12_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid13_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid14_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid15_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid16_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid17_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid18_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid19_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid20_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal zP_uid23_fpToFPTest_q : STD_LOGIC_VECTOR (12 downto 0);
    signal fracR_uid24_fpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expR_uid26_fpToFPTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expR_uid26_fpToFPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expUdf_uid27_fpToFPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expUdf_uid27_fpToFPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expUdf_uid27_fpToFPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expUdf_uid27_fpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expWEOutAllO_uid28_fpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expOvf_uid29_fpToFPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expOvf_uid29_fpToFPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expOvf_uid29_fpToFPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expOvf_uid29_fpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal inRegAndUdf_uid30_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid31_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal inRegAndOvf_uid32_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid33_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid34_fpToFPTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid35_fpToFPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oneFracRPostExc2_uid36_fpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal zeroFracRPostExc_uid37_fpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid39_fpToFPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid39_fpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal zeroExpRPostExc_uid42_fpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPostExc_uid43_fpToFPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid43_fpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal signX_uid44_fpToFPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fpRes_uid45_fpToFPTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal expRExt_uid25_fpToFPTest_MSBs_sums_a : STD_LOGIC_VECTOR (6 downto 0);
    signal expRExt_uid25_fpToFPTest_MSBs_sums_b : STD_LOGIC_VECTOR (6 downto 0);
    signal expRExt_uid25_fpToFPTest_MSBs_sums_o : STD_LOGIC_VECTOR (6 downto 0);
    signal expRExt_uid25_fpToFPTest_MSBs_sums_q : STD_LOGIC_VECTOR (5 downto 0);
    signal expRExt_uid25_fpToFPTest_split_join_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_c : STD_LOGIC_VECTOR (3 downto 0);

begin


    -- signX_uid44_fpToFPTest(BITSELECT,43)@0
    signX_uid44_fpToFPTest_b <= a(15 downto 15);

    -- expWEOutAllO_uid28_fpToFPTest(CONSTANT,27)
    expWEOutAllO_uid28_fpToFPTest_q <= "11111111";

    -- expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const(CONSTANT,51)
    expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q <= "00111";

    -- expRExt_uid25_fpToFPTest_MSBs_sums(ADD,49)@0
    expRExt_uid25_fpToFPTest_MSBs_sums_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((6 downto 5 => expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q(4)) & expRExt_uid25_fpToFPTest_lhsMSBs_select_b_const_q));
    expRExt_uid25_fpToFPTest_MSBs_sums_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_b));
    expRExt_uid25_fpToFPTest_MSBs_sums_o <= STD_LOGIC_VECTOR(SIGNED(expRExt_uid25_fpToFPTest_MSBs_sums_a) + SIGNED(expRExt_uid25_fpToFPTest_MSBs_sums_b));
    expRExt_uid25_fpToFPTest_MSBs_sums_q <= STD_LOGIC_VECTOR(expRExt_uid25_fpToFPTest_MSBs_sums_o(5 downto 0));

    -- exp_x_uid10_fpToFPTest(BITSELECT,9)@0
    exp_x_uid10_fpToFPTest_b <= STD_LOGIC_VECTOR(a(14 downto 10));

    -- expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged(BITSELECT,52)@0
    expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_b <= STD_LOGIC_VECTOR(exp_x_uid10_fpToFPTest_b(4 downto 4));
    expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_c <= STD_LOGIC_VECTOR(exp_x_uid10_fpToFPTest_b(3 downto 0));

    -- expRExt_uid25_fpToFPTest_split_join(BITJOIN,50)@0
    expRExt_uid25_fpToFPTest_split_join_q <= expRExt_uid25_fpToFPTest_MSBs_sums_q & expRExt_uid25_fpToFPTest_rhsMSBs_select_bit_select_merged_c;

    -- expR_uid26_fpToFPTest(BITSELECT,25)@0
    expR_uid26_fpToFPTest_in <= expRExt_uid25_fpToFPTest_split_join_q(7 downto 0);
    expR_uid26_fpToFPTest_b <= STD_LOGIC_VECTOR(expR_uid26_fpToFPTest_in(7 downto 0));

    -- zeroExpRPostExc_uid42_fpToFPTest(CONSTANT,41)
    zeroExpRPostExc_uid42_fpToFPTest_q <= "00000000";

    -- frac_x_uid11_fpToFPTest(BITSELECT,10)@0
    frac_x_uid11_fpToFPTest_b <= STD_LOGIC_VECTOR(a(9 downto 0));

    -- cstZeroWF_uid8_fpToFPTest(CONSTANT,7)
    cstZeroWF_uid8_fpToFPTest_q <= "0000000000";

    -- fracXIsZero_uid14_fpToFPTest(LOGICAL,13)@0
    fracXIsZero_uid14_fpToFPTest_q <= "1" WHEN cstZeroWF_uid8_fpToFPTest_q = frac_x_uid11_fpToFPTest_b ELSE "0";

    -- fracXIsNotZero_uid15_fpToFPTest(LOGICAL,14)@0
    fracXIsNotZero_uid15_fpToFPTest_q <= STD_LOGIC_VECTOR(not (fracXIsZero_uid14_fpToFPTest_q));

    -- cstAllOWE_uid7_fpToFPTest(CONSTANT,6)
    cstAllOWE_uid7_fpToFPTest_q <= "11111";

    -- expXIsMax_uid13_fpToFPTest(LOGICAL,12)@0
    expXIsMax_uid13_fpToFPTest_q <= "1" WHEN exp_x_uid10_fpToFPTest_b = cstAllOWE_uid7_fpToFPTest_q ELSE "0";

    -- excN_x_uid17_fpToFPTest(LOGICAL,16)@0
    excN_x_uid17_fpToFPTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid13_fpToFPTest_q and fracXIsNotZero_uid15_fpToFPTest_q);

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- expOvf_uid29_fpToFPTest(COMPARE,28)@0
    expOvf_uid29_fpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expRExt_uid25_fpToFPTest_split_join_q(9)) & expRExt_uid25_fpToFPTest_split_join_q));
    expOvf_uid29_fpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000" & expWEOutAllO_uid28_fpToFPTest_q));
    expOvf_uid29_fpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid29_fpToFPTest_a) - SIGNED(expOvf_uid29_fpToFPTest_b));
    expOvf_uid29_fpToFPTest_n(0) <= not (expOvf_uid29_fpToFPTest_o(11));

    -- invExpXIsMax_uid18_fpToFPTest(LOGICAL,17)@0
    invExpXIsMax_uid18_fpToFPTest_q <= STD_LOGIC_VECTOR(not (expXIsMax_uid13_fpToFPTest_q));

    -- cstAllZWE_uid9_fpToFPTest(CONSTANT,8)
    cstAllZWE_uid9_fpToFPTest_q <= "00000";

    -- excZ_x_uid12_fpToFPTest(LOGICAL,11)@0
    excZ_x_uid12_fpToFPTest_q <= "1" WHEN exp_x_uid10_fpToFPTest_b = cstAllZWE_uid9_fpToFPTest_q ELSE "0";

    -- InvExpXIsZero_uid19_fpToFPTest(LOGICAL,18)@0
    InvExpXIsZero_uid19_fpToFPTest_q <= STD_LOGIC_VECTOR(not (excZ_x_uid12_fpToFPTest_q));

    -- excR_x_uid20_fpToFPTest(LOGICAL,19)@0
    excR_x_uid20_fpToFPTest_q <= STD_LOGIC_VECTOR(InvExpXIsZero_uid19_fpToFPTest_q and invExpXIsMax_uid18_fpToFPTest_q);

    -- inRegAndOvf_uid32_fpToFPTest(LOGICAL,31)@0
    inRegAndOvf_uid32_fpToFPTest_q <= STD_LOGIC_VECTOR(excR_x_uid20_fpToFPTest_q and expOvf_uid29_fpToFPTest_n);

    -- excI_x_uid16_fpToFPTest(LOGICAL,15)@0
    excI_x_uid16_fpToFPTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid13_fpToFPTest_q and fracXIsZero_uid14_fpToFPTest_q);

    -- excRInf_uid33_fpToFPTest(LOGICAL,32)@0
    excRInf_uid33_fpToFPTest_q <= STD_LOGIC_VECTOR(excI_x_uid16_fpToFPTest_q or inRegAndOvf_uid32_fpToFPTest_q);

    -- expUdf_uid27_fpToFPTest(COMPARE,26)@0
    expUdf_uid27_fpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & GND_q));
    expUdf_uid27_fpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expRExt_uid25_fpToFPTest_split_join_q(9)) & expRExt_uid25_fpToFPTest_split_join_q));
    expUdf_uid27_fpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expUdf_uid27_fpToFPTest_a) - SIGNED(expUdf_uid27_fpToFPTest_b));
    expUdf_uid27_fpToFPTest_n(0) <= not (expUdf_uid27_fpToFPTest_o(11));

    -- inRegAndUdf_uid30_fpToFPTest(LOGICAL,29)@0
    inRegAndUdf_uid30_fpToFPTest_q <= STD_LOGIC_VECTOR(excR_x_uid20_fpToFPTest_q and expUdf_uid27_fpToFPTest_n);

    -- excRZero_uid31_fpToFPTest(LOGICAL,30)@0
    excRZero_uid31_fpToFPTest_q <= STD_LOGIC_VECTOR(excZ_x_uid12_fpToFPTest_q or inRegAndUdf_uid30_fpToFPTest_q);

    -- concExc_uid34_fpToFPTest(BITJOIN,33)@0
    concExc_uid34_fpToFPTest_q <= excN_x_uid17_fpToFPTest_q & excRInf_uid33_fpToFPTest_q & excRZero_uid31_fpToFPTest_q;

    -- excREnc_uid35_fpToFPTest(LOOKUP,34)@0
    excREnc_uid35_fpToFPTest_combproc: PROCESS (concExc_uid34_fpToFPTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid34_fpToFPTest_q) IS
            WHEN "000" => excREnc_uid35_fpToFPTest_q <= "01";
            WHEN "001" => excREnc_uid35_fpToFPTest_q <= "00";
            WHEN "010" => excREnc_uid35_fpToFPTest_q <= "10";
            WHEN "011" => excREnc_uid35_fpToFPTest_q <= "00";
            WHEN "100" => excREnc_uid35_fpToFPTest_q <= "11";
            WHEN "101" => excREnc_uid35_fpToFPTest_q <= "00";
            WHEN "110" => excREnc_uid35_fpToFPTest_q <= "00";
            WHEN "111" => excREnc_uid35_fpToFPTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREnc_uid35_fpToFPTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid43_fpToFPTest(MUX,42)@0
    expRPostExc_uid43_fpToFPTest_s <= excREnc_uid35_fpToFPTest_q;
    expRPostExc_uid43_fpToFPTest_combproc: PROCESS (expRPostExc_uid43_fpToFPTest_s, en, zeroExpRPostExc_uid42_fpToFPTest_q, expR_uid26_fpToFPTest_b, expWEOutAllO_uid28_fpToFPTest_q)
    BEGIN
        CASE (expRPostExc_uid43_fpToFPTest_s) IS
            WHEN "00" => expRPostExc_uid43_fpToFPTest_q <= zeroExpRPostExc_uid42_fpToFPTest_q;
            WHEN "01" => expRPostExc_uid43_fpToFPTest_q <= expR_uid26_fpToFPTest_b;
            WHEN "10" => expRPostExc_uid43_fpToFPTest_q <= expWEOutAllO_uid28_fpToFPTest_q;
            WHEN "11" => expRPostExc_uid43_fpToFPTest_q <= expWEOutAllO_uid28_fpToFPTest_q;
            WHEN OTHERS => expRPostExc_uid43_fpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid36_fpToFPTest(CONSTANT,35)
    oneFracRPostExc2_uid36_fpToFPTest_q <= "00000000000000000000001";

    -- zP_uid23_fpToFPTest(CONSTANT,22)
    zP_uid23_fpToFPTest_q <= "0000000000000";

    -- fracR_uid24_fpToFPTest(BITJOIN,23)@0
    fracR_uid24_fpToFPTest_q <= frac_x_uid11_fpToFPTest_b & zP_uid23_fpToFPTest_q;

    -- zeroFracRPostExc_uid37_fpToFPTest(CONSTANT,36)
    zeroFracRPostExc_uid37_fpToFPTest_q <= "00000000000000000000000";

    -- fracRPostExc_uid39_fpToFPTest(MUX,38)@0
    fracRPostExc_uid39_fpToFPTest_s <= excREnc_uid35_fpToFPTest_q;
    fracRPostExc_uid39_fpToFPTest_combproc: PROCESS (fracRPostExc_uid39_fpToFPTest_s, en, zeroFracRPostExc_uid37_fpToFPTest_q, fracR_uid24_fpToFPTest_q, oneFracRPostExc2_uid36_fpToFPTest_q)
    BEGIN
        CASE (fracRPostExc_uid39_fpToFPTest_s) IS
            WHEN "00" => fracRPostExc_uid39_fpToFPTest_q <= zeroFracRPostExc_uid37_fpToFPTest_q;
            WHEN "01" => fracRPostExc_uid39_fpToFPTest_q <= fracR_uid24_fpToFPTest_q;
            WHEN "10" => fracRPostExc_uid39_fpToFPTest_q <= zeroFracRPostExc_uid37_fpToFPTest_q;
            WHEN "11" => fracRPostExc_uid39_fpToFPTest_q <= oneFracRPostExc2_uid36_fpToFPTest_q;
            WHEN OTHERS => fracRPostExc_uid39_fpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fpRes_uid45_fpToFPTest(BITJOIN,44)@0
    fpRes_uid45_fpToFPTest_q <= signX_uid44_fpToFPTest_b & expRPostExc_uid43_fpToFPTest_q & fracRPostExc_uid39_fpToFPTest_q;

    -- xOut(GPOUT,4)@0
    q <= fpRes_uid45_fpToFPTest_q;

END normal;
