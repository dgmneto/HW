parameter LOADA = 3'b000;
parameter ADD = 3'b001;
parameter SUB = 3'b010;
parameter AND = 3'b011;
parameter PLUS1 = 3'b100;
parameter NOT = 3'b101;
parameter XOR = 3'b110;
parameter COMP = 3'b111;

module ula(
  output reg [31:0]ulaOutput,
  output reg ulaZ,
  output reg ulaN,
  output reg ulaO,
  output reg ulaET,
  output reg ulaGT,
  output reg ulaLT,
  input [31:0]ulaA,
  input [31:0]ulaB,
  input [2:0]func
  )
  logic extra;
  logic [31:0]result;
  always @(*) begin
    case(func)
      LOADA: ulaOutput <= ulaA;
      ADD: begin
        ulaOutput <= ulaA + ulaB;
        {extra, result} = {ulaA[31], ulaA} + {ulaB[31], ulaB};
        ulaO = ({extra, result[31]} == 2'b01) + ({extra, result[31]} == 2'b10);
      end
      SUB: begin
        ulaOutput <= ulaA - ulaB;
        {extra, result} = {ulaA[31], ulaA} - {ulaB[31], ulaB};
        ulaO = ({extra, result[31]} == 2'b01) + ({extra, result[31]} == 2'b10);=
      end
      AND: ulaOutput <= ulaA & ulaB;
      PLUS1: ulaOutput <= ulaA + 32'd1;
      NOT: ulaOutput <= ~ulaA;
      XOR: ulaOutput <= ulaA ^ ulaB;
      COMP: begin
        ulaET = 1'd0;
        ulaGT = 1'd0;
        ulaLT = 1'd0;
        if(ulaA == ulaB) ulaET = 1'd1;
        else if(ulaA < ulaB) ulaLT = 1'd1;
        else ulaGT = 1'd1;
      end
    endcase
    ulaZ = (ulaOutput == 32'd0) ? 1'b1 : 1'b0;
    ulaN = (ulaOutput[31] == 1'b1) ? 1'b1 : 1'b0;
  end
endmodule
