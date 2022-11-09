`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;

reg [7:0] cam[15:0];
reg [7:0] cmp;
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
        cmp[0] = 1'b1;
        found = 1'b1;
        i = 0;
    end else begin cmp[0] = 1'b0; end
    if (!found && cam[1] === din) begin
        cmp[1] = 1'b1;
        found = 1'b1;
        i = 1;
    end else begin cmp[1] = 1'b0; end
    if (!found && cam[2] === din) begin
        cmp[2] = 1'b1;
        found = 1'b1;
        i = 2;
    end else begin cmp[2] = 1'b0; end
    if (!found && cam[3] === din) begin
        cmp[3] = 1'b1;
        found = 1'b1;
        i = 3;
    end else begin cmp[3] = 1'b0; end
    if (!found && cam[4] === din) begin
        cmp[4] = 1'b1;
        found = 1'b1;
        i = 4;
    end else begin cmp[4] = 1'b0; end
    if (!found && cam[5] === din) begin
        cmp[5] = 1'b1;
        found = 1'b1;
        i = 5;
    end else begin cmp[5] = 1'b0; end
    if (!found && cam[6] === din) begin
        cmp[6] = 1'b1;
        found = 1'b1;
        i = 6;
    end else begin cmp[6] = 1'b0; end
    if (!found && cam[7] === din) begin
        cmp[7] = 1'b1;
        found = 1'b1;
        i = 7;
    end else begin cmp[7] = 1'b0; end
    if (!found && cam[8] === din) begin
        cmp[8] = 1'b1;
        found = 1'b1;
        i = 8;
    end else begin cmp[8] = 1'b0; end
    if (!found && cam[9] === din) begin
        cmp[9] = 1'b1;
        found = 1'b1;
        i = 9;
    end else begin cmp[9] = 1'b0; end
    if (!found && cam[10] === din) begin
        cmp[10] = 1'b1;
        found = 1'b1;
        i = 10;
    end else begin cmp[10] = 1'b0; end
    if (!found && cam[11] === din) begin
        cmp[11] = 1'b1;
        found = 1'b1;
        i = 11;
    end else begin cmp[11] = 1'b0; end
    if (!found && cam[12] === din) begin
        cmp[12] = 1'b1;
        found = 1'b1;
        i = 12;
    end else begin cmp[12] = 1'b0; end
    if (!found && cam[13] === din) begin
        cmp[13] = 1'b1;
        found = 1'b1;
        i = 13;
    end else begin cmp[13] = 1'b0; end
    if (!found && cam[14] === din) begin
        cmp[14] = 1'b1;
        found = 1'b1;
        i = 14;
    end else begin cmp[14] = 1'b0; end
    if (!found && cam[15] === din) begin
        cmp[15] = 1'b1;
        found = 1'b1;
        i = 15;
    end else begin cmp[15] = 1'b0; end
    /*
    dout_tmp = 4'b0000;
    found = 1'b0;
    hit_tmp = 1'b0;
    for (i = 0; i < 16; i = i + 1) begin
        if (cam[i] == din && !found) begin
            found = 1'b1;
            hit_tmp = 1'b1;
            dout_tmp = i;
        end
        else begin
            found = found;
            hit_tmp = hit_tmp;
            dout_tmp = dout_tmp;
        end
    end
    */
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
