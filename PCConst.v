module PCConst(
		output reg [31:0] Const253,
		output reg [31:0] Const254,
		output reg [31:0] Const255
	);
	always @(*) begin
		Const253 = 32'd253;
		Const254 = 32'd254;
		Const255 = 32'd255;
	end
endmodule
