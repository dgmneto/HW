module Extend1632(
		input [15:0] in,
		output wire[31:0] out
	);
	assign out = {(in[15] == 0) ? (16'd0) : (16'b1111111111111111), in};
endmodule
