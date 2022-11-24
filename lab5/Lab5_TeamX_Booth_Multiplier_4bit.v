`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output signed [7:0] p;

parameter WAIT    = 2'b00,
		  CAL     = 2'b01,
		  FINISH1 = 2'b10,
		  FINISH2 = 2'b11;

reg q0;
reg [1:0] cur_state, next_state;
reg [2:0] count;
reg [3:0] Q, M, A, NM, add, sub;
reg signed [7:0] p, pp;
reg flag;


always @(posedge clk) begin
	if (!rst_n) cur_state <= WAIT;
	else cur_state <= next_state;
end

always @(*) begin
	next_state = 2'bx;
	case (cur_state)
		WAIT: if (start) next_state = CAL;
		else             next_state = WAIT;
		CAL: begin
			if (count == 3) next_state = FINISH1;
			else next_state = CAL;
		end
		FINISH1: next_state = FINISH2;
		FINISH2: next_state = WAIT;
		default: next_state = WAIT;
	endcase
end

always @(*) begin
	if (!rst_n) begin
        add = M;
        sub = NM;
    end
    else begin
        add = A + M;
        sub = A + NM;
    end
end

always @ (posedge clk) begin
	if (!rst_n) begin
		p <= 8'd0;
		q0 <= 1'd0;
		A <= 4'd0;
		count <= 3'd0;
		Q <= 0;
		M <= 0;
		NM <= 0;
	end
	else begin
		case (cur_state)
			WAIT: begin
				if (start) begin
					Q <= b;
					if (a == -8) begin
						flag <= 1'b1;
					end 
					else flag <= 1'b0;
					M <= a;
					NM <= -a;
					count <= 0;
					q0 <= 1'd0;
					A <= 4'd0;
				end
				p <= 8'd0;
			end
			CAL: begin
				case ({Q[0], q0})
                    2'b00: begin
                        A[2:0] <= A[3:1];
                        Q <= {A[0], Q[3:1]};
                        q0 <= Q[0];
                    end
                    2'b11: begin
                        A[2:0] <= A[3:1];
                        Q <= {A[0], Q[3:1]};
                        q0 <= Q[0];
                    end
                    2'b01: begin
                        A[3] <= add[3];
                        A[2:0] <= add[3:1];
                        Q[3] <= add[0];
                        Q[2:0] <= Q[3:1];
                        q0 <= Q[0];
                    end
                    2'b10: begin
                        A[3] <= sub[3];
                        A[2:0] <= sub[3:1];
                        Q[3] <= sub[0];
                        Q[2:0] <= Q[3:1];
                        q0 <= Q[0];
                    end
                endcase
				p <= 8'd0;
				count <= count + 1;
			end
			FINISH1: begin
				p <= (flag)? -({A, Q}) : {A, Q};

			end
			FINISH2: begin
				p <= (flag)? -({A, Q}) : {A, Q};

			end
		endcase
	end
end
endmodule