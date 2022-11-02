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
reg direction;
always @(posedge clk) begin
    if (!rst_n) begin
        out <= min;
        direction <= 1'b1;
    end
    else if (enable && (max > min)) begin
        if ((out <= max) && (out >= min)) begin
            if (flip) begin
                direction <= ~direction;
                if (direction == 1'b0 && out < max) 
                    out <= out + 4'b0001;
                else if (direction == 1'b1 && out > min)
                    out <= out - 4'b0001;
                else  begin
                    out <= out;
                    direction <= direction;
                end
            end
            else begin
                if (direction) begin
                    if (out > max - 4'b0001)
                        out <= max - 4'b0001;
                    else out <= out + 4'b0001;
                    direction <= (out == max) ? 0 : 1;
                end
                else begin
                    if (out < min + 4'b0001)
                        out <= min + 4'b0001;
                    else out <= out - 4'b0001;
                    direction <= (out == min) ? 1 : 0;
                end 
            end
        end
    end
end
endmodule
