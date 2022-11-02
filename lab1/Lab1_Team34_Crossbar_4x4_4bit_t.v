`timescale 1ns / 1ps

module test_Crossbar_4x4_4bit;
reg [3:0] in1, in2, in3, in4;
reg [4:0] control;
wire [3:0] out1, out2, out3, out4;

Crossbar_4x4_4bit C(in1, in2, in3, in4, out1, out2, out3, out4, control);

initial begin
    in1 = 4'b0001;
    in2 = 4'b0010;
    in3 = 4'b0100;
    in4 = 4'b1000;
    control = 5'b00000;
    repeat(2 ** 5) begin
        #10
        control = control + 1'b1;
    end
    $finish;
end;
endmodule
