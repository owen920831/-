module motor(
    input clk,
    input rst,
    input [1:0]mode,
    output  [1:0]pwm,
    output [1:0] left,
    output [1:0] right
);

    reg [1:0] left, right;
    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    parameter Stop = 2'b00;
    parameter Forward = 2'b01;
    parameter Right = 2'b10;
    parameter Left = 2'b11;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
        case (mode)
            Stop: {left, right} = 4'b0000;
            Forward: {left, right} = 4'b0101;
            Right: {left, right} = 4'b0111;
            Left: {left, right} = 4'b1101;
        endcase

    end

    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    always @(*) begin
        case (mode)
            Stop: begin   
                next_left_motor = 10'd0;
                next_right_motor = 10'd0;
            end
            Forward: begin
                next_left_motor = 10'd750;
                next_right_motor = 10'd750;
            end
            Right: begin
                next_left_motor = 10'd750;
                next_right_motor = 10'd0;
            end
            Left: begin
                next_left_motor = 10'd0;
                next_right_motor = 10'd750;
            end
        endcase
    end

    assign pwm = {left_pwm, right_pwm};
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 32'd100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule
