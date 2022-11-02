`timescale 1ns / 1ps
module test_Crossbar_2x2_4bit;
    reg [3:0] in1, in2;
    reg control;
    wire [3:0] out1, out2;

    Crossbar_2x2_4bit C0(in1, in2, control, out1, out2);

    initial begin
        in1 = 4'b0000;
        in2 = 4'b0000;
        control = 1'b0;
        repeat(2 ** 4) begin
            repeat(2 ** 4 - 1) begin          
                #1
                control = control + 1'b1;
                #1
                control = 1'b0;
                in2 = in2 + 1'b1;
            end
            #1
            control = control + 1'b1;
            #1 
            in2 = 4'b0000;
            control = 1'b0;
            in1 = in1 + 1'b1;
        end
        $finish;
    end
endmodule
