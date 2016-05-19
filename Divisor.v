//Created by: Higor Cavalcanti
//Title: Unsigned/Signed Multiplicator
//Description: Calculates the product of a multiplier and a multiplicand
//based on Patterson and Hennessy's algorithm. If the sign input is "1", then the algorithm
//will use two's complement in the logic, in order to preserve the signal.

module Divisor
     (
		 input [1:0] select,
		 input [31:0] dividend,
		 input [31:0] divider,
		 input clk,
		 output reg[31:0] quotient,
		 output reg[31:0] remainder,
		 output reg DivZero
     );
   
   parameter sign = 1;

   reg [31:0] quotient_temp;
   reg [63:0] dividend_copy;
   reg [63:0] divider_copy;
   reg [63:0] diff;
   reg [5:0] bits; 
   reg negative_output;

   initial begin
        bits = 0;
        negative_output = 0;
   end
   
   always @(*) begin
		remainder = (!negative_output) ? 
                            dividend_copy[31:0] : 
                            ~dividend_copy[31:0] + 1'b1;
        DivZero = (divider == 32'd0) ? 1 : 0;
	end

   always @( posedge clk ) 

     if( select == 2'b00 ) begin

        bits = 6'd32;
        quotient = 0;
        quotient_temp = 0;
        dividend_copy = (!sign || !dividend[31]) ? 
                        {32'd0,dividend} : 
                        {32'd0,~dividend + 1'b1};
        divider_copy = (!sign || !divider[31]) ? 
                       {1'b0,divider,31'd0} : 
                       {1'b0,~divider + 1'b1,31'd0};

        negative_output = sign &&
                          ((divider[31] && !dividend[31]) 
                        ||(!divider[31] && dividend[31]));
        
     end 
     else if ( bits > 0 && select == 2'b01 ) begin

        diff = dividend_copy - divider_copy;

        quotient_temp = quotient_temp << 1;

        if( !diff[63] ) begin

           dividend_copy = diff;
           quotient_temp[0] = 1'd1;

        end

        quotient = (!negative_output) ? 
                   quotient_temp : 
                   ~quotient_temp + 1'b1;

        divider_copy = divider_copy >> 1;
        bits = bits - 6'd1;

     end
endmodule
