`timescale 1ns/1ps
module Memory (clk, ren, wen, addr, din, dout);
    input clk;
    input ren, wen;
    input [7-1:0] addr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [8-1:0] dout;
    reg [8-1:0] my_memory [127:0];

    always @(posedge clk) begin
        if (ren)begin
            dout[8-1:0] <= my_memory[addr];
        end
        else begin
            dout <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (wen && !ren) begin
            my_memory[addr] <= din;
        end
        else begin
            my_memory[addr] <= my_memory[addr];
        end
    end
endmodule

module Sub_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
    input clk;
    input ren, wen;
    input [11-1:0] waddr;
    input [11-1:0] raddr;
    input [8-1:0] din;
    output [8-1:0] dout;

    wire [8-1:0] dout;
    wire [8-1:0] a_output, b_output, c_output, d_output;
    wire [7-1:0] addr;
    wire r0, r1, r2, r3, w0, w1, w2, w3;

    assign r0 = (ren && (raddr[8:7] == 2'b00)) ? 1 : 0;
    assign r1 = (ren && (raddr[8:7] == 2'b01)) ? 1 : 0;
    assign r2 = (ren && (raddr[8:7] == 2'b10)) ? 1 : 0;
    assign r3 = (ren && (raddr[8:7] == 2'b11)) ? 1 : 0;

    assign w0 = (wen && (waddr[8:7] == 2'b00)) ? 1 : 0;
    assign w1 = (wen && (waddr[8:7] == 2'b01)) ? 1 : 0;
    assign w2 = (wen && (waddr[8:7] == 2'b10)) ? 1 : 0;
    assign w3 = (wen && (waddr[8:7] == 2'b11)) ? 1 : 0;

    Memory sbank0(clk, r0, w0, addr, din, a_output);
    Memory sbank1(clk, r1, w1, addr, din, b_output);
    Memory sbank2(clk, r2, w2, addr, din, c_output);
    Memory sbank3(clk, r3, w3, addr, din, d_output);


    assign addr = (ren) ? raddr[6:0] : waddr[6:0];

    or o1 [7:0] (dout, a_output, b_output, c_output, d_output); //結果


endmodule


module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
    input clk;
    input ren, wen;
    input [11-1:0] waddr;
    input [11-1:0] raddr;
    input [8-1:0] din;
    output [8-1:0] dout;

    wire [8-1:0] dout;
    wire [8-1:0] a_output, b_output, c_output, d_output;
    wire r0, r1, r2, r3, w0, w1, w2, w3;

    assign r0 = (ren && (raddr[10:9] == 2'b00)) ? 1 : 0;
    assign r1 = (ren && (raddr[10:9] == 2'b01)) ? 1 : 0;
    assign r2 = (ren && (raddr[10:9] == 2'b10)) ? 1 : 0;
    assign r3 = (ren && (raddr[10:9] == 2'b11)) ? 1 : 0;

    assign w0 = (wen && (waddr[10:9] == 2'b00)) ? 1 : 0;
    assign w1 = (wen && (waddr[10:9] == 2'b01)) ? 1 : 0;
    assign w2 = (wen && (waddr[10:9] == 2'b10)) ? 1 : 0;
    assign w3 = (wen && (waddr[10:9] == 2'b11)) ? 1 : 0;

    Sub_Bank_Memory bank0(clk, r0, w0, waddr, raddr, din, a_output);
    Sub_Bank_Memory bank1(clk, r1, w1, waddr, raddr, din, b_output);
    Sub_Bank_Memory bank2(clk, r2, w2, waddr, raddr, din, c_output);
    Sub_Bank_Memory bank3(clk, r3, w3, waddr, raddr, din, d_output);

    or o1 [7:0] (dout, a_output, b_output, c_output, d_output); //結果
    
endmodule
