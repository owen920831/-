`timescale 1ns/1ps
module tracker_sensor(clk, reset, stop, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input wire stop;
    input left_signal, right_signal, mid_signal;
    output reg [2:0] state;
    reg [2:0] next_state;

    wire [2:0] signal = {left_signal, mid_signal, right_signal};
    parameter Stop = 3'b000;
    parameter Forward = 3'b001;
    parameter Right = 3'b010;
    parameter Left = 3'b011;
    parameter Backward = 3'b100;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    always @(posedge clk) begin
        if(reset == 1'b1)
            state <= Forward;
        else begin
            state <= next_state;
        end
    end
    always @(*) begin
        if (stop == 1) begin
            next_state = Stop;
        end
        else begin
            case (state)
                Stop:begin
                    case(signal)
                        3'd111 :
                            next_state = Forward;
                        3'd000 :
                            next_state = Backward;
                        3'd100, 3'd110:
                            next_state = Left;
                        3'd001, 3'd011:
                            next_state = Right;
                        default :
                            next_state = Stop;
                    endcase
                end 
                Forward, Right, Left, Backward:begin
                    case(signal)
                        3'd100, 3'd110:
                            next_state = Left;
                        3'd001, 3'd011:
                            next_state = Right;
                        3'd000:
                            next_state = Backward;
                        default:
                            next_state = Forward;
                    endcase
                end
            endcase 
        end
    end

endmodule
