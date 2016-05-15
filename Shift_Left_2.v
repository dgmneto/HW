module Shift_Left_2(
		input [31:0] in,
		output wire[31:0] out
	);
	assign out = in[31]?{in[29:0], 2'b11}:{in[29:0], 2'b00};
endmodule
