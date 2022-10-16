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
        $dumpfile("fifo.vcd");
        $dumpvars("+all");
    end
        
    initial begin
        @(negedge clk)
        rst_n = 0;
        din = 8'd87;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd87;
        ren = 1'b1;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd87;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd85;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd0;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd77;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd66;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd89;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd89;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd66;
        ren = 1'b0;
        wen = 1'b1;
        @(negedge clk)
        rst_n = 1;
        din = 8'd0;
        ren = 1'b0;
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
