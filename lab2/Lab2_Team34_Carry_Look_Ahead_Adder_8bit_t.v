
`timescale 1ns / 1ps
module test_Carry_Look_Ahead_Adder_8bit;
    reg [8-1:0] a, b;
    reg c0;
    wire [8-1:0] s;
    wire c8;

    Carry_Look_Ahead_Adder_8bit m1(a, b, c0, s, c8);

    initial begin
        a = 8'b00000000;
        b = 8'b00000000;
        c0 = 1'b0;
        repeat(2 ** 8 ) begin
            repeat(2 ** 8) begin          
                #1
                c0 = c0 + 1'b1;
                #1
                c0 = 1'b0;
                b = b + 1'b1;
            end
            #1
            c0 = c0 + 1'b1;
            #1 
            b = 8'b00000000;
            c0 = 1'b0;
            a = a + 1'b1;
        end
        $finish;
    end
endmodule