/* Module SB3647_Xbee_Transmiter

Swachhta Bot - Team 3647
This module is used to transmit the data to the Xbee module using UART protocol.
The data is transmitted in the form of ASCII characters.

Input   : clk_50M  - 50 MHz clock
        tx_start - START Transmit
        colour    - Color of the GBI
        bin_number - 1 to 9
        msg_type     - Type of the message (type 1 = GBI message)

Output  :
        done - Transmit Complete
        tx          - Transmit Data
    

NOTE - 
1. Colour - 2 bit value representing the color of the GBI
    0 - Red
    1 - Green
    2 - Blue
2. bin_number - four bit value representing the block number
    0000 - 9
    0001 - 1
    0010 - 2
    0011 - 3
    0100 - 4
    0101 - 5
    0110 - 6
    0111 - 7
    1000 - 8
*/
    
// Module Declaration
module SB3647_Xbee_Transmiter(
    input tx_start, clk_50M,
    input [1:0] colour, msg_type,
    input [3:0] bin_number,
    output done, tx
);

/*  
Data tx parameters - 
    baud = 115200
    bits per clock (bpc) = 115200/(50*10^6) = 434
    START_bit = 0
    2 STOP Bits
    STOP_bit = 1

Message Format -
    "GBI[block-number]-WasteType-#"
    eg. "GBI1-M-#"
    GBI color    Supply       Message
    ------------------------------------
  00 Red          Metals (M)   "GBI1-M-#"
  10 Blue         Wet (W)      "GBI1-W-#"
  01 Green        Dry (D)      "GBI1-D-#"


Ascii Values required
Alphabets = GBIMWD
Numbers = 1234567890
Characters = - #
- - 00101101    B - 01000010    
# - 00100011    W - 01010111
D - 01000100    G - 01000111
M - 01001101    I - 01001001
1  - 00110001   2 - 00110010
3  - 00110011   4 - 00110100
5  - 00110101   6 - 00110110
7  - 00110111   8 - 00111000
9  - 00111001   0 - 00110000
\n - 00001010

*/

// Defining Constant Parameters
parameter tx_idle = 1, bpc = 434;

// state machine states and characters
localparam  IDLE = 2'b00, START = 2'b01, STOP = 2'b10, DATA = 2'b11;
            char_hash = 8'b00100011, char_dash = 8'b00101101, char_newline = 8'b00001010, char_space = 8'b00100000;
            char_0 = 8'b00110000, char_1 = 8'b00110001, char_2 = 8'b00110010, char_3 = 8'b00110011, char_4 = 8'b00110100;
            char_5 = 8'b00110101, char_6 = 8'b00110110, char_7 = 8'b00110111, char_8 = 8'b00111000, char_9 = 8'b00111001;
            char_G = 8'b01000111, char_B = 8'b01000010, char_I = 8'b01001001, char_M = 8'b01001101, char_W = 8'b01010111, char_D = 8'b01000100;


// Defining Local Parameters
reg signed [8:0] counter = -1;  
reg [1:0] STATE = IDLE; // PRESENT is the state variable
reg [7:0] bin_num_ascii_binary = 0; // obtained from the combinatinal block
reg [3:0] bit_index = 0;  // total 8 bits in one character
reg [3:0] char_index = 0; // total 8 characters in one message
reg tx_done = 0, tx_out = 1;

assign tx = tx_out;
// in uart, tx_out is 1111.. and when transmission is to begin, it is pulled down to 0
// so, tx_out is 1 when no transmission is to be done
assign done = tx_done;

// the code transmits one character at a time

always @(posedge clk_50M) 
begin 
    if (counter == 9'd433) begin
        counter <= 0;
        
        case (STATE): 
            IDLE: begin
                tx_out <= 1;
                // char index 8 would mean 8 chars are sent
                if (char_index == 4'b1000) STATE <= IDLE;
                else STATE <= START;
            end

            START: begin
                tx_out <= 0;
                STATE <= DATA;
            end

            DATA: begin
                
                case (char_index):
                    3'b000: begin
                        // 'G'
                        if (bit_index == 4'b0000) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_G[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_G[7-bit_index];
                    end

                    3'b001: begin
                        // 'B'
                        if (bit_index == 4'b0000) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_B[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_B[7-bit_index];
                    end

                    3'b010: begin
                        // 'I'
                        if (bit_index == 4'b0000) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_I[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_I[7-bit_index];
                    end

                    3'b011: begin
                        // bin number
                        if (bit_index == 4'b0000) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= bin_num_ascii_binary[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= bin_num_ascii_binary[7-bit_index];
                    end

                    3'b100: begin
                        // '-' char_dash
                        if (bit_index == 4'b0000) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_dash[7-bit_index];
                    end

                    3'b101: begin
                        case (color):
                            2'b00: begin
                                // Red bin = 'M'
                                if (bit_index == 4'b0000) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0001) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0010) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0011) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0100) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0101) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0110) tx_out <= char_M[7-bit_index];
                                else if (bit_index == 4'b0111) tx_out <= char_M[7-bit_index];                                
                            end

                            2'b01: begin
                                // Green bin = 'D'
                                if (bit_index == 4'b0000) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0001) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0010) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0011) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0100) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0101) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0110) tx_out <= char_D[7-bit_index];
                                else if (bit_index == 4'b0111) tx_out <= char_D[7-bit_index];
                            end

                            2'b10: begin
                                // Blue bin = 'W'
                                if (bit_index == 4'b0000) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0001) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0010) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0011) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0100) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0101) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0110) tx_out <= char_W[7-bit_index];
                                else if (bit_index == 4'b0111) tx_out <= char_W[7-bit_index];
                            end
                        endcase
                    end

                    3'b110: begin
                        // '-' char_dash
                        if (bit_index == 4'b0000) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_dash[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_dash[7-bit_index];
                    end

                    3'b111: begin
                        // '#' char_hash
                        if (bit_index == 4'b0000) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_hash[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_hash[7-bit_index];
                    end

                    default: begin
                        // ' ' char_space
                        if (bit_index == 4'b0000) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0001) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0010) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0011) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0100) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0101) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0110) tx_out <= char_space[7-bit_index];
                        else if (bit_index == 4'b0111) tx_out <= char_space[7-bit_index];
                    end
                endcase
                if (bit_index == 3'b111) begin
                    STATE <= STOP;
                end
                else begin
                //
                end
                bit_index <= bit_index + 1;
            end
            
            STOP: begin
                tx_out <= 1;
                STATE <= IDLE;
                char_index <= char_index + 1;
                bit_index <= 0;
            end
        endcase
    end 
    else counter <= counter + 1;
end

always@(*) begin
    // convert the binary number to ascii
    case (bin_num)
        8'b00000000: bin_num_ascii_binary = char_0;
        8'b00000001: bin_num_ascii_binary = char_1;
        8'b00000010: bin_num_ascii_binary = char_2;
        8'b00000011: bin_num_ascii_binary = char_3;
        8'b00000100: bin_num_ascii_binary = char_4;
        8'b00000101: bin_num_ascii_binary = char_5;
        8'b00000110: bin_num_ascii_binary = char_6;
        8'b00000111: bin_num_ascii_binary = char_7;
        8'b00001000: bin_num_ascii_binary = char_8;
        8'b00001001: bin_num_ascii_binary = char_9;
        default: bin_num_ascii_binary = char_0;
    endcase
end

endmodule