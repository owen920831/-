`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;

reg r2,r4,r8,r3;
reg [3:0] cnt2,cnt4,cnt8,cnt3;

always@(posedge clk)begin

    if(rst_n == 0)begin cnt2 <= 4'd0; cnt3 <= 4'd0; cnt4 <= 4'd0; cnt8 <= 4'd0; r2 <= 1'b1; r3 <= 1'b1; r4 <= 1'b1; r8 <= 1'b1;end
    else begin
        if(cnt2 == 4'd1)
        begin 
            r2 <= 1'b1; 
            cnt2 <= 4'd0; 
        end 
        else begin 
            cnt2 <= cnt2 + 4'b1; 
            r2 <= 1'b0; 
        end
        if(cnt3 == 4'd2)
        begin 
            r3 <= 1'b1; 
            cnt3 <= 4'd0; 
        end 
        else 
        begin 
            cnt3 <= cnt3 + 4'b1; 
            r3 <= 1'b0; 
        end
        if(cnt4 == 4'd3)
        begin 
            r4 <= 1'b1; 
            cnt4 <= 4'd0; 
        end 
        else 
        begin 
            cnt4 <= cnt4 + 4'b1; 
            r4 <= 1'b0; 
        end
        if(cnt8 == 4'd7)
        begin 
            r8 <= 1'b1; 
            cnt8 <= 4'd0; 
        end 
        else 
        begin 
            cnt8 <= cnt8 + 4'b1; 
            r8 <= 1'b0; 
        end
    end
    
end

assign clk1_2 = r2;
assign clk1_3 = r3;
assign clk1_4 = r4;
assign clk1_8 = r8;

MUX m1(clk1_2,clk1_4,clk1_8,clk1_3,sel[1:0],dclk);

endmodule

module MUX(clk2,clk4,clk8,clk3,sel,dclk);
input [1:0] sel;
input clk2,clk4,clk8,clk3;
output dclk;

reg dclk;

always@(*)begin
    if(sel == 2'b00) begin dclk = clk3; end
    else if(sel == 2'b01) begin dclk = clk2; end
    else if(sel == 2'b11) begin dclk = clk8; end
    else begin dclk = clk4; end
end

endmodule