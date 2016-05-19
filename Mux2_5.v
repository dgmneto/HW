module Mux2_5(
		input [4:0] in0,
		input [4:0] in1,
		input select,
		output reg[4:0] selected
	);
	always @(*) begin
		case(select)
			1'b0: selected = in0;
			1'b1: selected = in1;
		endcase
	end
endmodule
