module fp32Add (
		input  wire [31:0] fp32_adder_a, // fp32_adder_a.fp32_adder_a, Data input that supplies value to one of the FP32 adder/sub operands.
		input  wire [31:0] fp32_adder_b, // fp32_adder_b.fp32_adder_b, Data input that supplies value to one of the FP32 adder/sub operands.
		input  wire        clk,          //          clk.clk,          Clock port that supplies clock signals to the enabled registers according to the register parameters setting. All registers in the DSP atom are positive edge-triggered.
		input  wire [2:0]  ena,          //          ena.ena,          Clock enable signal that pairs with the clock signal and allows a clock signal to be gated.  Each register will have the same clock enable settings as the clock parameter.
		output wire [31:0] fp32_result   //  fp32_result.fp32_result,  The final floating point operation result of the FP DSP atom in single-precision FP32 format. The output uses unfused multiply-add rounding using round to nearest even (RNE).
	);
endmodule

