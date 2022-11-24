`timescale 1ns/1ps

module PWM_gen (
    input wire clk,
	input [31:0] freq,
    input rst_n,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk) begin
    if (rst_n) begin
        count <= 0;
        PWM <= 0;
    end
    if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule

module Decoder (
	input [4:0] tone,
	output reg [31:0] freq 
);

always @(*) begin
	case (tone)
		5'd0: freq = 32'd262;	//Do-m
		5'd1: freq = 32'd294;	//Re-m
		5'd2: freq = 32'd330;	//Mi-m
		5'd3: freq = 32'd349;	//Fa-m
		5'd4: freq = 32'd392;	//Sol-m
		5'd5: freq = 32'd440;	//La-m
		5'd6: freq = 32'd494;	//Si-m
		5'd7: freq = 32'd262 << 1;	//Do-m
		5'd8: freq = 32'd294 << 1;	//Re-m
		5'd9: freq = 32'd330 << 1;	//Mi-m
		5'd10: freq = 32'd349 << 1;	//Fa-m
		5'd11: freq = 32'd392 << 1;	//Sol-m
		5'd12: freq = 32'd440 << 1;	//La-m
		5'd13: freq = 32'd494 << 1;	//Si-m
        5'd14: freq = 32'd262 << 2;	//Do-m
		5'd15: freq = 32'd294 << 2;	//Re-m
		5'd16: freq = 32'd330 << 2;	//Mi-m
		5'd17: freq = 32'd349 << 2;	//Fa-m
		5'd18: freq = 32'd392 << 2;	//Sol-m
		5'd19: freq = 32'd440 << 2;	//La-m
		5'd20: freq = 32'd494 << 2;	//Si-m
        5'd21: freq = 32'd262 << 3;	//Do-m
		5'd22: freq = 32'd294 << 3;	//Re-m
		5'd23: freq = 32'd330 << 3;	//Mi-m
		5'd24: freq = 32'd349 << 3;	//Fa-m
		5'd25: freq = 32'd392 << 3;	//Sol-m
		5'd26: freq = 32'd440 << 3;	//La-m
		5'd27: freq = 32'd494 << 3;	//Si-m
        5'd28: freq = 32'd262 << 4;	//Do-m
		default : freq = 32'd20000;	//Do-dummy
	endcase
end

endmodule
module music (
    input clk,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4	//SHUTDOWN_N
);
wire [31:0] freq;
assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on

reg rst_n;
reg [4:0] tone;
reg dir;
integer i;
wire [511:0] key_down;
wire [8:0] last_change;
wire been_ready;

parameter [8:0] KEY_CODES_ent = 9'b0_0101_1010; // enter => 5A
parameter [8:0] KEY_CODES_s = 9'b0_0001_1011; // s => 1b
parameter [8:0] KEY_CODES_w = 9'b0_0001_1101; // w => 1D
parameter [8:0] KEY_CODES_r = 9'b0_0010_1101; // f => 2D

KeyboardDecoder key_de (
    .key_down(key_down),
    .last_change(last_change),
    .key_valid(been_ready),
    .PS2_DATA(PS2_DATA),
    .PS2_CLK(PS2_CLK),
    .rst(rst_n),
    .clk(clk)
); 

always @(*) begin  // press enter => rst_n
    if (been_ready && last_change == KEY_CODES_ent) begin
        rst_n = 1'b0;
    end
    else rst_n = 1'b1;
end

always @(*) begin  // press w || s change the direction
    if (been_ready) begin
        if (last_change == KEY_CODES_w) begin
            dir = 1'b1;
        end
        if (last_change == KEY_CODES_s) begin
            dir = 1'b0;
        end
    end    
end

always @(*) begin  // press r, change beat
    if (been_ready && last_change == KEY_CODES_r) begin
        if (i == 32'd1) i = 32'd2;
        else i = 32'd1;
    end
end

Decoder decoder00 (
	.tone(tone),
	.freq(freq)
);

PWM_gen gen_beat (
    .clk(clk),
    .freq(i),
    .rst_n(rst_n),
    .duty(10'd512),
    .PWM(beatFreq)
);

always @(posedge beatFreq or negedge rst_n) begin
    if (rst_n) begin
        tone <= 5'd0;
        dir <= 1'b1; 
        i = 32'd1;
    end
    if (dir) begin
        if (tone < 5'd28) begin
            tone <= tone + 5'd1;
        end
        else begin
            tone <= tone;
        end
    end
    else begin
        if (tone > 5'd0) begin
            tone <= tone - 5'd1;
        end
        else begin
            tone <= tone;
        end
    end
end

PWM_gen gen_music ( 
	.clk(clk), 
	.rst_n(rst_n), 
	.freq(freq),
	.duty(10'd512), 
	.PWM(pmod_1)
);


endmodule