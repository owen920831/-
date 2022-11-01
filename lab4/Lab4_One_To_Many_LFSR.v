`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [8-1:0] out;

    wire out1_7, out2_7, out3_7;

    assign out3_7 = out[3] ^ out[7];
    assign out1_7 = out[1] ^ out[7];
    assign out2_7 = out[2] ^ out[7];

    always @(posedge clk) begin
        if (!rst_n) begin
            out <= 8'b10111101;
        end
        else begin
            out[7] <= out[6];
            out[6] <= out[5];
            out[5] <= out[4];
            out[4] <= out3_7;
            out[3] <= out2_7;
            out[2] <= out1_7;
            out[1] <= out[0];
            out[0] <= out[7];
        end
    end

endmodule
