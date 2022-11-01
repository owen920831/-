`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
    input clk;
    input rst_n;
    input wen, ren;
    input [8-1:0] din;
    output [8-1:0] dout;
    output error;

    reg [7:0] memory [8:0];
    reg [3:0] rear, front;
    reg [3:0] next_front, next_rear;
    reg [8-1:0] error_out;
    reg [8-1:0] dout;

    always @(*) begin
        next_front = front+1;
        next_rear = rear+1;
        if (next_front === 4'b1001) begin
            next_front = 0;
        end
        if (next_rear === 4'b1001) begin
            next_rear = 0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            dout <= 0;
            front <= 0;
            rear <= 0;
            error <= 0;
        end    
        else begin
            if (ren)begin
                if (rear == front) begin
                    dout <= error_out;
                    front <= front;
                    rear <= rear;
                    error <= 1;
                end
                else begin
                    dout <= memory[next_rear];
                    front <= front;
                    rear <= next_rear;
                    error <= 0;
                end
            end
            else if (wen) begin
                if (rear == next_front) begin
                    dout <= error_out;
                    front <= front;
                    rear <= rear;
                    error <= 1;
                end
                else begin
                    dout <= error_out;
                    front <= next_front;
                    rear <= rear;
                    error <= 0;
                    memory[next_front] = din;
                end               
            end
            else begin
                dout <= error_out;
                front <= front;
                rear <= rear;
                error <= 0;              
            end
        end
    end

endmodule

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
    input clk;
    input rst_n;
    input [4-1:0] wen;
    input [8-1:0] a, b, c, d;
    output [8-1:0] dout;
    output valid;

    reg [1:0] counter;
    wire [1:0] next_counter;
    reg tmp_vaild;
    wire [8-1:0] a_dout, b_dout, c_dout, d_dout;
    wire a_error, b_error, c_erroe, d_error;
    reg a_ren, b_ren, c_ren, d_ren;

    assign next_counter = counter + 1; 

    FIFO_8 f1(clk, rst_n, wen[0], a_ren, a, a_dout, a_error);
    FIFO_8 f2(clk, rst_n, wen[1], b_ren, b, b_dout, b_error);
    FIFO_8 f3(clk, rst_n, wen[2], c_ren, c, c_dout, c_error);
    FIFO_8 f4(clk, rst_n, wen[3], d_ren, d, d_dout, d_error);

    always @(posedge clk) begin
        counter <= next_counter;
        if (!rst_n) begin
            counter <= 0;
            dout <= 0;
            valid <= 0;
        end
        else begin
            if (counter == 2'b00 && !wen[0]) tmp <= 0;
            else if (counter == 2'b01 && !wen[1]) tmp <= 0;
            else if (counter == 2'b10 && !wen[2]) tmp <= 0;
            else if (counter == 2'b11 && !wen[3]) tmp <= 0;
            else tmp <= 1; 
        end
        
    end

    always @(*) begin
        if (counter == 2'b01 && valid) dout = a_dout;
        else if (counter == 2'b10 && vaild) dout = b_dout;
        else if (counter == 2'b11 && vaild) dout = c_dout;
        else if (counter == 2'b00 && vaild) dout = d_dout;
        else dout = 0;
    end

    always @(*) begin
        a_ren = (!wen[0] && (counter == 2'b00)) ? 1 : 0;
        b_ren = (!wen[1] && (counter == 2'b01)) ? 1 : 0;
        c_ren = (!wen[2] && (counter == 2'b10)) ? 1 : 0;
        d_ren = (!wen[3] && (counter == 2'b11)) ? 1 : 0;
    end

    always @(*) begin
        if (!rst_n) begin
            valid = 0;
        end
        else begin
            if (counter == 2'b01) valid = !a_error && !tmp;
            else if (counter == 2'b10) valid = !b_error && !tmp; 
            else if (counter == 2'b11) valid = !c_error && !tmp; 
            else valid = !d_error && !tmp; 
        end
    end
endmodule
