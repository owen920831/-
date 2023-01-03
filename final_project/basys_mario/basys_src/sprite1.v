`timescale 1ns / 1ps
module sprite1
(
input  clk, en,
input [14-1:0] addr,
output reg [12-1:0]dataout
);


   parameter RAM_WIDTH = 12; //12bit rgb
   parameter RAM_ADDR_BITS = 14; //2^14 = 16384
   // 16 k Memoria
   (* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
   reg [RAM_WIDTH-1:0] imagen [(2**RAM_ADDR_BITS)-1:0];
   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   initial
   begin
	$readmemb("sprite1.bin", imagen, 0, (2**RAM_ADDR_BITS)-1);
	end
	
   always @(posedge clk)
      if (en) begin
			dataout <= imagen[addr];
      end
						
endmodule