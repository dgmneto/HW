module Mux8(
		input [31:0] in0,
		input [31:0] in1,
		input [31:0] in2,
		input [31:0] in3,
		input [31:0] in4,
		input [31:0] in5,
		input [31:0] in6,
		input [31:0] in7,
		input [2:0] select,
		output reg[31:0] selected
	);
	always @(*) begin
		case(select)
			3'b000: selected = in0;
			3'b001: selected = in1;
			3'b010: selected = in2;
			3'b011: selected = in3;
			3'b100: selected = in4;
			3'b101: selected = in5;
			3'b110: selected = in6;
			3'b111: selected = in7;
		endcase
	end
endmodule
