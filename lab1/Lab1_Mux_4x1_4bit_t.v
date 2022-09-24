`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/24 17:29:12
// Design Name: 
// Module Name: Dmux_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module test_Dmux_1x4_4bit;
reg [3:0] in;
reg [1:0] sel;
wire [3:0] a, b, c, d;

Dmux_1x4_4bit D1(in, a, b, c, d, sel);

initial begin
    in = 4'd0;
    sel = 2'd0;
    repeat(2 ** 4)begin
        repeat( 2 ** 2 - 1)begin
            #10  sel = sel + 1'b1;
        end
        #10  sel = 2'd0;
        in  = in + 1'b1;
    end
    #10 $finish;
end
endmodule
