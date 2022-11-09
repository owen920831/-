module toBCD(out, out_BCD);
    input [3:0] out;
    output [6:0] out_BCD;
    reg [6:0] out_BCD;
    always @(*) begin
        case (out)
            4'd0: out_BCD = 7'b0000001;   
            4'd1: out_BCD = 7'b1001111; 
            4'd2: out_BCD = 7'b0010010;  
            4'd3: out_BCD = 7'b0000110; 
            4'd4: out_BCD = 7'b1001100; 
            4'd5: out_BCD = 7'b0100100;  
            4'd6: out_BCD = 7'b0100000; 
            4'd7: out_BCD = 7'b0001111; 
            4'd8: out_BCD = 7'b0000000;  
            4'd9: out_BCD = 7'b0000100;
            4'd10: out_BCD = 7'b0001000; //A
            4'd11: out_BCD = 7'b1100000; //b
            4'd12: out_BCD = 7'b1111111; //empty
            default: out_BCD = 7'b1111110; // x
        endcase
    end
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; // signal of a pushbutton after being debounced
    input pb; // signal from a pushbutton
    input clk;

    reg [3:0] DFF; // use shift_reg to filter pushbutton bounce
    always @(posedge clk) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse (PB_one_pulse,PB_debounced, CLK);
    input PB_debounced;
    input CLK;
    output PB_one_pulse;
    reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge CLK) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end
endmodule

module Clock_Divider (clk, rst_n, display_clk, flicker_clk);
    input clk, rst_n;
    output reg display_clk, flicker_clk;

    reg [16:0] d_counter;
    reg [23:0] f_counter;
    always @(posedge clk) begin
        if(!rst_n) begin
            d_counter <= 1'b0;
            f_counter <= 1'b0;
        end
        else begin
            d_counter <= d_counter + 1'b1;
            f_counter <= f_counter + 1'b1;
        end
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            display_clk <= 1'b0;
            flicker_clk <= 1'b0;
        end
        else begin
            display_clk <= (d_counter == 17'b0);
            flicker_clk <= (f_counter == 24'b0);
        end
    end
endmodule

module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [11:0] out;

    wire xor_in;

    assign xor_in = out[1] ^ out[2] ^ out[3] ^ out[7];

    always @(posedge clk) begin
        if (!rst_n) begin
            out <= 12'b011011110110;
        end
        else begin
            out <= {out[10:0], xor_in};
        end
    end
endmodule

module random_4(clk, rst_n, ans);
    input clk;
    input rst_n;
    output reg [15:0] ans;
    wire [11:0] out;
    
    reg [3:0] a, b, c, d;
    reg [15:0] tmp_ans;

    wire same = (tmp_ans[15:12] != tmp_ans[11:8]) && 
                (tmp_ans[15:12] != tmp_ans[7:4]) && 
                (tmp_ans[15:12] != tmp_ans[3:0]) && 
                (tmp_ans[11:8] != tmp_ans[7:4]) && 
                (tmp_ans[11:8] != tmp_ans[3:0]) && 
                (tmp_ans[7:4] != tmp_ans[3:0]);

    Many_To_One_LFSR m(clk, rst_n, out);

    always @(*) begin
        a = {1'b0, out[11:9]} + 1'b1;
        b = {1'b0, out[8:6]} + 1'b1;
        c = {1'b0, out[5:3]} + 1'b1;
        d = {1'b0, out[2:0]} + 1'b1;
        tmp_ans = {a%4'b1010, (a+b)%4'b1010, (a+b+c)%4'b1010, (a+b+c+d)%4'b1010};
    end

    always @(posedge clk) begin
        if (!rst_n) ans <= 16'b1001001101010001;
        else ans <= (same) ? tmp_ans : ans;
    end
endmodule

module FPGA_1A2b (
    input clk, rst_n, start, enter,
    input [3:0] flicker_answer,
    output [15:0] random_answer_LED,
    output [6:0] seg,
    output [3:0] An
);
    wire rst_db, rst_op, start_db, start_op, enter_db, enter_op;
    wire reset = ~rst_op;

    debounce d0(start_db, start, clk);
    onepulse o0(start_op, start_db, clk);

    debounce d1(rst_db, rst_n, clk);
    onepulse o3(rst_op, rst_db, clk);

    debounce d2(enter_db, enter, clk);
    onepulse o4(enter_op, enter_db, clk);

    // Core module
    wire [15:0] guessing_answer;
    wire [3:0] num_A, num_b;
    wire [1:0] state;
    wire [1:0] guess_digit;

    main_1A2b m1(clk, reset, start_op, enter_op, flicker_answer, random_answer_LED, guessing_answer, num_A, num_b, state);
    display_7seg m(clk, reset, state, guessing_answer, num_A, num_b, seg, An);
endmodule

module main_1A2b (clk, rst_n, start, enter, flicker_answer, random_answer_LED, guessing_answer, num_A, num_b, state); 
    input clk, rst_n, start, enter;
    input [3:0] flicker_answer;
    output [15:0] random_answer_LED;
    output [15:0] guessing_answer;
    output [3:0] num_A, num_b;
    output [1:0] state;

    parameter init = 2'b00;
    parameter guessing = 2'b01;
    parameter result = 2'b10;

    reg [1:0] state, next_state;
    reg [15:0] random_answer_LED, next_random_answer; //ans
    wire [15:0] random; //keep changing random
    wire [3:0] num_b_counter; //calculate num_b
    reg [3:0] num_A, num_b, next_num_A, next_num_b; 
    reg [15:0] guessing_answer, next_guessing_answer; //ex: 0003, 0031, 0310, 3104
    reg [2:0] guess_digit, next_guess_digit; //猜第幾個bit

    //generate random numbers
    random_4 r(clk, rst_n, random);

    //counting num_b
    assign num_b_counter[0] = (guessing_answer[15:12] == random_answer_LED[11:8]) || (guessing_answer[15:12] == random_answer_LED[7:4]) || (guessing_answer[15:12] == random_answer_LED[3:0]);
    assign num_b_counter[1] = (guessing_answer[11:8] == random_answer_LED[15:12]) || (guessing_answer[11:8] == random_answer_LED[7:4]) || (guessing_answer[11:8] == random_answer_LED[3:0]);
    assign num_b_counter[2] = (guessing_answer[7:4] == random_answer_LED[15:12]) || (guessing_answer[7:4] == random_answer_LED[11:8]) || (guessing_answer[7:4] == random_answer_LED[3:0]);
    assign num_b_counter[3] = (guessing_answer[3:0] == random_answer_LED[15:12]) || (guessing_answer[3:0] == random_answer_LED[7:4]) || (guessing_answer[3:0] == random_answer_LED[11:8]);
    
    // rst_n and update value from next
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= init;
            guess_digit <= 3'b0;
            {num_A, num_b} <= 8'b0;
            guessing_answer <= 16'b0;
            random_answer_LED <= 16'b0;
        end
        else begin
            state <= next_state;
            guess_digit <= next_guess_digit;
            {num_A, num_b} <= {next_num_A, next_num_b};
            guessing_answer <= next_guessing_answer;
            random_answer_LED <= next_random_answer;
        end
    end

    // state transfer
    always @(*) begin
        case (state) 
            init: next_state = (start) ? guessing : init;
            guessing : next_state = (guess_digit == 3'b100) ? result : guessing;
            result : begin
                if (enter) begin
                    if (num_A == 3'b100) next_state = init;
                    else next_state = guessing;
                end
                else next_state = result;
            end
        endcase
    end

    // what state should do 
    always @(*) begin
        case (state)
            init : begin
                next_guess_digit = 3'b0;
                {next_num_A, next_num_b} = 8'b0;
                next_guessing_answer =  16'b0;
                next_random_answer = (start) ? random : 16'b0;
            end
            guessing : begin
                next_guess_digit = (enter) ? guess_digit + 1'b1 : guess_digit;
                {next_num_A, next_num_b} = {num_A, num_b};
                next_guessing_answer = (enter && guess_digit < 3'b011) ? {guessing_answer[11:0], flicker_answer} : {guessing_answer[15:4], flicker_answer};
                next_random_answer = random_answer_LED;
            end
            result: begin
                next_guess_digit = 3'b0;
                next_num_A = (guessing_answer[15:12] == random_answer_LED[15:12]) + (guessing_answer[11:8] ==  random_answer_LED[11:8]) + (guessing_answer[7:4] == random_answer_LED[7:4]) + (guessing_answer[3:0] == random_answer_LED[3:0]);
                next_num_b = num_b_counter[0] + num_b_counter[1] + num_b_counter[2] + num_b_counter[3];     
                next_guessing_answer = (enter) ? 16'b0 : guessing_answer;
                next_random_answer = random_answer_LED;
            end
        endcase
    end
endmodule

module display_7seg (clk, rst_n, state, guessing_answer, num_A, num_b, seg, an);
    input clk, rst_n;
    input [1:0] state;
    input [15:0] guessing_answer;
    input [3:0] num_A, num_b;
    output [6:0] seg;
    output [3:0] an;

    parameter init = 2'b00;
    parameter guessing = 2'b01;
    parameter result = 2'b10;
    
    wire [6:0] next_seg;
    reg [6:0] seg;
    reg [3:0] an, next_an;
    reg [1:0] an_index;
    reg [3:0] displayed_item;
    reg flicker;

    wire display_clk, flicker_clk;

    Clock_Divider  c(clk, rst_n, display_clk, flicker_clk);

    toBCD t(displayed_item, next_seg);

    wire [1:0] next_an_index = (display_clk == 1) ? an_index + 1 : an_index;
    wire next_flicker = (flicker_clk == 1) ? ~flicker : flicker;

    always @(posedge clk) begin
        if (!rst_n) begin
            seg <= 7'b1111111;
            an_index <= 2'b0;
            an <= 4'b1111;
            flicker <= 1'b0;
        end
        else begin
            seg <= next_seg;
            an_index <= next_an_index;
            an <= next_an;
            flicker <= next_flicker;
        end
    end

    always @(*) begin
        case (state) 
            init : begin
                case (an_index) 
                    2'b00 : displayed_item = 4'b1011; // b
                    2'b01 : displayed_item = 4'b0010; // 2
                    2'b10 : displayed_item = 4'b1010; // A
                    2'b11 : displayed_item = 4'b0001; // 1
                endcase                
            end
            guessing : begin
                case (an_index) 
                    2'b00 : displayed_item = (flicker)? 4'd12 : guessing_answer[3:0];
                    2'b01 : displayed_item = guessing_answer[7:4]; 
                    2'b10 : displayed_item = guessing_answer[11:8]; 
                    2'b11 : displayed_item = guessing_answer[15:12]; 
                endcase  
            end
            result : begin
                case (an_index)
                    2'b00 : displayed_item = 4'b1011; // b
                    2'b01 : displayed_item = num_b; // num_b
                    2'b10 : displayed_item = 4'b1010; // A
                    2'b11 : displayed_item = num_A; // num_A
                endcase
            end
        endcase
    end
    
    always @(*) begin
        case (an_index)
            2'b00 : next_an = 4'b1110; 
            2'b01 : next_an = 4'b1101; 
            2'b10 : next_an = 4'b1011; 
            2'b11 : next_an = 4'b0111; 
            default : next_an = 4'b1111;
        endcase 
    end
endmodule