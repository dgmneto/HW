module Mux4(
		input [31:0] in0,
		input [31:0] in1,
		input [31:0] in2,
		input [31:0] in3,
		input [1:0] select,
		output reg[31:0] selected
	);
	always @(*) begin
		case(select)
			2'b00: selected = in0;
			2'b01: selected = in1;
			2'b10: selected = in2;
			2'b11: selected = in3;
		endcase
	end
endmodule
