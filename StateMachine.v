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

	parameter OFOP0 = 32'd500;
	parameter initialization = 32'd0;
	parameter instread = 32'd1;
	parameter pcp4 = 32'd2;
	parameter decodification0 = 32'd3;
	parameter decodification1 = 32'd4;
	parameter mfhi0 = 32'd5;
	parameter mflo0 = 32'd6;
	parameter break0 = 32'd7;
	parameter rte0 = 32'd8;
	parameter add0 = 32'd9;
	parameter add1 = 32'd10;
	parameter add2 = 32'd11;
	parameter and0 = 32'd12;
	parameter and1 = 32'd13;
	parameter and2 = 32'd14;
	parameter sub0 = 32'd15;
	parameter sub1 = 32'd16;
	parameter sub2 = 32'd17;
	parameter jr0 = 32'd18;
	parameter jr1 = 32'd19;
	parameter jr2 = 32'd20;
	parameter sll0 = 32'd21;
	parameter sll1 = 32'd22;
	parameter sll2 = 32'd23;
	parameter sll3 = 32'd24;
	parameter sra0 = 32'd25;
	parameter sra1 = 32'd26;
	parameter sra2 = 32'd27;
	parameter sra3 = 32'd28;
	parameter srl0 = 32'd29;
	parameter srl1 = 32'd30;
	parameter srl2 = 32'd31;
	parameter srl3 = 32'd32;
	parameter sllv0 = 32'd33;
	parameter sllv1 = 32'd34;
	parameter sllv2 = 32'd35;
	parameter sllv3 = 32'd36;
	parameter srav0 = 32'd37;
	parameter srav1 = 32'd38;
	parameter srav2 = 32'd39;
	parameter srav3 = 32'd40;
	parameter slt0 = 32'd41;
	parameter slt1 = 32'd42;
	parameter push0 = 32'd43;
	parameter push1 = 32'd44;
	parameter push2 = 32'd45;
	parameter pop0 = 32'd46;
	parameter pop1 = 32'd47;
	parameter pop2 = 32'd48;
	parameter pop3 = 32'd49;
	parameter pop4 = 32'd50;
	parameter pop5 = 32'd51;
	parameter mult0 = 32'd52;
	parameter div0 = 32'd53;

	initial begin
		delay = 5'd0;
	end

	always @(negedge clck) begin
		if(delay == 5'd0) begin
			case(state)
				initialization: begin
					ShiftOutSrc = 1'd0;
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
					ALUOutCtrl = 1'b0;

					state = instread;
				end
				instread: begin
					PCWrite = 0;
					RegWrite = 0;
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
				 	case (opCode)
						// instrucoes tipo R
						6'b0: begin
							case(instruction)
								6'h10: begin
									state = mfhi0;
								end
								6'h12: begin
									state = mflo0;
								end
								6'h20: begin
									state = add0;
								end
								6'h24: begin
									state = and0;
								end
								6'h22: begin
									state = sub0;
								end
								6'h0: begin
									state = sll0;
								end
								6'h4: begin
									state = sllv0;
								end
								6'h3: begin
									state = sra0;
								end
								6'h7: begin
									state = srav0;
								end
								6'h2: begin
									state = srl0;
								end
								6'hd: begin
									state = break0;
								end
								6'h13: begin
									state = rte0;
								end
								6'h2a: begin
									state = slt0;
								end
								6'h1a: begin
									state = div0;
								end
								6'h18: begin
									state = mult0;
								end
								6'h5: begin
									state = push0;
								end
								6'h6: begin
									state = pop0;
								end
							endcase

						end
					endcase
				end
				mfhi0: begin
					RegDst = 3'b001;
					MemToReg = 3'b010;
					RegWrite = 1'b1;

					state = instread;
				end
				mflo0: begin
					RegDst = 3'b001;
					MemToReg = 3'b011;
					RegWrite = 1'b1;

					state = instread;
				end
				add0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = add1;
				end
				add1: begin
					ALUOp = 2'b001;
					ALUOutCtrl = 1'b1;

					state = add2;
				end
				add2: begin
					ALUOutCtrl = 1'b0;
					if(OFOP == 1'b0) begin
						RegWrite = 1'b1;
						MemToReg = 3'b000;
						RegDst = 3'b001;

						state = instread;
					end else begin
						state = OFOP0;
					end
				end
				sub0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = add1;
				end
				sub1: begin
					ALUOp = 2'b010;
					ALUOutCtrl = 1'b1;

					state = add2;
				end
				sub2: begin
					ALUOutCtrl = 1'b0;
					if(OFOP == 1'b0) begin
						RegWrite = 1'b1;
						MemToReg = 3'b000;
						RegDst = 3'b001;

						state = instread;
					end else begin
						state = OFOP0;
					end
				end
				and0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = add1;
				end
				and1: begin
					ALUOp = 2'b011;
					ALUOutCtrl = 1'b1;

					state = add2;
				end
				and2: begin
					ALUOutCtrl = 1'b0;
					RegWrite = 1'b1;
					MemToReg = 3'b000;
					RegDst = 3'b001;

					state = instread;
				end
				jr0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = jr1;
				end
				jr1: begin
					ALUSrcA = 2'b10;
					ALUOp = 3'b000;
					ALUOutCtrl = 1'b0;

					state = jr2;
				end
				jr2: begin
					PCSource = 1'b0;
					PCWrite = 1'b1;

					state = instread;
				end
				sll0: begin
					ABCtrl = 1'b1;

					state = sll1;
				end
				sll1: begin
					ABCtrl = 1'b0;
					ShiftOutSrc = 1'b1;
					ShiftOp = 3'b001;

					state = sll2;
				end
				sll2: begin
					ShiftOp = 3'b010;

					state = sll3;
				end
				sll3: begin
					RegWrite = 1'b1;
					MemToReg = 3'b100;
					RegDst = 3'b001;

					state = instread;
				end
				sra0: begin
					ABCtrl = 1'b1;

					state = sra1;
				end
				sra1: begin
					ABCtrl = 1'b0;
					ShiftOutSrc = 1'b1;
					ShiftOp = 3'b001;

					state = sra2;
				end
				sra2: begin
					ShiftOp = 3'b100;

					state = sra3;
				end
				sra3: begin
					RegWrite = 1'b1;
					MemToReg = 3'b100;
					RegDst = 3'b001;

					state = instread;
				end
				srl0: begin
					ABCtrl = 1'b1;

					state = srl1;
				end
				srl1: begin
					ABCtrl = 1'b0;
					ShiftOutSrc = 1'b1;
					ShiftOp = 3'b001;

					state = srl2;
				end
				srl2: begin
					ShiftOp = 3'b011;

					state = srl3;
				end
				srl3: begin
					RegWrite = 1'b1;
					MemToReg = 3'b100;
					RegDst = 3'b001;

					state = instread;
				end
				sllv0: begin
					ABCtrl = 1'b1;

					state = sllv1;
				end
				sllv1: begin
					ABCtrl = 1'b0;
					ShiftOutSrc = 1'b0;
					ShiftOp = 3'b001;

					state = sllv2;
				end
				sllv2: begin
					ShiftOp = 3'b010;

					state = sll3;
				end
				sllv3: begin
					RegWrite = 1'b1;
					MemToReg = 3'b100;
					RegDst = 3'b001;

					state = instread;
				end
				srav0: begin
					ABCtrl = 1'b1;

					state = srav1;
				end
				srav1: begin
					ABCtrl = 1'b0;
					ShiftOutSrc = 1'b0;
					ShiftOp = 3'b001;

					state = srav2;
				end
				srav2: begin
					ShiftOp = 3'b100;

					state = srav3;
				end
				srav3: begin
					RegWrite = 1'b1;
					MemToReg = 3'b100;
					RegDst = 3'b001;

					state = instread;
				end
				break0: begin
					PCSource = 0;
					PCWrite = 1'b1;
					ALUOp = 3'b011;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b01;

					state = instread;
				end
				rte0: begin
					PCSource = 2'b11;
					PCWrite = 1'b1;

					state = instread;
				end
				slt0: begin
					RR1 = 0;
					ABCtrl = 1'b1;

					state = slt1;
				end
				slt1: begin
					ALUOp = 3'b111;
					FlagCtrl = 2'b00;
					CompOp = 1'b0;
					RegWrite = 1'b1;
					MemToReg = 3'b110;
					RegDst = 3'b001;

					state = instread;
				end
				push0: begin
					RR1 = 1'b1;
					ABCtrl = 1'b1;

					state = push1;
				end
				push1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b01;
					ALUOp = 3'b010;
					ALUOutCtrl = 1'b1;

					state = push2;
				end
				push2: begin
					wrMemo = 1'b1;
					IorD = 3'b100;
					StrCtrl = 2'b00;

					state = instread;
				end
				pop0: begin
					RR1 = 1'b1;
					ABCtrl = 1'b1;

					state = pop1;
				end
				pop1: begin
					ALUSrcA = 2'b10;
					ALUOp = 3'b000;
					ALUOutCtrl = 1'b1;

					state = pop2;
				end
				pop2: begin
					wrMemo = 1'b1;
					IorD = 3'b100;
					IRWrite = 1'b0;
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = pop3;
				end
				pop3: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b01;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = pop4;
				end
				pop4: begin
					RegWrite = 1'b1;
					RegDst = 3'b010;
					MemToReg = 3'b000;

					state = pop5;
				end
				pop5: begin
					RegWrite = 1'b1;
					RegDst = 3'b000;
					MemToReg = 3'b001;

					state = instread;
				end

			endcase
		end
		else
			delay = delay - 5'd1;
	end
endmodule
