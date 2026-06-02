	fp32MultAcc u0 (
		.accumulate  (_connected_to_accumulate_),  //   input,   width = 1,  accumulate.accumulate
		.fp32_mult_a (_connected_to_fp32_mult_a_), //   input,  width = 32, fp32_mult_a.fp32_mult_a
		.fp32_mult_b (_connected_to_fp32_mult_b_), //   input,  width = 32, fp32_mult_b.fp32_mult_b
		.clk         (_connected_to_clk_),         //   input,   width = 1,         clk.clk
		.ena         (_connected_to_ena_),         //   input,   width = 3,         ena.ena
		.fp32_result (_connected_to_fp32_result_)  //  output,  width = 32, fp32_result.fp32_result
	);

