module Mux3_1(
		input in0,
		input in1,
		input in2,
		input [1:0] select,
		output reg selected
	);
	always @(*) begin
		case(select)
			2'b00: selected = in0;
			2'b01: selected = in1;
			2'b10: selected = in2;
		endcase
	end
endmodule
