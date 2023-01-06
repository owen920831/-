`timescale 1ns / 1ps
module bitmap_gen(
	input wire clk, reset,
	input wire video_on,
	input [1:0] btn,
	input wire [9:0] pix_x, pix_y,
	output reg [11:0] bit_rgb );
	
	parameter TRANSPARENT_COLOR = 12'b111101001111; //need change
    parameter SKY_COLOR = 12'b001010011000; //need change
	
	// memory address management
	wire [14-1:0] addr_next;
	wire [10:0] addr_map_next;
	wire sum1, sum2;
	
	// map scrolling using buttons
	reg [7:0] shift_map;
	wire [7:0] shift_map_next;
	wire [1:0] db_level, db_tick;
	
	// actually value of sprite1 (pixel), sprite2 (pixel), map (block)
	wire [11:0] sprite1_out, sprite2_out;
	wire [4:0] sprite_block;
	
	// assembly in memory of maps and sprite
	map map(.clk(clk), .en(1'b1), .addr(addr_map_next), .dataout(sprite_block));
	
	sprite1 sprite1(.clk(clk), .en(1'b1), .addr(addr_next), .dataout(sprite1_out));
	sprite2 sprite2(.clk(clk), .en(1'b1), .addr(addr_next), .dataout(sprite2_out));
	
	// button reading
	debounce db1(.clk(clk), .reset(reset), .sw(btn[0]), .db_level(db_level[0]), .db_tick(db_tick[0]));
	debounce db2(.clk(clk), .reset(reset), .sw(btn[1]), .db_level(db_level[1]), .db_tick(db_tick[1]));
	
	// calculation of memory positions
	assign addr_map_next = shift_map*15+((pix_x >>5)*15)+(pix_y>>5);
	assign addr_next = (pix_x % 32)+((pix_y%32)<<5)+(sprite_block-1)*32*32;
	
	// limit for the shift
	assign sum1 = shift_map < 80? db_tick[0]:0;
	assign sum2 = shift_map > 0? db_tick[1]:0;
	
	assign shift_map_next = shift_map + sum1 - sum2; 
	
	
	always @(posedge clk) begin
		if (reset)
			shift_map <= 0;
		else
			shift_map <= shift_map_next;
	end

	// pixel return
	wire is_sprite2, is_sky;
   
	assign is_sprite2 = (sprite_block > 16);
	assign is_sky = (sprite_block == 5'b00000) ||
					(is_sprite2 && (sprite2_out == TRANSPARENT_COLOR)) ||
					((!is_sprite2) && sprite1_out == TRANSPARENT_COLOR);
					
	
	always @(*) begin
		bit_rgb = 12'b000000000000;
		if (video_on)begin
			if (is_sky)
				bit_rgb = SKY_COLOR;
			else 
				bit_rgb = (is_sprite2) ? sprite2_out : sprite1_out;
		end
	end	
endmodule
