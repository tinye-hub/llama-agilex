module fp32Rsqrt (
		input  wire        clk,    //    clk.clk,   All input signals must be synchronous to this clock
		input  wire        areset, // areset.reset, Active-high reset
		input  wire [0:0]  en,     //     en.en,    Allows calculation to take place when asserted
		input  wire [31:0] a,      //      a.a,     Data input
		output wire [31:0] q       //      q.q,     Data ouput
	);
endmodule

