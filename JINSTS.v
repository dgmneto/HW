module JINSTS(
		input [4:0] inst1,
		input [4:0] inst2,
		input [15:0] inst3,
		output reg [25:0] joint
	);
	always @(*) begin
		joint = {{inst1, inst2}, inst3};
	end
endmodule
