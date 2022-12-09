`timescale 1ns/1ps

module cam;
    reg clk, wen, ren;
    reg [3:0] addr;
    reg [7:0] din;
    wire [3:0] dout;
    wire hit;

    always #1 clk = ~clk;

    Content_Addressable_Memory cam1(clk, wen, ren, din, addr, dout, hit);

    initial begin
        clk = 1'b0;
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'b0;
        din = 8'b0;

        //==============================  Basic function
        repeat(4) begin
            #2
            wen = 1'b1;
            din = din + 8'b1;
            addr = addr + 4'b1;
        end 
        #2
        din = 8'b1;
        ren = 1'b1;
        addr = addr + 4'b1;
        repeat(3) begin
            #2
            din = din + 8'b1;
            addr = addr + 4'b1;
        end
        //==============================

        //==============================  Test the rewrite function
        #2
        ren = 1'b0;
        addr = 4'b1;
        din = din + 8'b1;
        repeat(3) begin
            #2
            din = din + 8'b1;
            addr = addr + 4'b1;
        end
        #2
        wen = 1'b0;
        ren = 1'b1;
        din = 4'd1;
        addr = addr + 4'b1;
        repeat(7) begin
            #2
            din = din + 8'b1;
            addr = addr + 4'b1;
        end
        //==============================


        //==============================  Test if multiple address stored the same data
        #2
        wen = 1'b1;
        ren = 1'b0;
        din = 4'd10;
        addr = 8'b1;
        repeat(3) begin
            #2
            addr = addr + 8'b1;
        end
        #2
        ren = 1'b1;
        addr = addr + 8'b1;
        repeat(3) begin
            #2
            addr = addr + 8'b1;
        end

        //==============================
        #2 
        $finish;
    end
endmodule