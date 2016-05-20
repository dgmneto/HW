module Clock(
		output reg clck
	);
	initial clck = 0;
	always #1 clck = ~clck;
endmodule
	