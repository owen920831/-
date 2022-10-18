`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;

reg [3:0] out;
reg direction = 1'b1;
always @(posedge clk) begin
    if (!rst_n) begin
        out <= min;
        direction <= 1'b1;
    end
    else if (enable and (max > min)) begin
        if ((out >= max) and (out <= min)) begin
            
        end
    end
end
endmodule
