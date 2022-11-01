`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [8-1:0] out;

    wire out3_7, out1_7, xor_in;

    assign out3_7 = out[3] ^ out[7];
    assign out1_7 = out[1] ^ out[7];
    assign xor_in = out1_7 ^ out3_7;

    always @(posedge clk) begin
        if (!rst_n) begin
            out <= 8'b10111101;
        end
        else begin
            out[7] <= out[6];
            out[6] <= out[5];
            out[5] <= out[4];
            out[4] <= out[3];
            out[3] <= out[2];
            out[2] <= out[1];
            out[1] <= out[0];
            out[0] <= xor_in;
        end
    end
endmodule

