`timescale 1ns/1ps

module Built_In_Self_Test_t();
    reg clk, rst_n, scan_en;
    wire scan_in, scan_out;

    Built_In_Self_Test m0 (
        .clk(clk),
        .rst_n(rst_n),
        .scan_en(scan_en),
        .scan_in(scan_in),
        .scan_out(scan_out)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; scan_en = 0;
        #20
        rst_n = 1; scan_en = 1;
        #160 scan_en = 0;
        #20 scan_en = 1;
        #160 $finish(); 
    end
endmodule