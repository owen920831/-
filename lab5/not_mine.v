`timescale 1ns/1ps

module fpga1(clk, PS2_DATA, PS2_CLK, pmod_1, pmod_2, pmod_4/*, sw, light*/);
    
    input clk;
    inout PS2_DATA;
    inout PS2_CLK;
    output pmod_1, pmod_2, pmod_4;
//    output reg [14:0] sw;
//    output light;
//    reg [14:0] sw = 1;

    parameter [8:0] KEY_CODES_W = 29; 
    parameter [8:0] KEY_CODES_S = 27; 
    parameter [8:0] KEY_CODES_R = 45; 
    parameter [8:0] KEY_CODES_F = 43; 
    parameter [8:0] ENTER = 90;

    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;

    reg [6:0] cnt, next_cnt;
    reg dir, next_dir;
    reg [30:0] speed, next_speed;
    reg fast, next_fast;
    wire rst;
    wire [31:0] sound [28:0];
    wire [31:0] freq;
    wire [30:0] ONE_SECOND;

    assign pmod_2 = 1'd1;
    assign pmod_4 = 1'd1;
    assign freq = sound[cnt];
    assign rst = (been_ready && key_down[last_change] && last_change == ENTER);
    assign ONE_SECOND = (fast) ? 50000000 : 100000000;
    //sound=========================
    assign sound[0] = 262;
    assign sound[1] = 294;
    assign sound[2] = 330;
    assign sound[3] = 349;
    assign sound[4] = 392;
    assign sound[5] = 440;
    assign sound[6] = 494;
    assign sound[7] = 262 << 1;
    assign sound[8] = 294 << 1;
    assign sound[9] = 330 << 1;
    assign sound[10] = 349 << 1;
    assign sound[11] = 392 << 1;
    assign sound[12] = 440 << 1;
    assign sound[13] = 494 << 1;
    assign sound[14] = 262 << 2;
    assign sound[15] = 294 << 2;
    assign sound[16] = 330 << 2;
    assign sound[17] = 349 << 2;
    assign sound[18] = 392 << 2;
    assign sound[19] = 440 << 2;
    assign sound[20] = 494 << 2;
    assign sound[21] = 262 << 3; //c7
    assign sound[22] = 294 << 3;
    assign sound[23] = 330 << 3;
    assign sound[24] = 349 << 3;
    assign sound[25] = 392 << 3;
    assign sound[26] = 440 << 3;
    assign sound[27] = 494 << 3;
    assign sound[28] = 262 << 4;
    //==============================

    KeyboardDecoder key_de(
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(0),
        .clk(clk)
    );

    PWM_gen pwm_0 (
        .clk(clk),
        .reset(rst),
        .freq(freq),
        .duty(10'd512),
        .PWM(pmod_1)
    );

    //speed=========================
    always @(*) begin
        if (speed == ONE_SECOND) next_speed = 0;
        else if (fast) next_speed = (speed + 1 > 50000000) ? 50000000 : speed + 1;
        else next_speed = (speed + 1 > 100000000) ? 100000000 : speed + 1;
    end
    always @(posedge clk) begin
        if (rst) begin
            speed <= 0;
        end else speed <= next_speed;
    end
    //==============================

    //counter=======================
    always @(*) begin
        if (speed == ONE_SECOND) begin
            if (cnt == 28) begin
                if (dir) next_cnt = cnt;
                else next_cnt = cnt - 1;
            end else if (cnt == 0) begin
                if (dir) next_cnt = cnt + 1;
                else next_cnt = cnt;
            end else begin
                if (dir) next_cnt = cnt + 1;
                else next_cnt = cnt - 1;
            end
        end else next_cnt = cnt;
    end

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
        end else cnt <= next_cnt;
    end
    //==============================

    //dir===========================
    always @(*) begin
        if (been_ready && key_down[last_change] == 1'd1) begin
            if (last_change == KEY_CODES_W) next_dir = 1;
            else if (last_change == KEY_CODES_S) next_dir = 0;
            else next_dir = dir;
        end else next_dir = dir;
    end

    always @(posedge clk) begin
        if (rst) begin
            dir <= 1;
        end else dir <= next_dir;
    end
    //==============================

    //fast==========================
    always @(*) begin
        if (been_ready && key_down[last_change] == 1'd1) begin
            if (last_change == KEY_CODES_R && !fast) next_fast = 1;
            else if (last_change == KEY_CODES_R && fast) next_fast = 0;
            else next_fast = fast;
        end else next_fast = fast;
    end

    always @(posedge clk) begin
        if (rst) begin
            fast <= 0;
        end else fast <= next_fast;
    end
    //==============================


endmodule
