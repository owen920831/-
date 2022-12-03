`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
    input clk;
    input wen, ren;
    input [7:0] din;
    input [3:0] addr;
    output reg [3:0] dout;
    output reg hit;
    
    reg [7:0] cam [15:0];

    always @(posedge clk) begin
        if (ren)begin
            if (cam[0] == din) begin
                dout <= 4'd0;
                hit <= 4'b1;
            end
            else if (cam[1] == din) begin
                dout <= 4'd1;
                hit <= 4'b1;
            end
            else if (cam[2] == din) begin
                dout <= 4'd2;
                hit <= 4'b1;
            end
            else if (cam[3] == din) begin
                dout <= 4'd3;
                hit <= 4'b1;
            end
            else if (cam[4] == din) begin
                dout <= 4'd4;
                hit <= 4'b1;
            end
            else if (cam[5] == din) begin
                dout <= 4'd5;
                hit <= 4'b1;
            end
            else if (cam[6] == din) begin
                dout <= 4'd6;
                hit <= 4'b1;
            end
            else if (cam[7] == din) begin
                dout <= 4'd7;
                hit <= 4'b1; 
            end
            else if (cam[8] == din) begin
                dout <= 4'd8;
                hit <= 4'b1;
            end
            else if (cam[9] == din) begin
                dout <= 4'd9;
                hit <= 4'b1;
            end
            else if (cam[10] == din) begin
                dout <= 4'd10;
                hit <= 4'b1;
            end
            else if (cam[11] == din) begin
                dout <= 4'd11;
                hit <= 4'b1; 
            end
            else if (cam[12] == din) begin
                dout <= 4'd12;
                hit <= 4'b1;
            end
            else if (cam[13] == din) begin
                dout <= 4'd13;
                hit <= 4'b1;
            end
            else if (cam[14] == din) begin
                dout <= 4'd14;
                hit <= 4'b1;                
            end
            else if (cam[15] == din) begin
                dout <= 4'd15;
                hit <= 4'b1;
            end
            else begin
                
            end
        end
        else if (wen) begin
            cam[addr] <= din;
            dout <= 0;
            hit <= 0;
        end
        else begin
            cam[addr] <= cam[addr];
            dout <= 0;
            hit <= 0; 
        end
    end

endmodule
