// SB : Task 1A Combinational Circuit
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design 2:1 Multiplexer.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//2:1 MUX design
//Inputs	: i1(MSB), io(LSB) & select line(s0)
//Output	: y

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module Mux_2_to_1(
	input		i1,       //INPUT i1 (MSB)
	input		i0,		 //INPUT i0
	input		s0,		 //SELECT INPUT s0(LSB)
	output reg	y		 //OUTPUT y
);


////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 

always @(*) begin
	case(s0)
		1'b0: y = i0;
		1'b1: y = i1;
	endcase
end
	
	
	

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////
