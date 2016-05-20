module JPCINST(
		input [27:0] inst,
		input [31:0] pc,
		output reg[31:0] joint
	);
	always @(*) begin
		joint = {pc[31:28], inst[27:0]};
	end
endmodule
