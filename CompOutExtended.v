module CompOutExtended (
		input CompOut,
		output reg [31:0] Extended
	);
	initial Extended = 32'd0;
	always @(*) Extended[0] = CompOut;
endmodule
