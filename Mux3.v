module Mux3(
		input [31:0] in0,
		input [31:0] in1,
		input [31:0] in2,
		input [1:0] select,
		output reg[31:0] selected
	);
	always @(*) begin
		case(select)
			2'b00: selected = in0;
			2'b01: selected = in1;
			2'b10: selected = in2;
		endcase
	end
endmodule
