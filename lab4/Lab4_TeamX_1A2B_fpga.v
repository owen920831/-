`timescale 1ns/1ps

module FPGA_1A2B(clk, rst_n, start, enter, An, LED);
    input clk, rst_n, start, enter;
    input [3:0] flicker_answer;
    output reg [3:0] An;
    output reg [6:0] seg;

    reg [3:0] num_A, num_b; //在guessing_4時檢查幾a幾b
    reg [2:0] state, next_state;
    wire [15:0] random_answer_LED; //random generated answer output as LED
    reg [15:0] guessing_answer; //input answer
    reg [3:0] displayed_item; //input of BCD, 包括 num_A, num_b, A, B

    wire flip_db, flip_op, rst_db, rst_op, start_db, start_op;
    wire dclk, nclk;

    // define state
    parameter init = 3'b000; // initial
    parameter guessing_1 = 3'b001; //000x
    parameter guessing_2 = 3'b010; //00xx
    parameter guessing_3 = 3'b011; //0xxx
    parameter guessing_4 = 3'b100; //xxxx
    parameter answer_correct = 3'b101; 
    parameter answer_wrong = 3'b110;

    //除頻
    clock_divider c(clk, rst_1, dclk, nclk);

    debounce d0(start_db, start, clk);
    onepulse o0(start_op, start_db, clk);

    debounce d1(rst_db, rst_n, clk);
    onepulse o3(rst_op, rst_db, clk);

    debounce d1(enter_db, enter, clk);
    onepulse o3(enter_op, enter_db, clk);

    toBCD o(displayed_item, seg);
    

    always @(posedge clk) begin
        if (!rst_op) begin
            state <= init;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            init: begin
                if (start_op) next_state = guessing_1;
                else next_state = state;
            end 
            guessing_1: begin
                if (enter_op) next_state = guessing_2;
                else next_state = state;
            end
            guessing_2: begin
                if (enter_op) next_state = guessing_3;
                else next_state = state;
            end
            guessing_3: begin
                if (enter_op) next_state = guessing_4;
                else next_state = state;                
            end
            guessing_4: begin //檢查答案是否正確
                num_A = 4'b0;
                num_b = 4'b0;
                if (guessing_answer[15:12] == random_answer_LED[15:12]) num_A = num_A + 4'b0001;
                else if (guessing_answer[15:12] == random_answer_LED[11:8]) num_b = num_b + 4'b0001;
                else if (guessing_answer[15:12] == random_answer_LED[7:4]) num_b = num_b + 4'b0001;
                else if (guessing_answer[15:12] == random_answer_LED[3:0]) num_b = num_b + 4'b0001;
                else num_A = num_A;

                if (guessing_answer[11:8] ==  random_answer_LED[11:8]) num_A = num_A + 4'b0001;
                else if (guessing_answer[11:8] == random_answer_LED[15:12]) num_b = num_b + 4'b0001;
                else if (guessing_answer[11:8] == random_answer_LED[7:4]) num_b = num_b + 4'b0001;
                else if (guessing_answer[11:8] == random_answer_LED[3:0]) num_b = num_b + 4'b0001;
                else num_A = num_A;

                if (guessing_answer[7:4] == random_answer_LED[7:4]) num_A = num_A + 4'b0001;
                else if (guessing_answer[7:4] == random_answer_LED[11:8]) num_b = num_b + 4'b0001;
                else if (guessing_answer[7:4] == random_answer_LED[15:12]) num_b = num_b + 4'b0001;
                else if (guessing_answer[7:4] == random_answer_LED[3:0]) num_b = num_b + 4'b0001;
                else num_A = num_A;

                if (guessing_answer[3:0] == random_answer_LED[3:0]) num_A = num_A + 4'b0001;
                else if (guessing_answer[3:0] == random_answer_LED[11:8]) num_b = num_b + 4'b0001;
                else if (guessing_answer[3:0] == random_answer_LED[7:4]) num_b = num_b + 4'b0001;
                else if (guessing_answer[3:0] == random_answer_LED[15:12]) num_b = num_b + 4'b0001;
                else num_A = num_A;

                if (enter_op && num_A == 4'b0100 && num_b == 4'b0000) begin
                    next_state = answer_correct; //4A0b
                    random_answer_LED = 16'b0; //clear LED
                end
                else if (enter_op && !(num_A == 4'b0100 && num_b == 4'b0000))  next_state = answer_wrong; //xAxb
                else next_state = state;
            end
            answer_correct: begin
                if (enter_op) next_state = init;
                else next_state = state;                                   
            end
            answer_wrong: begin
                if (enter_op) next_state = guessing_1;
                else next_state = state;                   
            end
            default: next_state = state;
        endcase
    end

    always @(posedge clk) begin //input轉移
        case (state)
            init, answer_correct, answer_wrong: guessing_answer = 16'b0;
            guessing_1, guessing_2, guessing_3, guessing_4: guessing_answer = {guessing_answer[11:0], flicker_answer};
            default: guessing_answer = 16'b0;
        endcase    
    end

    assign nrfcnt = dclk ? rf_cnt+1'b1 : rf_cnt;
    always @(posedge clk) begin
        if(rst_op) rf_cnt <= 2'b0;
        else  rf_cnt <= nrfcnt;
    end
    
    always @(*) begin
        case(rf_cnt)
        case(state)
            init: begin
                2'd0: begin
                    displayed_item = 4'b0001; //1
                    An = 4'b0111;
                end
                2'd1: begin
                    displayed_item = 4'b1010; //A
                    An = 4'b1011;
                end
                2'd2: begin
                    displayed_item = 4'b0010; //2
                    An = 4'b1101;
                end
                2'd3: begin
                    displayed_item = 4'b1011; //b
                    An = 4'b1110;
                end
            end
            guessing_1, guessing_2, guessing_3, guessing_4: begin
                2'd0: begin
                    displayed_item = guessing_answer[15:12]; //
                    An = 4'b0111;
                end
                2'd1: begin
                    displayed_item = guessing_answer[11:8]; //
                    An = 4'b1011;
                end
                2'd2: begin
                    displayed_item = guessing_answer[7:4]; //
                    An = 4'b1101;
                end
                2'd3: begin
                    displayed_item = guessing_answer[3:0]; //
                    An = 4'b1110;
                end
            end
            answer_correct, answer_wrong: begin
                2'd0: begin
                    displayed_item = num_A; //num_A
                    An = 4'b0111;
                end
                2'd1: begin
                    displayed_item = 4'b1010; //A
                    An = 4'b1011;
                end
                2'd2: begin
                    displayed_item = num_b; //num_b
                    An = 4'b1101;
                end
                2'd3: begin
                    displayed_item = 4'b1011; //b
                    An = 4'b1110;
                end
            end
        endcase
        endcase
    end


endmodule

module toBCD(input [3:0] out, output reg[6:0] out_BCD);
    always @(*) begin
        case (out)
            4'd0: out_BCD[6:0] = 7'b0000001;   
            4'd1: out_BCD[6:0] = 7'b1001111; 
            4'd2: out_BCD[6:0] = 7'b0010010;  
            4'd3: out_BCD[6:0] = 7'b0000110; 
            4'd4: out_BCD[6:0] = 7'b1001100; 
            4'd5: out_BCD[6:0] = 7'b0100100;  
            4'd6: out_BCD[6:0] = 7'b0100000; 
            4'd7: out_BCD[6:0] = 7'b0001111; 
            4'd8: out_BCD[6:0] = 7'b0000000;  
            4'd9: out_BCD[6:0] = 7'b0000100;
            4'd10: out_BCD[6:0] = 7'b1110111; //A
            4'd11: out_BCD[6:0] = 7'b0011111; //b
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

module onepulse (pb_one_pulse, pb_debounced, clk);
    input pb_debounced;
    input clk;
    output pb_one_pulse;
    reg pb_one_pulse;
    reg pb_debounced_delay;

    always @(posedge clk) begin
        pb_one_pulse <= pb_debounced & (! pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;
    end
endmodule

module clock_divider (clk, rst_n, display_clk, num_clk);
    input clk,rst_n;
    output reg display_clk, num_clk;

    reg [17:0] ctr_co;
    reg [24:0] ctr_CO;

    always @(posedge clk) begin
        if(rst_n) begin
            ctr_co <= 1'b0;
            ctr_CO <=1'b0;
        end
        else begin
            ctr_co <= ctr_co+1'b1;
            ctr_CO <= ctr_CO+1'b1;
        end
    end

    always @(posedge clk) begin
        if(rst_n) begin
            display_clk <=1'b0;
            num_clk <= 1'b0;
        end
        else begin
            display_clk <= ctr_co== 18'b111111111111111111;
            num_clk <= ctr_CO== 25'b1111111111111111111111111;
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
        a = {1'b0, out[11:9]}+1'b1;
        b = {1'b0, out[8:6]}+1'b1;
        c = {1'b0, out[5:3]}+1'b1;
        d = {1'b0, out[2:0]}+1'b1;
        tmp_ans = {a%4'b1010, (a+b)%4'b1010, (a+b+c)%4'b1010, (a+b+c+d)%4'b1010};
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            ans <= 16'b1001001101010001;
        end
        else begin
            ans <= (same) ? tmp_ans : ans;
        end
    end
endmodule