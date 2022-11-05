module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
    input clk;
    input ren, wen;
    input [11-1:0] waddr;
    input [11-1:0] raddr;
    input [8-1:0] din;
    output [8-1:0] dout;

    wire w0, w1, w2, w3, r0, r1, r2, r3;
    wire [7:0] a_dout, b_dout, c_dout, d_dout;
    wire [7:0] dout;

    assign r0 = (ren && (raddr[10:9] == 2'b00))? 1:0;
    assign r1 = (ren && (raddr[10:9] == 2'b01))? 1:0;
    assign r2 = (ren && (raddr[10:9] == 2'b10))? 1:0;
    assign r3 = (ren && (raddr[10:9] == 2'b11))? 1:0;

    assign w0 = (wen && (waddr[10:9] == 2'b00))? 1:0;
    assign w1 = (wen && (waddr[10:9] == 2'b01))? 1:0;
    assign w2 = (wen && (waddr[10:9] == 2'b10))? 1:0;
    assign w3 = (wen && (waddr[10:9] == 2'b11))? 1:0;

    sub_Bank_Memory s0(clk, r0, w0, waddr, raddr, din, a_dout);
    sub_Bank_Memory s1(clk, r1, w1, waddr, raddr, din, b_dout);
    sub_Bank_Memory s2(clk, r2, w2, waddr, raddr, din, c_dout);
    sub_Bank_Memory s3(clk, r3, w3, waddr, raddr, din, d_dout);

    or o1 [7:0] (dout, a_dout, b_dout, c_dout, d_dout);
endmodule

module sub_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
    input clk;
    input ren, wen;
    input [11-1:0] waddr;
    input [11-1:0] raddr;
    input [8-1:0] din;
    output [8-1:0] dout;

    wire w0, w1, w2, w3, r0, r1, r2, r3;
    wire [7:0] a_dout, b_dout, c_dout, d_dout;
    wire [7:0] dout;
    wire [6:0] addr0, addr1, addr2, addr3;

    assign r0 = (ren && (raddr[8:7] == 2'b00))? 1:0;
    assign r1 = (ren && (raddr[8:7] == 2'b01))? 1:0;
    assign r2 = (ren && (raddr[8:7] == 2'b10))? 1:0;
    assign r3 = (ren && (raddr[8:7] == 2'b11))? 1:0;

    assign w0 = (wen && (waddr[8:7] == 2'b00))? 1:0;
    assign w1 = (wen && (waddr[8:7] == 2'b01))? 1:0;
    assign w2 = (wen && (waddr[8:7] == 2'b10))? 1:0;
    assign w3 = (wen && (waddr[8:7] == 2'b11))? 1:0;

    assign addr0 = (ren)? raddr[6:0]:waddr[6:0];
    assign addr1 = (ren)? raddr[6:0]:waddr[6:0];
    assign addr2 = (ren)? raddr[6:0]:waddr[6:0];
    assign addr3 = (ren)? raddr[6:0]:waddr[6:0];

    Memory s0(clk, r0, w0, addr0, din, a_dout);
    Memory s1(clk, r1, w1, addr1, din, b_dout);
    Memory s2(clk, r2, w2, addr2, din, c_dout);
    Memory s3(clk, r3, w3, addr3, din, d_dout);

    or o1 [7:0] (dout, a_dout, b_dout, c_dout, d_dout);  
endmodule

module Memory (clk, ren, wen, addr, din, dout);
    input clk;
    input ren, wen;
    input [6:0] addr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [7:0] memory [0:127];
    reg [7:0] dout;

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
            my_memory[addr] <= din[8-1:0];
        end
        else begin
            my_memory[addr] <= my_memory[addr];
        end
    end
endmodule
