`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;

reg [7:0] cam[15:0];
reg [3:0] dout;
reg hit;
reg [3:0] dout_tmp;
reg hit_tmp;
reg found;
integer i;

always @(din) begin
    found = 1'b0;
    i = 0;
    if (!found && cam[0] === din) begin
        found = 1'b1;
        i = 0;
    end 
    else if (!found && cam[1] === din) begin
        found = 1'b1;
        i = 1;
    end
    else if (!found && cam[2] === din) begin
        found = 1'b1;
        i = 2;
    end 
    else if (!found && cam[3] === din) begin
        found = 1'b1;
        i = 3;
    end 
    else if (!found && cam[4] === din) begin
        found = 1'b1;
        i = 4;
    end 
    else if (!found && cam[5] === din) begin
        found = 1'b1;
        i = 5;
    end
    else if (!found && cam[6] === din) begin
        found = 1'b1;
        i = 6;
    end 
    else if (!found && cam[7] === din) begin
        found = 1'b1;
        i = 7;
    end 
    else if (!found && cam[8] === din) begin
        found = 1'b1;
        i = 8;
    end 
    else if (!found && cam[9] === din) begin
        found = 1'b1;
        i = 9;
    end 
    else if (!found && cam[10] === din) begin
        found = 1'b1;
        i = 10;
    end 
    else if (!found && cam[11] === din) begin
        found = 1'b1;
        i = 11;
    end 
    else if (!found && cam[12] === din) begin
        found = 1'b1;
        i = 12;
    end 
    else if (!found && cam[13] === din) begin
        found = 1'b1;
        i = 13;
    end 
    else if (!found && cam[14] === din) begin
        found = 1'b1;
        i = 14;
    end 
    else if (!found && cam[15] === din) begin
        found = 1'b1;
        i = 15;
    end 
    else begin found = 1'b0; end
end

always @(posedge clk) begin
    if (wen && !ren) begin
        cam[addr] <= din;
        dout <= 4'b0000;
        hit <= 1'b0;
    end
    else if (ren) begin
        dout <= i;
        hit <= found == 1'b1 ? 1'b1 : 1'b0;
    end
    else begin
        dout <= 4'b0000;
        hit <= 1'b0; 
    end
end
endmodule
