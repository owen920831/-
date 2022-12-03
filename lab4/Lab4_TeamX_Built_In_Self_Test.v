`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, ans);
    input clk;
    input rst_n;
    output ans;

    reg [8-1:0] out;
    wire ans = out[7];
    wire xor_in = out[1] ^ out[2] ^ out[3] ^ out[7];

    always @(negedge clk) begin
        if (!rst_n) begin
            out <= 8'b10111101;
        end
        else begin
            out <= {out[6:0], xor_in};
        end
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
    wire [7:0] p = dff[3:0] * dff[7:4];

    always @(posedge clk) begin
        if (!rst_n) begin
            dff <= 8'b0;
            scan_out <= 0;
        end
        else begin
            dff <= next_dff;
            scan_out <= next_scan_out;
        end
    end

    always @(*) begin
        if(scan_en)begin
            dff[7:0] = {scan_in, dff[7:1]};
            next_out = dff[0];
        end
        else begin
            next_dff[7:0] = {1'b0, p[7:1]}; 
            next_out = p[0];
        end 
    end

endmodule

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
    input clk;
    input rst_n;
    input scan_en;
    output scan_in;
    output scan_out;

    Many_To_One_LFSR m(clk, rst_n, scan_in);
    Scan_Chain_Design s(clk, rst_n, scan_in, scan_en, scan_out);
endmodule
