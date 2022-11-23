// SB : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////
assign adc_cs_n = 0;

//1. For Clock
reg [2:0]count=5;

reg [2:0]count_q = 4;
reg adc_sck1 = 1;
assign adc_sck = adc_sck1;

always @(negedge clk_50) begin
	count_q <= count;
	if(count == 3'd5) begin
		count <= 0;
		count_q <= 0;
		adc_sck1 <= ~(adc_sck1); // latch? check for error here
	end
	else begin
		count <= count_q + 1;
	end
end

//2. FSM
reg [3:0] count16 = 0;

reg dinq = 0;
reg [1:0] dframe = 0;
reg [11:0] tempreg = 0;
reg [11:0] d_out_ch5q = 0;
reg [11:0] d_out_ch6q = 0;
reg [11:0] d_out_ch7q = 0;

assign din = dinq;
assign data_frame = dframe;
assign d_out_ch5 = d_out_ch5q<<1;
assign d_out_ch6 = d_out_ch6q<<1;
assign d_out_ch7 = d_out_ch7q<<1;

reg [1:0] state = 0;

always @(negedge adc_sck) begin
	
	if(count16 >= 4'd4) begin
				tempreg <= {tempreg[10:0], dout};
	end
	
	case(state) 
		2'b00 : begin
			if (count16 == 4'd00) begin
				d_out_ch6q <= tempreg;
			end
			if(count16 == 4'd2) dinq <= 1;
			else if(count16 == 4'd3) dinq <= 0;
			else if(count16 == 4'd4) dinq <= 1;
			else dinq <= 0;
			
			dframe <= 2'b00;
			
			if(count16 == 4'd15)begin
				state <= 2'b01;
			end 
			else state<= 2'b00;
			
		end
		2'b01: begin
			if(count16 == 4'd2) dinq <= 1;
			else if(count16 == 4'd3) dinq <= 1;
			else if(count16 == 4'd4) dinq <= 0;
			else dinq <= 0;
			
			dframe <= 2'b01;
			
			if (count16 == 4'd00) begin
				d_out_ch7q <= tempreg;
			end
			if(count16 == 4'd15)begin
				state <= 2'b10;
			end 
			else state<= 2'b01;
			
		end
		2'b10: begin
			if(count16 == 4'd2) dinq <= 1;
			else if(count16 == 4'd3) dinq <= 1;
			else if(count16 == 4'd4) dinq <= 1;
			else dinq <= 0;
			
			dframe <= 2'b10;
			
			if (count16 == 4'd00) begin
				d_out_ch5q <= tempreg;
			end
			if(count16 == 4'd15)begin
				state <= 2'b00;
			end 
			else state<= 2'b10;
			
		end
	
	endcase
	if(count16 == 4'd15)begin
			count16 <= 0;
	end 
	else count16 <= count16 + 1;
	
end

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////
