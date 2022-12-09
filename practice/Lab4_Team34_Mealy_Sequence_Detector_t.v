`timescale 1ns / 1ps


module test_Mealy_Sequence_Detector;
    reg clk, rst_n;
    reg in;
    wire dec;
    
    Mealy_Sequence_Detector MSD(clk, rst_n, in, dec);

    always #(1) clk = ~clk;
    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        in = 1'b0;

        #2 rst_n = 1'b1;
           in = 1'b0;
        #2 in = 1'b1;
        #2 in = 1'b1;
        #2 in = 1'b1;
        #2 in = 1'b0;
        #2 in = 1'b1;
        #2 in = 1'b1;
        #2 in = 1'b0;
        #2 in = 1'b1;
        #2 in = 1'b1;
        #2 in = 1'b0;
        #2 in = 1'b1;
        #2 in = 1'b0;
        #2 in = 1'b1;
        #2 in = 1'b0;
        #2 in = 1'b0;
        $finish;
    end
endmodule
