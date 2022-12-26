// SB : Task 2 B : UART
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design UART Transmitter.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module uart(
	input clk_50M,	//50 MHz clock
	output tx		//UART transmit output
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////


reg [0:4*8-1] str = "SB47";
reg [2:0] d_ctr = 0;

localparam IDLE = 2'b00,
START = 2'b01,
DATA = 2'b10,
STOP = 2'b11;

reg [1:0] state = 2'b01;
reg signed [8:0] ctr = -1;

reg [3:0] dbits = 0;

reg TX = 1'b1;
assign tx = TX;

always @(posedge clk_50M) begin
	
	if (ctr == 9'd433) begin
		
		//state <= next;
		ctr <= 9'd0;
		
		case(state)
			IDLE: begin
				TX <= 1'b1;
				
				if (d_ctr == 3'd4) begin
					state <= IDLE;
				end else begin
					state <= START;
				end
			end
			
			START: begin
				TX <= 1'b0;
				
				state <= DATA;
			end
			
			DATA: begin
			
				dbits <= dbits + 1'b1; 
				TX <= str[8*d_ctr+7-dbits]; 
				state <= (dbits == 4'd7) ? STOP : DATA;

			end
			
			STOP: begin
				TX <= 1'b1;
				state <= IDLE;
				
				dbits <= 0;
				d_ctr <= d_ctr + 1'b1;
			end
			
		endcase
		
	end else begin
	
		ctr <= ctr + 1'b1;
	end
end

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////