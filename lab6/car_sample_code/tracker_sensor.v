`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [1:0] state;
    reg [1:0] next_state;

    wire [2:0] signal = {left_signal, mid_signal, right_signal};
    parameter Stop = 2'b00;
    parameter Forward = 2'b01;
    parameter Right = 2'b10;
    parameter Left = 2'b11;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    always @(posedge clk or negedge reset) begin
        if(reset == 1'b0)
            state <= Stop;
        else begin
            state <= next_state;
        end
    end
    always @(*) begin
        case (state)
            Stop:begin
                case(signal)
                    3'd000 :
                        next_state = Forward;
                    default :
                        next_state = Stop;
                endcase
            end 
            Forward, Right, Left:begin
                case(signal)
                    3'd100, 3'd110:
                        next_state = Left;
                    3'd001, 3'd011:
                        next_state = Right;
                    default:
                        next_state = Forward;
                endcase
            end
        endcase 
    end

endmodule
