`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter_tb;

reg clk, rst_n, enable, flip;
reg [3:0] max, min;
wire direction;
wire [3:0] out;

Parameterized_Ping_Pong_Counter p(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .flip(flip),
    .max(max),
    .min(min),
    .direction(direction),
    .out(out)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    enable = 1'b1;
    max = 4'b1111;
    min = 4'b0001;
    flip = 1'b0;
    #1;
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
    #400;
    enable = 1'b0;
    #40;
    enable = 1'b1;
    #60;
    min = 4'b0101;     // changing min
    #150;
    enable = 1'b0;
    #40;
    enable = 1'b1;
    #100;
    flip = 1'b1;      // flip
    #10;
    flip = 1'b0;
    #20;
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
    #30;
    flip = 1'b1;      // flip
    #10;
    flip = 1'b0;
    #20;
    max = 4'b1100;    // changing max
    #200
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
    #100
    enable = 1'b0;
    #50
    rst_n = 1'b0;
    #10
    rst_n = 1'b1;
    #50
    enable = 1'b1;
    #100
    rst_n = 1'b0;
    #50
    enable = 1'b0;
    #10
    enable = 1'b1;
    #50
    rst_n = 1'b1;
    #100
    rst_n = 1'b0;
    #50
    enable = 1'b0;
    #10
    rst_n = 1'b1;
    #50
    enable = 1'b1;
    #100
    enable = 1'b0;
    #50
    rst_n = 1'b0;
    #10
    enable = 1'b1;
    #50
    rst_n = 1'b1;
    
    #100;
    $finish;

end
endmodule