`timescale 1ns/1ps

module Content_Addressable_Memory_t;
    reg clk = 1;
    reg wen = 0, ren = 0;
    reg [3:0] addr = 0;
    reg [7:0] din = 0;
    wire [3:0] dout;
    wire hit;

    parameter cyc = 10;
    always #(cyc/2) clk = ~clk;

    Content_Addressable_Memory c(clk, wen, ren, din, addr, dout, hit);

    initial begin
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 1;
            addr = 3;
            din = 4;
        end
        @ (negedge clk) begin
            wen = 1;
            addr = 7;
            din = 8;
        end
        @ (negedge clk) begin
            wen = 1;
            addr = 15;
            din = 35;
        end
        @ (negedge clk) begin
            wen = 1;
            addr = 9;
            din = 8;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 1;
            addr = 0;
            din = 4;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 1;
            addr = 0;
            din = 8;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 1;
            addr = 0;
            din = 35;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 1;
            addr = 0;
            din = 87;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 1;
            addr = 0;
            din = 45;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 1;
            ren = 1;
            addr = 0;
            din = 8;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 1;
            ren = 1;
            addr = 0;
            din = 35;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
        @ (negedge clk) begin
            wen = 0;
            ren = 0;
            addr = 0;
            din = 0;
        end
    end
endmodule