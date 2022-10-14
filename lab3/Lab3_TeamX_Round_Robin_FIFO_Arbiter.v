`timescale 1ns/1ps
module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
    input clk;
    input rst_n;
    input wen, ren;
    input [8-1:0] din;
    output [8-1:0] dout;
    output error;

    reg [8-1:0] error_x;
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
                    dout <= error_x;
                end
                else begin
                    front <= next_front;
                    rear <= rear;
                    error <= 0;
                    dout <= memory[next_front];
                end
            end
            else if (wen && !ren)begin
                $display("hh %b %b %b %b", next_rear, rear, next_front, front);
                if (next_rear == front) begin
                    front <= front;
                    rear <= rear;
                    error <= 1;
                    dout <= error_x;
                end
                else begin
                    front <= front;
                    rear <= next_rear;
                    memory[next_rear] = din;
                    error <= 0;
                    dout <= error_x;
                end
            end
            else begin
                front <= front;
                rear <= rear;
                error <= 0;
                dout <= error_x;
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

    reg [2:0] counter; //算現在是要read abcd
    reg read_a, read_b, read_c, read_d; 
    reg [8-1:0] dout;
    wire [8-1:0] a_output, b_output, c_output, d_output;
    reg vaild;
    wire [2:0] next_counter;
    wire error_a, error_b, error_c, error_d;


    assign next_counter = counter+1;

    FIFO_8 inputa(clk, rst_n, wen[0], read_a, a, a_output, error_a);
    FIFO_8 inputb(clk, rst_n, wen[1], read_b, b, b_output, error_b);
    FIFO_8 inputc(clk, rst_n, wen[2], read_c, c, c_output, error_c);
    FIFO_8 inputd(clk, rst_n, wen[3], read_d, d, d_output, error_d);

    always @(posedge clk) begin
        counter <= next_counter;
        if (!rst_n) begin
            counter <= 0;
            dout <= 0;
            vaild <= 0;
            read_a <= 0;
            read_b <= 0;
            read_c <= 0;
            read_d <= 0;
        end
        else begin
            case (counter)
                2'b01:begin
                    read_a <= 1;
                    read_b <= 0;
                    read_c <= 0;
                    read_d <= 0;
                    if (error_a || wen[0]) begin
                        vaild <= 0;
                        dout <= 0;
                    end
                    else begin
                        vaild <= 1;
                        dout <= a_output;
                    end
                end
                2'b10:begin
                    read_a <= 0;
                    read_b <= 1;
                    read_c <= 0;
                    read_d <= 0;
                    if (error_b || wen[1]) begin
                        vaild <= 0;
                        dout <= 0;
                    end
                    else begin
                        vaild <= 1;
                        dout <= b_output;
                    end
                end
                2'b11:begin
                    read_a <= 0;
                    read_b <= 0;
                    read_c <= 1;
                    read_d <= 0;
                    if (error_c || wen[2]) begin
                        vaild <= 0;
                        dout <= 0;
                    end
                    else begin
                        vaild <= 1;
                        dout <= c_output;
                    end
                end
                2'b00:begin
                    read_a <= 0;
                    read_b <= 0;
                    read_c <= 0;
                    read_d <= 1;
                    if (error_d || wen[3]) begin
                        vaild <= 0;
                        dout <= 0;
                    end
                    else begin
                        vaild <= 1;
                        dout <= d_output;
                    end
                end
            endcase
        end
    end



endmodule
