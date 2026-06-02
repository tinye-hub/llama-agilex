	component fp32MultAcc is
		port (
			accumulate  : in  std_logic                     := 'X';             -- accumulate
			fp32_mult_a : in  std_logic_vector(31 downto 0) := (others => 'X'); -- fp32_mult_a
			fp32_mult_b : in  std_logic_vector(31 downto 0) := (others => 'X'); -- fp32_mult_b
			clk         : in  std_logic                     := 'X';             -- clk
			ena         : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- ena
			fp32_result : out std_logic_vector(31 downto 0)                     -- fp32_result
		);
	end component fp32MultAcc;

	u0 : component fp32MultAcc
		port map (
			accumulate  => CONNECTED_TO_accumulate,  --  accumulate.accumulate
			fp32_mult_a => CONNECTED_TO_fp32_mult_a, -- fp32_mult_a.fp32_mult_a
			fp32_mult_b => CONNECTED_TO_fp32_mult_b, -- fp32_mult_b.fp32_mult_b
			clk         => CONNECTED_TO_clk,         --         clk.clk
			ena         => CONNECTED_TO_ena,         --         ena.ena
			fp32_result => CONNECTED_TO_fp32_result  -- fp32_result.fp32_result
		);

