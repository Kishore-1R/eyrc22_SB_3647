/* Module SM1118_Motor_Control

This module controls the Motor Driver to rotate the bot accordingly.

Motor Control Design
Input : clk       : Input Clk 3.125 Mhz
        direction : 2-bit value representing Movement
Output : lv : level shifer values to rotate Motor
*/
module SM1118_Motor_Control(
    input clk,
    input  [2:0] direction,
    output reg [3:0] lv
);
/* The 4-bit binary Values for rotating Motor in desired direction
is represented here.

+ = Clockwise
- = Anti-Clockwise
/ = doesn't rotate

Input   Binary Values   Motor Rotation  Direction
                           M1     M2    
  0         0000           /      /       Stop
  1         1010           +      +       Forward
  2         1000           +      -       Right
  3         0010           -      +       Left
  4         0101           -      -       Reverse
  5         1001           -      -       turn Right
  6         0110           -      -       turn left   */

always @(posedge clk) begin
    case(direction)
        0: lv[3:0] = 4'b0000;
        1: lv[3:0] = 4'b1010;
        2: lv[3:0] = 4'b1000;
        3: lv[3:0] = 4'b0010;
        4: lv[3:0] = 4'b0101;
        5: lv[3:0] = 4'b1001;
        6: lv[3:0] = 4'b0110;
    endcase
end

endmodule