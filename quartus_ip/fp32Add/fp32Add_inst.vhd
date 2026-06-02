	component fp32Add is
		port (
			fp32_adder_a : in  std_logic_vector(31 downto 0) := (others => 'X'); -- fp32_adder_a
			fp32_adder_b : in  std_logic_vector(31 downto 0) := (others => 'X'); -- fp32_adder_b
			clk          : in  std_logic                     := 'X';             -- clk
			ena          : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- ena
			fp32_result  : out std_logic_vector(31 downto 0)                     -- fp32_result
		);
	end component fp32Add;

	u0 : component fp32Add
		port map (
			fp32_adder_a => CONNECTED_TO_fp32_adder_a, -- fp32_adder_a.fp32_adder_a
			fp32_adder_b => CONNECTED_TO_fp32_adder_b, -- fp32_adder_b.fp32_adder_b
			clk          => CONNECTED_TO_clk,          --          clk.clk
			ena          => CONNECTED_TO_ena,          --          ena.ena
			fp32_result  => CONNECTED_TO_fp32_result   --  fp32_result.fp32_result
		);

