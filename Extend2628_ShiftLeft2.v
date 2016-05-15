module Extend2628_ShiftLeft2(
		input [25:0] in,
		output wire[27:0] out
	);
	assign out = {in, 2'b00};
endmodule
