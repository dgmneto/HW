//Created by: Higor Cavalcanti
//Title: Unsigned/Signed Multiplicator
//Description: Calculates the product of a multiplier and a multiplicand
//based on Patterson and Hennessy's algorithm. If the sign input is "1", then the algorithm
//will use two's complement in the logic, in order to preserve the signal.

module Multiplier(
	input [31:0] multiplier,
	input [31:0] multiplicand,
	input clk,
	input [1:0] select,
	output reg [63:0] product
	); 

   parameter sign = 1'b1;
   
   reg [63:0] product_temp;
   reg [31:0] multiplier_copy;
   reg [63:0] multiplicand_copy;
   reg negative_output;
   reg [5:0] bits;
   
   initial begin
        bits = 0;
        negative_output = 0;
   end

   always @( posedge clk )

     if( select == 2'b00 ) begin

        bits               = 6'd32;
        product           = 0;
        product_temp      = 0;
        multiplicand_copy = (!sign || !multiplicand[31]) ? 
                            { 32'd0, multiplicand } : 
                            { 32'd0, ~multiplicand + 1'b1};
        multiplier_copy   = (!sign || !multiplier[31]) ?
                            multiplier :
                            ~multiplier + 1'b1; 

        negative_output = sign && 
                          ((multiplier[31] && !multiplicand[31]) 
                        ||(!multiplier[31] && multiplicand[31]));
        
     end 
     else if ( bits > 0 && select == 2'b01 ) begin

        if( multiplier_copy[0] == 1'b1 ) product_temp = product_temp +
multiplicand_copy;

        product = (!negative_output) ? 
                  product_temp : 
                  ~product_temp + 1'b1;

        multiplier_copy = multiplier_copy >> 1;
        multiplicand_copy = multiplicand_copy << 1;
        bits = bits - 6'd1;

     end
endmodule
