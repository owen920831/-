`timescale 1ns/1ps


module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [8-1:0] out;

    wire out3_7, out1_2, xor_in;

    assign out3_7 = out[3] ^ out[7];
    assign out1_2 = out[1] ^ out[2];
    assign xor_in = out1_2 ^ out3_7;

    always @(posedge clk) begin
        if (!rst_n) begin
            out <= 8'b10111101;
        end
        else begin
            out <= {out[6:0], xor_in};
        end
    end
endmodule



