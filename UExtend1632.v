module UExtend1632(
		input [15:0] in,
		output wire[32:0] out
	);
	assign out = {16'd0, in};
endmodule
