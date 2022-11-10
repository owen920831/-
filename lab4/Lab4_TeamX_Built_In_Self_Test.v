`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, ans);
    input clk;
    input rst_n;
    output ans;

    reg [8-1:0] out;
    wire ans = out[7];
    wire out3_7, out1_2, xor_in;

    assign out3_7 = out[3] ^ out[7];
    assign out1_2 = out[1] ^ out[2];
    assign xor_in = out1_2 ^ out3_7;

    always @(negedge clk) begin
        if (!rst_n) begin
            out <= 8'b10111101;
        end
        else begin
            out <= {out[6:0], xor_in};
        end
    end
endmodule


`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;

    wire scan_out;
    reg [7:0] dff;
    wire [7:0] p;

    assign scan_out = dff[0];
    assign p = dff[3:0] * dff[7:4];

    always @(posedge clk) begin
        if (!rst_n) begin
            dff <= 8'b0;
        end
        else begin
            if (scan_en) begin
                dff <= {scan_in, dff[7:1]};             
            end
            else begin
                dff <= p;             
            end
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
