
`timescale 1ns / 1ps
module test_Multiplier_4bit;
    reg [4-1:0] a, b;
    wire [8-1:0] p;

    Multiplier_4bit m1(a, b, p);

    initial begin
        a = 4'b0000;
        b = 4'b0000;
        repeat(2 ** 8) begin
            #1 {a, b} = {a, b}+1;
        end
        $finish;
    end
endmodule