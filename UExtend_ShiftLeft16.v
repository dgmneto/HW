module UExtend_ShiftLeft16(
		input [15:0] in,
		output wire[31:0] out
	);
	assign out = {in, 16'd0};
endmodule
