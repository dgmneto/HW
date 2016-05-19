module StateMachine(
		input [5:0] opCode,
		input [5:0] instruction,
		input OFOP,
		input DivZeroOP,
		input clck,
		output reg PCWriteCond,
		output reg PCWrite,
		output reg [2:0] IorD,
		output reg wrMemo,
		output reg [2:0] MemToReg,
		output reg IRWrite,
		output reg RR1,
		output reg [2:0] RegDst,
		output reg [1:0] MulCtrl,
		output reg [1:0] DivCtrl,
		output reg [31:0] EXEVal,
		output reg RegWrite,
		output reg CompOp,
		output reg [1:0] FlagCtrl,
		output reg DivMulCtrl,
		output reg [2:0] ShiftOp,
		output reg EPCWrite,
		output reg [1:0] StrCtrl,
		output reg [1:0] MDRCtrl,
		output reg MDRLoad,
		output reg [2:0] ALUOp,
		output reg [1:0] PCSource,
		output reg [1:0] ALUSrcA,
		output reg [1:0] ALUSrcB,
		output reg ABCtrl,
		output reg HILOCtrl,
		output reg ALUOutCtrl,
		output reg ShiftOutSrc
	);
	reg [31:0] state;
	reg [4:0] delay;
	
	parameter initialization = 32'd0;
	parameter instread = 32'd1;
	parameter pcp4 = 32'd2;
	parameter decodification0 = 32'd3;
	parameter decodification1 = 32'd4;
	parameter mfhi0 = 32'd5;
	parameter mfhi1 = 32'd6;
	
	initial begin
		delay = 5'd0;
	end
	always @(negedge clck) begin
		if(delay == 5'd0) begin
			case(state)
				initialization: begin
					PCWriteCond = 0;
					PCWrite = 0;
					IorD = 3'd0;
					wrMemo = 0;
					MemToReg = 3'd0;
					IRWrite = 0;
					RR1 = 0;
					RegDst = 3'd0;
					MulCtrl = 2'd0;
					DivCtrl = 2'd0;
					EXEVal = 32'd0;
					RegWrite = 0;
					CompOp = 2'd0;
					FlagCtrl = 0;
					DivMulCtrl = 0;
					ShiftOp = 3'd0;
					EPCWrite = 0;
					StrCtrl = 2'd0;
					MDRCtrl = 2'd0;
					MDRLoad = 0;
					ALUOp = 3'd0;
					PCSource = 2'd0;
					ALUSrcA = 2'd0;
					ALUSrcB = 2'd0;
					ABCtrl  = 1'b0;
					HILOCtrl = 1'b0;
					
					state = instread;	
				end
				instread: begin
					wrMemo = 0;
					ALUSrcA = 2'd0;
					ALUSrcB = 2'b01;
					
					state = pcp4;
				end
				pcp4: begin
					ALUOp = 3'b001;
					PCWrite = 1'b1;
					PCSource = 2'b00;
					
					state = decodification0;
				end
				decodification0: begin
					PCWrite = 1'b0;
					IRWrite = 1'b1;
					
					state = decodification1;
				end
				decodification1: begin
					IRWrite = 1'b0;
					
					if (opCode == 6'd0) begin
						if (instruction == 6'd16) 
							state = mfhi0;
					end
				end
				mfhi0: begin
					RegDst = 3'b001;
					MemToReg = 3'b010;
					RegWrite = 1'b1;
					
					state = mfhi1;
				end
				mfhi1: begin
					RegWrite = 1'b0;
				end
			endcase
		end
		else
			delay = delay - 5'd1;
	end
endmodule
