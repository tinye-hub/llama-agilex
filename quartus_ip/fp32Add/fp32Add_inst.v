	fp32Add u0 (
		.fp32_adder_a (_connected_to_fp32_adder_a_), //   input,  width = 32, fp32_adder_a.fp32_adder_a
		.fp32_adder_b (_connected_to_fp32_adder_b_), //   input,  width = 32, fp32_adder_b.fp32_adder_b
		.clk          (_connected_to_clk_),          //   input,   width = 1,          clk.clk
		.ena          (_connected_to_ena_),          //   input,   width = 3,          ena.ena
		.fp32_result  (_connected_to_fp32_result_)   //  output,  width = 32,  fp32_result.fp32_result
	);

