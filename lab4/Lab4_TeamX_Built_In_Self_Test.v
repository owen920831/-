`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output out;
    reg [8-1:0] dff;
    wire out;
    wire dff3_7, dff1_7, xor_in;

    assign dff3_7 = dff[3] ^ dff[7];
    assign dff1_2 = dff[1] ^ dff[2];
    assign xor_in = dff1_2 ^ dff3_7;

    assign out = dff[7];

    always @(posedge clk) begin
        if (!rst_n) begin
            dff <= 8'b10111101;
        end
        else begin
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
            dff <= 8'b0;
            scan_out <= dff[0];
        end
        else begin
            if (scan_en) begin
                dff <= {scan_in, dff[7:1]}; 
                scan_out <= dff[0];            
            end
            else begin
                dff <= {scan_in, p[7:1]};  
                scan_out <= p[0];             
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
