`timescale 1ns/1ps

module Decode_And_Execute_t;
reg [3:0] rs = 4'b0000;
reg [3:0] rt = 4'b0000;
reg [2:0] sel = 3'b110;
wire [3:0] rd;

Decode_And_Execute d1 (
    .rs(rs),
    .rt(rt),
    .sel(sel),
    .rd(rd)
);

initial begin
    repeat (2 ** 4) begin
        repeat (2 ** 4) begin
            #1
            rt = rt + 1'b1;
        end
        #1
        rt = 4'b0000;
        rs = rs + 1'b1;
    end
    #1 $finish;
end
endmodule