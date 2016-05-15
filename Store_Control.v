module Store_Control(
		input [31:0] B,
		input [31:0] MDR,
		input [1:0] STRCtrl,
		output reg[31:0] toMemory
	);
	parameter WORD = 2'b00;
	parameter HWORD = 2'b01;
	parameter BYTE = 2'b10;
	always @(*) begin
		case(STRCtrl)
			WORD: toMemory = B;
			HWORD: toMemory = {MDR[31:16], B[15:0]};
			BYTE: toMemory = {MDR[31:8], B[7:0]};
		endcase
	end
endmodule
