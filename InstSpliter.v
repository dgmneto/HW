module InstSpliter(
		input [15:0] In,
		output reg[5:0] Splited1,
		output reg[4:0] Splited2,
		output reg[4:0] Splited3
	);
	always @(*) begin
		Splited1 = In[5:0];
		Splited2 = In[15:11];
		Splited3 = In[10:6];
	end
endmodule
