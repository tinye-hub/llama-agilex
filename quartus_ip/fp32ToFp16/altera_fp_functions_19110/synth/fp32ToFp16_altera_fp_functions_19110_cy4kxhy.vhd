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

-- VHDL created from fp32ToFp16_altera_fp_functions_19110_cy4kxhy
-- VHDL created on Mon Jun  1 12:06:59 2026


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

entity fp32ToFp16_altera_fp_functions_19110_cy4kxhy is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(15 downto 0);  -- float16_m10
        clk : in std_logic;
        areset : in std_logic
    );
end fp32ToFp16_altera_fp_functions_19110_cy4kxhy;

architecture normal of fp32ToFp16_altera_fp_functions_19110_cy4kxhy is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid7_fpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid8_fpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid9_fpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal exp_x_uid10_fpToFPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid11_fpToFPTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid12_fpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_x_uid12_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid13_fpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid13_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid14_fpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid14_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid15_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid16_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid17_fpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid17_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid18_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid19_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid20_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXWOP1_uid23_fpToFPTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expXFracX_uid24_fpToFPTest_q : STD_LOGIC_VECTOR (18 downto 0);
    signal expFracR_uid29_fpToFPTest_a : STD_LOGIC_VECTOR (21 downto 0);
    signal expFracR_uid29_fpToFPTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal expFracR_uid29_fpToFPTest_o : STD_LOGIC_VECTOR (21 downto 0);
    signal expFracR_uid29_fpToFPTest_q : STD_LOGIC_VECTOR (20 downto 0);
    signal fracR_uid30_fpToFPTest_in : STD_LOGIC_VECTOR (10 downto 0);
    signal fracR_uid30_fpToFPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expR_uid31_fpToFPTest_in : STD_LOGIC_VECTOR (15 downto 0);
    signal expR_uid31_fpToFPTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal expRExt_uid32_fpToFPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expUdf_uid33_fpToFPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expUdf_uid33_fpToFPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expUdf_uid33_fpToFPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expUdf_uid33_fpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expWEOutAllO_uid34_fpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expOvf_uid35_fpToFPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expOvf_uid35_fpToFPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expOvf_uid35_fpToFPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expOvf_uid35_fpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal inRegAndUdf_uid36_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid37_fpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid37_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal inRegAndOvf_uid38_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid39_fpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid39_fpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid40_fpToFPTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid41_fpToFPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oneFracRPostExc2_uid42_fpToFPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal zeroFracRPostExc_uid43_fpToFPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal fracRPostExc_uid45_fpToFPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid45_fpToFPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal zeroExpRPostExc_uid48_fpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expRPostExc_uid49_fpToFPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid49_fpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal signX_uid50_fpToFPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fpRes_uid51_fpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rndExpUpdate_uid28_fpToFPTest_q_const_q : STD_LOGIC_VECTOR (19 downto 0);
    signal redist0_signX_uid50_fpToFPTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_signX_uid50_fpToFPTest_b_2_delay_0 : STD_LOGIC_VECTOR (0 downto 0);
    signal redist1_expR_uid31_fpToFPTest_b_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist2_fracR_uid30_fpToFPTest_b_1_q : STD_LOGIC_VECTOR (9 downto 0);

begin


    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signX_uid50_fpToFPTest(BITSELECT,49)@0
    signX_uid50_fpToFPTest_b <= a(31 downto 31);

    -- redist0_signX_uid50_fpToFPTest_b_2(DELAY,54)
    redist0_signX_uid50_fpToFPTest_b_2_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                redist0_signX_uid50_fpToFPTest_b_2_delay_0 <= STD_LOGIC_VECTOR(signX_uid50_fpToFPTest_b);
                redist0_signX_uid50_fpToFPTest_b_2_q <= STD_LOGIC_VECTOR(redist0_signX_uid50_fpToFPTest_b_2_delay_0);
            END IF;
        END IF;
    END PROCESS;

    -- expWEOutAllO_uid34_fpToFPTest(CONSTANT,33)
    expWEOutAllO_uid34_fpToFPTest_q <= "11111";

    -- rndExpUpdate_uid28_fpToFPTest_q_const(CONSTANT,53)
    rndExpUpdate_uid28_fpToFPTest_q_const_q <= "11001000000000000001";

    -- exp_x_uid10_fpToFPTest(BITSELECT,9)@0
    exp_x_uid10_fpToFPTest_b <= STD_LOGIC_VECTOR(a(30 downto 23));

    -- frac_x_uid11_fpToFPTest(BITSELECT,10)@0
    frac_x_uid11_fpToFPTest_b <= STD_LOGIC_VECTOR(a(22 downto 0));

    -- fracXWOP1_uid23_fpToFPTest(BITSELECT,22)@0
    fracXWOP1_uid23_fpToFPTest_b <= STD_LOGIC_VECTOR(frac_x_uid11_fpToFPTest_b(22 downto 12));

    -- expXFracX_uid24_fpToFPTest(BITJOIN,23)@0
    expXFracX_uid24_fpToFPTest_q <= exp_x_uid10_fpToFPTest_b & fracXWOP1_uid23_fpToFPTest_b;

    -- expFracR_uid29_fpToFPTest(ADD,28)@0 + 1
    expFracR_uid29_fpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expXFracX_uid24_fpToFPTest_q));
    expFracR_uid29_fpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 20 => rndExpUpdate_uid28_fpToFPTest_q_const_q(19)) & rndExpUpdate_uid28_fpToFPTest_q_const_q));
    expFracR_uid29_fpToFPTest_clkproc: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                expFracR_uid29_fpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracR_uid29_fpToFPTest_a) + SIGNED(expFracR_uid29_fpToFPTest_b));
            END IF;
        END IF;
    END PROCESS;
    expFracR_uid29_fpToFPTest_q <= STD_LOGIC_VECTOR(expFracR_uid29_fpToFPTest_o(20 downto 0));

    -- expR_uid31_fpToFPTest(BITSELECT,30)@1
    expR_uid31_fpToFPTest_in <= expFracR_uid29_fpToFPTest_q(15 downto 0);
    expR_uid31_fpToFPTest_b <= STD_LOGIC_VECTOR(expR_uid31_fpToFPTest_in(15 downto 11));

    -- redist1_expR_uid31_fpToFPTest_b_1(DELAY,55)
    redist1_expR_uid31_fpToFPTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                redist1_expR_uid31_fpToFPTest_b_1_q <= expR_uid31_fpToFPTest_b;
            END IF;
        END IF;
    END PROCESS;

    -- zeroExpRPostExc_uid48_fpToFPTest(CONSTANT,47)
    zeroExpRPostExc_uid48_fpToFPTest_q <= "00000";

    -- cstZeroWF_uid8_fpToFPTest(CONSTANT,7)
    cstZeroWF_uid8_fpToFPTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid14_fpToFPTest(LOGICAL,13)@0 + 1
    fracXIsZero_uid14_fpToFPTest_qi <= "1" WHEN cstZeroWF_uid8_fpToFPTest_q = frac_x_uid11_fpToFPTest_b ELSE "0";
    fracXIsZero_uid14_fpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => fracXIsZero_uid14_fpToFPTest_qi, xout => fracXIsZero_uid14_fpToFPTest_q, clk => clk, aclr => areset, ena => '1' );

    -- fracXIsNotZero_uid15_fpToFPTest(LOGICAL,14)@1
    fracXIsNotZero_uid15_fpToFPTest_q <= STD_LOGIC_VECTOR(not (fracXIsZero_uid14_fpToFPTest_q));

    -- cstAllOWE_uid7_fpToFPTest(CONSTANT,6)
    cstAllOWE_uid7_fpToFPTest_q <= "11111111";

    -- expXIsMax_uid13_fpToFPTest(LOGICAL,12)@0 + 1
    expXIsMax_uid13_fpToFPTest_qi <= "1" WHEN exp_x_uid10_fpToFPTest_b = cstAllOWE_uid7_fpToFPTest_q ELSE "0";
    expXIsMax_uid13_fpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => expXIsMax_uid13_fpToFPTest_qi, xout => expXIsMax_uid13_fpToFPTest_q, clk => clk, aclr => areset, ena => '1' );

    -- excN_x_uid17_fpToFPTest(LOGICAL,16)@1 + 1
    excN_x_uid17_fpToFPTest_qi <= expXIsMax_uid13_fpToFPTest_q and fracXIsNotZero_uid15_fpToFPTest_q;
    excN_x_uid17_fpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => excN_x_uid17_fpToFPTest_qi, xout => excN_x_uid17_fpToFPTest_q, clk => clk, aclr => areset, ena => '1' );

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- expRExt_uid32_fpToFPTest(BITSELECT,31)@1
    expRExt_uid32_fpToFPTest_b <= expFracR_uid29_fpToFPTest_q(20 downto 11);

    -- expOvf_uid35_fpToFPTest(COMPARE,34)@1
    expOvf_uid35_fpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expRExt_uid32_fpToFPTest_b(9)) & expRExt_uid32_fpToFPTest_b));
    expOvf_uid35_fpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000000" & expWEOutAllO_uid34_fpToFPTest_q));
    expOvf_uid35_fpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid35_fpToFPTest_a) - SIGNED(expOvf_uid35_fpToFPTest_b));
    expOvf_uid35_fpToFPTest_n(0) <= not (expOvf_uid35_fpToFPTest_o(11));

    -- invExpXIsMax_uid18_fpToFPTest(LOGICAL,17)@1
    invExpXIsMax_uid18_fpToFPTest_q <= STD_LOGIC_VECTOR(not (expXIsMax_uid13_fpToFPTest_q));

    -- cstAllZWE_uid9_fpToFPTest(CONSTANT,8)
    cstAllZWE_uid9_fpToFPTest_q <= "00000000";

    -- excZ_x_uid12_fpToFPTest(LOGICAL,11)@0 + 1
    excZ_x_uid12_fpToFPTest_qi <= "1" WHEN exp_x_uid10_fpToFPTest_b = cstAllZWE_uid9_fpToFPTest_q ELSE "0";
    excZ_x_uid12_fpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => excZ_x_uid12_fpToFPTest_qi, xout => excZ_x_uid12_fpToFPTest_q, clk => clk, aclr => areset, ena => '1' );

    -- InvExpXIsZero_uid19_fpToFPTest(LOGICAL,18)@1
    InvExpXIsZero_uid19_fpToFPTest_q <= STD_LOGIC_VECTOR(not (excZ_x_uid12_fpToFPTest_q));

    -- excR_x_uid20_fpToFPTest(LOGICAL,19)@1
    excR_x_uid20_fpToFPTest_q <= STD_LOGIC_VECTOR(InvExpXIsZero_uid19_fpToFPTest_q and invExpXIsMax_uid18_fpToFPTest_q);

    -- inRegAndOvf_uid38_fpToFPTest(LOGICAL,37)@1
    inRegAndOvf_uid38_fpToFPTest_q <= STD_LOGIC_VECTOR(excR_x_uid20_fpToFPTest_q and expOvf_uid35_fpToFPTest_n);

    -- excI_x_uid16_fpToFPTest(LOGICAL,15)@1
    excI_x_uid16_fpToFPTest_q <= STD_LOGIC_VECTOR(expXIsMax_uid13_fpToFPTest_q and fracXIsZero_uid14_fpToFPTest_q);

    -- excRInf_uid39_fpToFPTest(LOGICAL,38)@1 + 1
    excRInf_uid39_fpToFPTest_qi <= excI_x_uid16_fpToFPTest_q or inRegAndOvf_uid38_fpToFPTest_q;
    excRInf_uid39_fpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => excRInf_uid39_fpToFPTest_qi, xout => excRInf_uid39_fpToFPTest_q, clk => clk, aclr => areset, ena => '1' );

    -- expUdf_uid33_fpToFPTest(COMPARE,32)@1
    expUdf_uid33_fpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & GND_q));
    expUdf_uid33_fpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expRExt_uid32_fpToFPTest_b(9)) & expRExt_uid32_fpToFPTest_b));
    expUdf_uid33_fpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expUdf_uid33_fpToFPTest_a) - SIGNED(expUdf_uid33_fpToFPTest_b));
    expUdf_uid33_fpToFPTest_n(0) <= not (expUdf_uid33_fpToFPTest_o(11));

    -- inRegAndUdf_uid36_fpToFPTest(LOGICAL,35)@1
    inRegAndUdf_uid36_fpToFPTest_q <= STD_LOGIC_VECTOR(excR_x_uid20_fpToFPTest_q and expUdf_uid33_fpToFPTest_n);

    -- excRZero_uid37_fpToFPTest(LOGICAL,36)@1 + 1
    excRZero_uid37_fpToFPTest_qi <= excZ_x_uid12_fpToFPTest_q or inRegAndUdf_uid36_fpToFPTest_q;
    excRZero_uid37_fpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "NONE", phase => 0, modulus => 1 )
    PORT MAP ( xin => excRZero_uid37_fpToFPTest_qi, xout => excRZero_uid37_fpToFPTest_q, clk => clk, aclr => areset, ena => '1' );

    -- concExc_uid40_fpToFPTest(BITJOIN,39)@2
    concExc_uid40_fpToFPTest_q <= excN_x_uid17_fpToFPTest_q & excRInf_uid39_fpToFPTest_q & excRZero_uid37_fpToFPTest_q;

    -- excREnc_uid41_fpToFPTest(LOOKUP,40)@2
    excREnc_uid41_fpToFPTest_combproc: PROCESS (concExc_uid40_fpToFPTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid40_fpToFPTest_q) IS
            WHEN "000" => excREnc_uid41_fpToFPTest_q <= "01";
            WHEN "001" => excREnc_uid41_fpToFPTest_q <= "00";
            WHEN "010" => excREnc_uid41_fpToFPTest_q <= "10";
            WHEN "011" => excREnc_uid41_fpToFPTest_q <= "00";
            WHEN "100" => excREnc_uid41_fpToFPTest_q <= "11";
            WHEN "101" => excREnc_uid41_fpToFPTest_q <= "00";
            WHEN "110" => excREnc_uid41_fpToFPTest_q <= "00";
            WHEN "111" => excREnc_uid41_fpToFPTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREnc_uid41_fpToFPTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid49_fpToFPTest(MUX,48)@2
    expRPostExc_uid49_fpToFPTest_s <= excREnc_uid41_fpToFPTest_q;
    expRPostExc_uid49_fpToFPTest_combproc: PROCESS (expRPostExc_uid49_fpToFPTest_s, zeroExpRPostExc_uid48_fpToFPTest_q, redist1_expR_uid31_fpToFPTest_b_1_q, expWEOutAllO_uid34_fpToFPTest_q)
    BEGIN
        CASE (expRPostExc_uid49_fpToFPTest_s) IS
            WHEN "00" => expRPostExc_uid49_fpToFPTest_q <= zeroExpRPostExc_uid48_fpToFPTest_q;
            WHEN "01" => expRPostExc_uid49_fpToFPTest_q <= redist1_expR_uid31_fpToFPTest_b_1_q;
            WHEN "10" => expRPostExc_uid49_fpToFPTest_q <= expWEOutAllO_uid34_fpToFPTest_q;
            WHEN "11" => expRPostExc_uid49_fpToFPTest_q <= expWEOutAllO_uid34_fpToFPTest_q;
            WHEN OTHERS => expRPostExc_uid49_fpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid42_fpToFPTest(CONSTANT,41)
    oneFracRPostExc2_uid42_fpToFPTest_q <= "0000000001";

    -- fracR_uid30_fpToFPTest(BITSELECT,29)@1
    fracR_uid30_fpToFPTest_in <= expFracR_uid29_fpToFPTest_q(10 downto 0);
    fracR_uid30_fpToFPTest_b <= STD_LOGIC_VECTOR(fracR_uid30_fpToFPTest_in(10 downto 1));

    -- redist2_fracR_uid30_fpToFPTest_b_1(DELAY,56)
    redist2_fracR_uid30_fpToFPTest_b_1_clkproc_0: PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (false) THEN
            ELSE
                redist2_fracR_uid30_fpToFPTest_b_1_q <= fracR_uid30_fpToFPTest_b;
            END IF;
        END IF;
    END PROCESS;

    -- zeroFracRPostExc_uid43_fpToFPTest(CONSTANT,42)
    zeroFracRPostExc_uid43_fpToFPTest_q <= "0000000000";

    -- fracRPostExc_uid45_fpToFPTest(MUX,44)@2
    fracRPostExc_uid45_fpToFPTest_s <= excREnc_uid41_fpToFPTest_q;
    fracRPostExc_uid45_fpToFPTest_combproc: PROCESS (fracRPostExc_uid45_fpToFPTest_s, zeroFracRPostExc_uid43_fpToFPTest_q, redist2_fracR_uid30_fpToFPTest_b_1_q, oneFracRPostExc2_uid42_fpToFPTest_q)
    BEGIN
        CASE (fracRPostExc_uid45_fpToFPTest_s) IS
            WHEN "00" => fracRPostExc_uid45_fpToFPTest_q <= zeroFracRPostExc_uid43_fpToFPTest_q;
            WHEN "01" => fracRPostExc_uid45_fpToFPTest_q <= redist2_fracR_uid30_fpToFPTest_b_1_q;
            WHEN "10" => fracRPostExc_uid45_fpToFPTest_q <= zeroFracRPostExc_uid43_fpToFPTest_q;
            WHEN "11" => fracRPostExc_uid45_fpToFPTest_q <= oneFracRPostExc2_uid42_fpToFPTest_q;
            WHEN OTHERS => fracRPostExc_uid45_fpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fpRes_uid51_fpToFPTest(BITJOIN,50)@2
    fpRes_uid51_fpToFPTest_q <= redist0_signX_uid50_fpToFPTest_b_2_q & expRPostExc_uid49_fpToFPTest_q & fracRPostExc_uid45_fpToFPTest_q;

    -- xOut(GPOUT,4)@2
    q <= fpRes_uid51_fpToFPTest_q;

END normal;
