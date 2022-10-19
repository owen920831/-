`timescale 1ns/1ps
module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
    input clk;
    input rst_n;
    input wen, ren;
    input [8-1:0] din;
    output [8-1:0] dout;
    output error;

    reg [8-1:0] memory [0:8];
    reg [3:0] front, rear;
    reg [8-1:0] dout;
    reg error;
    reg [3:0] next_front, next_rear;
    reg [8-1:0] dout;

    always @(*) begin
        next_front = front+1;
        next_rear = rear+1;
        if (next_front === 4'b1001)begin
            next_front = 0;
        end
        if (next_rear === 4'b1001)begin
            next_rear = 0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n)begin
            dout <= 0;
            error <= 0;
            front <= 0;
            rear <= 0;
        end
        else begin
            if (ren) begin
                if (front == rear) begin
                    front <= front;
                    rear <= rear;
                    error <= 1;
                    dout <= 0;
                end
                else begin
                    front <= next_front;
                    rear <= rear;
                    error <= 0;
                    dout <= memory[next_front];
                end
            end
            else if (wen && !ren)begin
                if (next_rear == front) begin
                    front <= front;
                    rear <= rear;
                    error <= 1;
                    dout <= 0;
                end
                else begin
                    front <= front;
                    rear <= next_rear;
                    memory[next_rear] = din;
                    error <= 0;
                    dout <= 0;
                end
            end
            else begin
                if (front == rear) begin
                    error <= 1;
                end 
                else begin
                    error <= 0;
                end
                front <= front;
                rear <= rear;
                dout <= 0;
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

    reg [1:0] counter = 0;
    wire [1:0] next_counter;
    reg r0 = 0, r1 = 0, r2 = 0, r3 = 0;
    wire [7:0] a_output, b_output, c_output, d_output;
    reg valid = 0, tmp = 0;
    reg [8-1:0] dout;
    wire a_error, b_error, c_error, d_error;

    assign next_counter = counter + 1;

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
        if (!valid) begin
            dout = 0;
        end
        else begin
            if (counter == 2'b01) dout = a_output;
            else if (counter == 2'b10) dout = b_output;
            else if (counter == 2'b11) dout = c_output;
            else dout = d_output;
        end
    end

    always @(*) begin
        if (counter == 2'b01) valid = !a_error && !tmp;
        else if (counter == 2'b10) valid = !b_error && !tmp; 
        else if (counter == 2'b11) valid = !c_error && !tmp; 
        else valid = !d_error && !tmp; 
    end

    always @(*) begin
        r0 = 0; r1 = 0; r2 = 0; r3 = 0;
        if (!wen[0] && (counter == 2'b00)) r0 = 1;
        else if (!wen[1] && (counter == 2'b01)) r1 = 1;
        else if (!wen[2] && (counter == 2'b10)) r2 = 1;
        else if (!wen[3] && (counter == 2'b11)) r3 = 1;
        else begin
            r0 = 0; r1 = 0; r2 = 0; r3 = 0;
        end
    end

    FIFO_8 f0(clk, rst_n, wen[0], r0, a, a_output, a_error);
    FIFO_8 f1(clk, rst_n, wen[1], r1, b, b_output, b_error);
    FIFO_8 f2(clk, rst_n, wen[2], r2, c, c_output, c_error);
    FIFO_8 f3(clk, rst_n, wen[3], r3, d, d_output, d_error);

endmodule
