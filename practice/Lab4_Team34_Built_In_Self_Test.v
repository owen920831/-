`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
    input clk;
    input rst_n;
    input scan_en;
    output scan_in;
    output scan_out;

    Many_To_One_LFSR M(clk, rst_n, scan_in);
    Scan_Chain_Design S(clk, rst_n, scan_in, scan_en, scan_out);
endmodule

module Many_To_One_LFSR(clk, rst_n, dout);
    input clk;
    input rst_n;
    output dout;

    reg [7:0] dff, next_dff;
    wire xor_in = dff[1] ^ dff[2] ^ dff[3] ^ dff[7];
    assign dout = dff[7];

    always @(posedge clk) begin
        if (!rst_n) begin
            dff <= 8'b10111101;
        end
        else begin
            dff <= next_dff;
        end
    end

    always @(*) begin
        next_dff = {dff[6:0], xor_in};
    end
endmodule

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;
    reg scan_out, next_scan_out;
    reg [7:0] dff, next_dff;
    wire [7:0] p;
    assign p = dff[3:0] * dff[7:4];

    always @(posedge clk) begin
        if (!rst_n) begin
            dff <= 8'd0;
            scan_out <= 1'b0;
        end
        else begin
            dff <= next_dff;
            scan_out <= next_scan_out;
        end
    end
    
    always @(*) begin
        if (scan_en) begin
            next_dff = {scan_in, dff[7:1]};
            next_scan_out = dff[0];
        end
        else begin
            next_dff =  {1'b0, p[7:1]};
            next_scan_out = p[0];
        end
    end
endmodule
