/* 
Module Motor Control
Swachhta Bot - Team 3647
This module is used to control the movement of the robot. 
It takes the direction as input and generates the required binary values for the motor driver.
Motor Control Design
Input : clk       : Input Clk
        direction : 2-bit value representing motion direction
Output : level : level shifer values to rotate Motor
*/

module SM3647_MotorControl(
    input clk,
    input  [2:0] direction,
    output reg [3:0] level
);

/*
+ = Clockwise
- = Anti-Clockwise
/ = Stop rotating

Input   Binary Values   Motor Rotation  Direction
                           1     2    
  0         0000           /      /       Stop
  1         1010           +      +       Forward
  2         1000           +      -       Right
  3         0010           -      +       Left
  4         0101           -      -       Reverse

*/

always @(posedge clk) begin
    case(direction)
        0: level[3:0] = 4'b0000;
        1: level[3:0] = 4'b1010;
        2: level[3:0] = 4'b1000;
        3: level[3:0] = 4'b0010;
        4: level[3:0] = 4'b0101;
        5: level[3:0] = 4'b1001;
        6: level[3:0] = 4'b0110;
    endcase
end

endmodule