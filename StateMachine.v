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
		output reg ShiftOutSrc,
		output reg Reset
	);

	reg [31:0] state;
	reg [4:0] delay;

	parameter OFOP0 = 32'd500;
	parameter OFOP1 = 32'd501;
	parameter OFOP2 = 32'd502;
	parameter DIVZERO0 = 32'd600;
	parameter DIVZERO1 = 32'd601;
	parameter DIVZERO2 = 32'd602;
	parameter OPCINEX0 = 32'd700;
	parameter OPCINEX1 = 32'd701;
	parameter OPCINEX2 = 32'd702;
	parameter initialization = 32'd0;
	parameter instread = 32'd1;
	parameter pcp4 = 32'd2;
	parameter decodification0 = 32'd3;
	parameter decodification1 = 32'd4;
	parameter mfhi0 = 32'd5;
	parameter mflo0 = 32'd6;
	parameter break0 = 32'd7;
	parameter j0 = 32'd8;
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
	parameter div0 = 32'd52;
	parameter div1 = 32'd53;
	parameter div2 = 32'd54;
	parameter div3 = 32'd55;
	parameter mult0 = 32'd56;
	parameter mult1 = 32'd57;
	parameter mult2 = 32'd58;
	parameter mult3 = 32'd59;
	parameter addi0 = 32'd60;
	parameter addi1 = 32'd61;
	parameter addi2 = 32'd62;
	parameter addiu0 = 32'd63;
	parameter addiu1 = 32'd64;
	parameter addiu2 = 32'd65;
	parameter beq0 = 32'd66;
	parameter beq1 = 32'd67;
	parameter beq2 = 32'd68;
	parameter bne0 = 32'd69;
	parameter bne1 = 32'd70;
	parameter bne2 = 32'd71;
	parameter ble0 = 32'd72;
	parameter ble1 = 32'd73;
	parameter ble2 = 32'd74;
	parameter bgt0 = 32'd75;
	parameter bgt1 = 32'd76;
	parameter bgt2 = 32'd77;
	parameter lb0 = 32'd78;
	parameter lb1 = 32'd79;
	parameter lb2 = 32'd80;
	parameter lb3 = 32'd81;
	parameter lb4 = 32'd82;
	parameter lh0 = 32'd83;
	parameter lh1 = 32'd84;
	parameter lh2 = 32'd85;
	parameter lh3 = 32'd86;
	parameter lh4 = 32'd87;
	parameter lw0 = 32'd88;
	parameter lw1 = 32'd89;
	parameter lw2 = 32'd90;
	parameter lw3 = 32'd91;
	parameter lw4 = 32'd92;
	parameter sb0 = 32'd93;
	parameter sb1 = 32'd94;
	parameter sb2 = 32'd95;
	parameter sb3 = 32'd96;
	parameter sb4 = 32'd97;
	parameter sh0 = 32'd98;
	parameter sh1 = 32'd99;
	parameter sh2 = 32'd100;
	parameter sh3 = 32'd101;
	parameter sh4 = 32'd102;
	parameter sw0 = 32'd103;
	parameter sw1 = 32'd104;
	parameter sw2 = 32'd105;
	parameter jal0 = 32'd106;
	parameter jal1 = 32'd107;
	parameter jal2 = 32'd108;
	parameter rte0 = 32'd109;
	parameter slti0 = 32'd110;
	parameter slti1 = 32'd111;
	parameter lui0 = 32'd112;

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
					Reset = 1'b1;

					state = instread;
				end
				instread: begin
					Reset = 1'b0;
					PCWriteCond = 1'b0;
					PCWrite = 1'b0;
					ALUSrcB = 2'b00;
					wrMemo = 1'b0;
					RegWrite = 1'b0;
					DivMulCtrl = 2'b00;
					EPCWrite = 1'b0;
					StrCtrl = 1'b0;
					MDRCtrl = 2'b00;
					MDRLoad = 1'b0;
					ABCtrl = 1'b0;
					ALUOutCtrl = 1'b0;
					MulCtrl = 2'b00;
					DivCtrl = 2'b00;
					HILOCtrl = 1'b0;
					IorD = 3'd0;

					state = pcp4;
				end
				pcp4: begin
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b01;
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
				//Precisa checar opcode inexistente aqui e pular para state = OPCINEX0;
					IRWrite = 1'b0;
					if(opCode == 6'b000000) begin
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
							6'h8: begin
								state = jr0;
							end
						endcase
					end else begin
						case(opCode)
							6'h8: begin
								state = addi0;
							end
							6'h9: begin
								state = addiu0;
							end
							6'h4: begin
								state = beq0;
							end
							6'h5: begin
								state = bne0;
							end
							6'h6: begin
								state = ble0;
							end
							6'h7: begin
								state = bgt0;
							end
							6'h20: begin
								state = lb0;
							end
							6'h21: begin
								state = lh0;
							end
							6'h23: begin
								state = lw0;
							end
							6'h28: begin
								state = sb0;
							end
							6'h29: begin
								state = sh0;
							end
							6'h2b: begin
								state = sw0;
							end
							6'h2: begin
								state = j0;
							end
							6'h3: begin
								state = jal0;
							end
							6'ha: begin
								state = slti0;
							end
							6'hf: begin
								state = lui0;
							end
						endcase
					end
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
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;

					state = add1;
				end
				add1: begin
					ALUOp = 3'b001;
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
					ALUOp = 3'b010;
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
					ALUOp = 3'b011;
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
					ALUOp = 3'b010;
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
				div0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = div1;
				end
				div1: begin
					DivCtrl = 2'b01;

					state = div2;
				end
				div2: begin
					if(DivZeroOP == 0) begin
						DivCtrl = 2'b10;
						delay = 6'd32;

						state = div3;
					end else begin
						state = DIVZERO0;
					end
				end
				div3: begin
					DivCtrl = 2'b11;
					DivMulCtrl = 1'b0;
					HILOCtrl = 1'b1;

					state = instread;
				end
				mult0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = mult1;
				end
				mult1: begin
					MulCtrl = 2'b01;

					state = mult2;
				end
				mult2: begin
					MulCtrl = 2'b10;
					delay = 6'd32;

					state = mult3;
				end
				mult3: begin
					MulCtrl = 2'b11;
					DivMulCtrl = 1'b1;
					HILOCtrl = 1'b1;

					state = instread;
				end
				addi0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = addi1;
				end
				addi1: begin
					ALUOp = 3'b001;
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b10;
					ALUOutCtrl = 1'b1;

					state = addi2;
				end
				addi2: begin
					if(OFOP == 0) begin
						RegWrite = 1'b1;
						MemToReg = 3'b000;
						RegDst = 3'b000;

						state = instread;
					end else begin
						state = OFOP0;
					end
				end
				addiu0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = addiu1;
				end
				addiu1: begin
					ALUOp = 3'b001;
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b10;
					ALUOutCtrl = 1'b1;

					state = addiu2;
				end
				addiu2: begin
					RegWrite = 1'b1;
					MemToReg = 3'b000;
					RegDst = 3'b000;

					state = instread;
				end
				beq0: begin
					ALUOp = 3'b001;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b11;
					ALUOutCtrl = 1'b1;
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = beq1;
				end
				beq1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;
					ALUOutCtrl = 1'b0;

					state = beq2;
				end
				beq2: begin
					ALUOp = 3'b111;
					FlagCtrl = 2'b10;
					CompOp = 1'b0;
					PCWriteCond = 1'b1;
					PCSource = 2'b10;

					state = instread;
				end
				bne0: begin
					ALUOp = 3'b001;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b11;
					ALUOutCtrl = 1'b1;
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = bne1;
				end
				bne1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;
					ALUOutCtrl = 1'b0;

					state = bne2;
				end
				bne2: begin
					ALUOp = 3'b111;
					FlagCtrl = 2'b10;
					CompOp = 1'b1;
					PCWriteCond = 1'b1;
					PCSource = 2'b10;

					state = instread;
				end
				ble0: begin
					ALUOp = 3'b001;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b11;
					ALUOutCtrl = 1'b1;
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = ble1;
				end
				ble1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;
					ALUOutCtrl = 1'b0;

					state = ble2;
				end
				ble2: begin
					ALUOp = 3'b111;
					FlagCtrl = 2'b00;
					CompOp = 1'b0;
					PCWriteCond = 1'b1;
					PCSource = 2'b10;

					state = instread;
				end
				bgt0: begin
					ALUOp = 3'b001;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b11;
					ALUOutCtrl = 1'b1;
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = bgt1;
				end
				bgt1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;
					ALUOutCtrl = 1'b0;

					state = bgt2;
				end
				bgt2: begin
					ALUOp = 3'b111;
					FlagCtrl = 2'b01;
					CompOp = 1'b0;
					PCWriteCond = 1'b1;
					PCSource = 2'b10;

					state = instread;
				end
				lh0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = lh1;
				end
				lh1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b11;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = lh2;
				end
				lh2: begin
					wrMemo = 1'b0;
					IorD = 3'b100;
					delay = 6'd1;

					state = lh3;
				end
				lh3: begin
					MDRCtrl = 2'b00;
					MDRLoad = 1'b1;

					state = lh3;
				end
				lh4: begin
					RegDst = 3'b00;
					MemToReg = 3'b001;
					RegWrite = 1'b1;

					state = instread;
				end
				lb0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = lb1;
				end
				lb1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b11;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = lb2;
				end
				lb2: begin
					wrMemo = 1'b0;
					IorD = 3'b100;
					delay = 6'd1;

					state = lb3;
				end
				lb3: begin
					MDRCtrl = 2'b01;
					MDRLoad = 1'b1;

					state = lb3;
				end
				lb4: begin
					RegDst = 3'b00;
					MemToReg = 3'b001;
					RegWrite = 1'b1;

					state = instread;
				end
				lw0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = lw1;
				end
				lw1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b11;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = lw2;
				end
				lw2: begin
					wrMemo = 1'b0;
					IorD = 3'b100;
					delay = 6'd1;

					state = lw3;
				end
				lw3: begin
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = lw3;
				end
				lw4: begin
					RegDst = 3'b00;
					MemToReg = 3'b001;
					RegWrite = 1'b1;

					state = instread;
				end
				sb0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = sb1;
				end
				sb1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b11;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = sb2;
				end
				sb2: begin
					wrMemo = 1'b0;
					IorD = 3'b100;
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = sb3;
				end
				sb3: begin
					wrMemo = 1'b0;
					delay = 6'd1;

					state = sb4;
				end
				sb4: begin
					wrMemo = 1'b1;
					IorD = 3'b100;
					StrCtrl = 2'b10;

					state = instread;
				end
				sh0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = sh1;
				end
				sh1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b11;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = sh2;
				end
				sh2: begin
					wrMemo = 1'b0;
					IorD = 3'b100;
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = sh3;
				end
				sh3: begin
					wrMemo = 1'b0;
					delay = 6'd1;

					state = sh4;
				end
				sh4: begin
					wrMemo = 1'b1;
					IorD = 3'b100;
					StrCtrl = 2'b11;

					state = instread;
				end
				sw0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = sw1;
				end
				sw1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b11;
					ALUOp = 3'b001;
					ALUOutCtrl = 1'b1;

					state = sw2;
				end
				sw2: begin
					wrMemo = 1'b1;
					IorD = 3'b100;
					StrCtrl = 2'b01;

					state = instread;
				end
				j0: begin
					PCSource = 2'b10;
					PCWrite = 1'b1;

					state = instread;
				end
				jal0: begin
					ALUSrcA = 2'b00;
					ALUOp = 3'b000;
					ALUOutCtrl = 1'b1;

					state = jal1;
				end
				jal1: begin
					RegWrite = 1'b1;
					RegDst = 3'b100;
					MemToReg = 3'b000;

					state = jal2;
				end
				jal2: begin
					PCSource = 2'b10;
					PCWrite = 1'b1;

					state = instread;
				end
				slti0: begin
					RR1 = 1'b0;
					ABCtrl = 1'b1;

					state = slti1;
				end
				slti1: begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b10;
					ALUOp = 3'b111;
					FlagCtrl = 1'b0;
					CompOp = 1'b0;
					RegWrite = 1'b1;
					RegDst = 3'b000;
					MemToReg = 3'b110;

					state = instread;
				end
				lui0: begin
					MemToReg = 3'b101;
					RegWrite = 1'b1;
					RegDst = 2'b00;

					state = instread;
				end
				OPCINEX0: begin
					wrMemo = 1'b0;
					IorD = 3'b001;
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = OPCINEX1;
				end
				OPCINEX1: begin
					ALUSrcA = 2'b00;
					ALUSrcB = 3'b000;
					EPCWrite = 1'b1;
					delay = 6'd1;

					state = OPCINEX2;
				end
				OPCINEX2: begin
					ALUSrcA = 2'b01;
					ALUOp = 3'b000;
					PCSource = 2'b00;
					PCWrite = 1'b1;

					state = instread;
				end
				OFOP0: begin
					wrMemo = 1'b0;
					IorD = 3'b011;
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = OFOP1;
				end
				OFOP1: begin
					ALUSrcA = 2'b00;
					ALUSrcB = 3'b000;
					EPCWrite = 1'b1;
					delay = 6'd1;

					state = OFOP2;
				end
				OFOP2: begin
					ALUSrcA = 2'b01;
					ALUOp = 3'b000;
					PCSource = 2'b00;
					PCWrite = 1'b1;

					state = instread;
				end
				DIVZERO0: begin
					wrMemo = 1'b0;
					IorD = 3'b010;
					MDRCtrl = 2'b10;
					MDRLoad = 1'b1;

					state = DIVZERO1;
				end
				DIVZERO1: begin
					ALUSrcA = 2'b00;
					ALUSrcB = 3'b000;
					EPCWrite = 1'b1;
					delay = 6'd1;

					state = DIVZERO2;
				end
				DIVZERO2: begin
					ALUSrcA = 2'b01;
					ALUOp = 3'b000;
					PCSource = 2'b00;
					PCWrite = 1'b1;

					state = instread;
				end
			endcase
		end
		else
			delay = delay - 5'd1;
	end
endmodule
