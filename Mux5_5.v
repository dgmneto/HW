module Mux5_5(
		input [4:0] in0,
		input [4:0] in1,
		input [4:0] in2,
		input [4:0] in3,
		input [4:0] in4,
		input [2:0] select,
		output reg[4:0] selected
	);
	always @(*) begin
		case(select)
			3'b000: selected = in0;
			3'b001: selected = in1;
			3'b010: selected = in2;
			3'b011: selected = in3;
			3'b100: selected = in4;
		endcase
	end
endmodule
