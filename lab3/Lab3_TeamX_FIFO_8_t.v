`timescale 1ns/1ps

module FIFO_8_t;
    
    reg clk = 0;
    reg rst_n = 0;
    reg ren = 1'b0;
    reg wen = 1'b0;
    reg [7:0] din = 8'd0;
    wire [7:0] dout;
    wire error;

    parameter cyc = 10;

    // generate clock.
    always#(cyc/2)clk = !clk;

    FIFO_8 fifo(
        .clk (clk),
        .ren (ren),
        .wen (wen),
        .din (din),
        .dout (dout),
        .error (error),
        .rst_n (rst_n)
    );


    initial begin
        @(negedge clk)
        rst_n = 0;
        din = 87;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 87;
        ren = 1;
        wen = 0;
        @(negedge clk)
        rst_n = 1;
        din = 86;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 85;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 84;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 83;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 82;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 81;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 80;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 79;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 78;
        ren = 0;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 10;
        ren = 1;
        wen = 1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b0;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd10;
        ren = 1'b1;
        wen = 1'b1;
        $finish;
    end
endmodule
