`timescale 1ns/1ps
`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg out;
    reg [8-1:0] dff;

    wire dff3_7, dff1_7, xor_in;

    assign dff3_7 = dff[3] ^ dff[7];
    assign dff1_7 = dff[1] ^ dff[7];
    assign xor_in = dff1_7 ^ dff3_7;

    always @(posedge clk) begin
        if (!rst_n) begin
            dff <= 8'b10111101;
        end
        else begin
            out <= dff[7];
            dff[7] <= dff[6];
            dff[6] <= dff[5];
            dff[5] <= dff[4];
            dff[4] <= dff[3];
            dff[3] <= dff[2];
            dff[2] <= dff[1];
            dff[1] <= dff[0];
            dff[0] <= xor_in;
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

    reg scan_out;
    reg [7:0] p, dff;


    always @(*) begin
        p = dff[3:0] * dff[7:4];
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            dff[0] <= 0;
            dff[1] <= 0;
            dff[2] <= 0;
            dff[3] <= 0;
            dff[4] <= 0;
            dff[5] <= 0;
            dff[6] <= 0;
            dff[7] <= 0;
            scan_out <= dff[0];
        end
        else begin
            if (scan_en) begin
                dff[0] <= dff[1];
                dff[1] <= dff[2];
                dff[2] <= dff[3];
                dff[3] <= dff[4];
                dff[4] <= dff[5];
                dff[5] <= dff[6];
                dff[6] <= dff[7];
                dff[7] <= scan_in;   
                scan_out <= dff[0];            
            end
            else begin
                dff[0] <= p[0];
                dff[1] <= p[1];
                dff[2] <= p[2];
                dff[3] <= p[3];
                dff[4] <= p[4];
                dff[5] <= p[5];
                dff[6] <= p[6];
                dff[7] <= p[7];   
                scan_out <= dff[0];             
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

    wire scan_in, scan_out;

    Many_To_One_LFSR m(clk, rst_n, scan_in);
    Scan_Chain_Design s(clk, rst_n, scan_in, scan_en, scan_out);

endmodule
