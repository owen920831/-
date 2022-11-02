`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [4-1:0] out;

reg [3:0] out;
reg direction;
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
        direction = 1'b1;
    end
    else if (enable) begin
        if (direction) begin
            if (out > 4'b1110)
                out <= 4'b1110;
            else out <= out + 4'b0001;
            direction <= (out == 4'b1111) ? 0 : 1;
        end
        else begin
            if (out < 4'b0001)
                out <= 4'b0001;
            else out <= out - 4'b0001;
            direction <= (out == 4'b0000) ? 1 : 0;
        end
    end
end
endmodule
