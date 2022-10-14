`timescale 1ns/1ps
module Memory (clk, ren, wen, addr, din, dout);
    input clk;
    input ren, wen;
    input [7-1:0] addr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [8-1:0] dout;
    reg [8-1:0] my_memory [127:0];

    always @(posedge clk) begin
        if (ren)begin
            dout[8-1:0] <= my_memory[addr];
        end
        else begin
            dout <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (wen && !ren) begin
            my_memory[addr] <= din;
        end
        else begin
            my_memory[addr] <= my_memory[addr];
        end
    end
endmodule

module Sub_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
    input clk;
    input ren, wen;
    input [11-1:0] waddr;
    input [11-1:0] raddr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [8-1:0] dout, tmp_out, a_in, b_in, c_in, d_in;
    wire [8-1:0] a_output, b_output, c_output, d_output;
    reg [9-1:0] addr;

    Memory sbank0(clk, ren, wen, addr, a_in, a_output);
    Memory sbank1(clk, ren, wen, addr, b_in, b_output);
    Memory sbank2(clk, ren, wen, addr, c_in, c_output);
    Memory sbank3(clk, ren, wen, addr, d_in, d_output);

    always @(*) begin
        tmp_out = a_output ^ b_output ^ c_output ^ d_output;
        a_in = 0;
        b_in = 0;
        c_in = 0;
        d_in = 0;
    end

    always @(posedge clk) begin
        dout <= tmp_out;
        if (ren) begin
            if (wen) begin
                case(waddr[8:7])
                    2'b00 : begin
                        a_in <= din;   
                        addr <= waddr[6:0];                      
                    end
                    2'b01 : begin
                        b_in <= din; 
                        addr <= waddr[6:0];    
                    end
                    2'b10 : begin
                        c_in <= din; 
                        addr <= waddr[6:0];    
                    end
                    2'b11 : begin
                        d_in <= din;
                        addr <= waddr[6:0];    
                    end
                endcase
            end
            case(raddr[8:7])
                2'b00 : begin
                    a_in <= din; 
                    addr <= raddr[6:0];                              
                end
                2'b01 : begin
                    b_in <= din;
                    addr <= raddr[6:0];     
                end
                2'b10 : begin
                    c_in <= din; 
                    addr <= raddr[6:0];    
                end
                2'b11 : begin
                    d_in <= din;
                    addr <= raddr[6:0];    
                end
            endcase
        end
        else begin
            case(waddr[8:7])
                2'b00 : begin
                    a_in <= din;  
                    addr <= waddr[6:0];                             
                end
                2'b01 : begin
                    b_in <= din; 
                    addr <= waddr[6:0];    
                end
                2'b10 : begin
                    c_in <= din; 
                    addr <= waddr[6:0];    
                end
                2'b11 : begin
                    d_in <= din;
                    addr <= waddr[6:0];    
                end
            endcase
        end
    end
endmodule


module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
    input clk;
    input ren, wen;
    input [11-1:0] waddr;
    input [11-1:0] raddr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [8-1:0] dout, tmp_out, a_in, b_in, c_in, d_in;
    wire [8-1:0] a_output, b_output, c_output, d_output;
    reg [11-1:0] addr;

    Sub_Bank_Memory bank0(clk, ren, wen, waddr, raddr, a_in, a_output);
    Sub_Bank_Memory bank1(clk, ren, wen, waddr, raddr, b_in, b_output);
    Sub_Bank_Memory bank2(clk, ren, wen, waddr, raddr, c_in, c_output);
    Sub_Bank_Memory bank3(clk, ren, wen, waddr, raddr, d_in, d_output);

    always @(*) begin
        tmp_out = a_output ^ b_output ^ c_output ^ d_output;
        a_in = 0;
        b_in = 0;
        c_in = 0;
        d_in = 0;
    end

    always @(posedge clk) begin
        dout <= tmp_out;
        if (ren) begin
            if (wen) begin
                case(waddr[10:9])
                    2'b00 : begin
                        a_in <= din;                        
                    end
                    2'b01 : begin
                        b_in <= din;   
                    end
                    2'b10 : begin
                        c_in <= din;    
                    end
                    2'b11 : begin
                        d_in <= din;
                    end
                endcase
            end
            case(raddr[10:9])
                2'b00 : begin
                    a_in <= din;                            
                end
                2'b01 : begin
                    b_in <= din;  
                end
                2'b10 : begin
                    c_in <= din;    
                end
                2'b11 : begin
                    d_in <= din;  
                end
            endcase
        end
        else begin
            case(waddr[10:9])
                2'b00 : begin
                    a_in <= din;                           
                end
                2'b01 : begin
                    b_in <= din;    
                end
                2'b10 : begin
                    c_in <= din;    
                end
                2'b11 : begin
                    d_in <= din;   
                end
            endcase
        end
    end
endmodule
