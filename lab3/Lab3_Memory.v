`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
    input clk;
    input ren, wen;
    input [7-1:0] addr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [8-1:0] dout;
    reg [8-1:0] my_memory [0:127];

    always @(posedge clk) begin
        if (ren)begin
            dout[8-1:0] <= my_memory[addr];
        end
        else begin
            dout <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (wen && !ren) begin
            my_memory[addr] <= din;
        end
        else begin
            my_memory[addr] <= my_memory[addr];
        end
    end
endmodule
