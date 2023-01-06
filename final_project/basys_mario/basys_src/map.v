`timescale 1ns / 1ps

module map(
	input  clk, en,
	input [11-1:0] addr,
	output reg [5-1:0] dataout );


	parameter RAM_WIDTH = 5;
	parameter RAM_ADDR_BITS = 11;

	(* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
	reg [RAM_WIDTH-1:0] map [1499:0];

	//  The forllowing code is only necessary if you wish to initialize the RAM 
	//  contents via an external file (use $readmemb for binary data)
	initial
	$readmemb("map.bin", map, 0, 1499);

	always @(posedge clk) begin
		if (en) begin
			dataout <= map[addr];
		end
	end
				
endmodule
