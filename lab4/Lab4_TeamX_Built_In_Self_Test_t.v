`timescale 1ns / 1ps


module test_Built_In_Self_Test;
    reg clk;
    reg rst_n;
    reg scan_en;
    wire scan_in;
    wire scan_out;


    Built_In_Self_Test B(clk, rst_n, scan_en, scan_in, scan_out);

    always #(1) clk = ~clk;
    initial begin
        clk = 1'b0;
        rst_n = 1'b1;
        scan_en = 1'b0;
        #2 rst_n = 1'b0;
        #2 rst_n = 1'b1;
           scan_en = 1'b1;
        #16 scan_en = 1'b0;
        #2 scan_en = 1'b1;
        #16 scan_en = 1'b0;
        #3 scan_en = 1'b1;
        #13 $finish;
    end
endmodule
