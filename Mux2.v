module Mux2(
		input [31:0] in0,
		input [31:0] in1,
		input select,
		output reg[31:0] selected
	);
	always @(*) begin
		case(select)
			1'b0: selected = in0;
			1'b1: selected = in1;
		endcase
	end
endmodule
