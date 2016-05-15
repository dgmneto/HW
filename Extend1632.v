module Extend1632(
		input [15:0] in,
		output wire[31:0] out
	);
	assign out[31] = in[15];
	assign out[30:0] = in[15] ? {16'b1111111111111111, in[14:0]} : {16'd0, in[14:0]};
endmodule
