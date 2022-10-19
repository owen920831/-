`timescale 1ns / 1ps

module Ping_Pong_Counter_tb;

reg clk, rst_n, enable;
wire direction;
wire [3:0] out;

Ping_Pong_Counter p(
    .clk(clk), 
    .rst_n(rst_n), 
    .enable(enable), 
    .direction(direction), 
    .out(out)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    enable = 1'b1;
    #1;
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
    #400;
    enable = 1'b0;
    #40;
    enable = 1'b1;
    #150;
    enable = 1'b0;
    #40;
    enable = 1'b1;
    #100;
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
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

always@(posedge clk) begin
    #2;
    $display($time, " out = %d  ||  direction = %b || clk = %b || rst_n = %b || enable = %b || prev =",out,direction, clk, rst_n, enable);
end

endmodule