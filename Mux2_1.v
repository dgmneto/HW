module Mux2_1(
		input in0,
		input in1,
		input select,
		output reg selected
	);
	always @(*) begin
		case(select)
			1'b0: selected = in0;
			1'b1: selected = in1;
		endcase
	end
endmodule
