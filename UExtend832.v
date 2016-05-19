module UExtend832(
		input [7:0] in,
		output wire[31:0] out
	);
	assign out = {8'd0, in};
endmodule
