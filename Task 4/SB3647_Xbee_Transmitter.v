/* Module SB3647_Xbee_Transmiter

Swachhta Bot - Team 3647
This module is used to transmit the data to the Xbee module using UART protocol.
The data is transmitted in the form of ASCII characters.

Input   : clk_50M  - 50 MHz clock
        tx_start - START Transmit
        colour    - Color of the GBI
        bin_number - 1 to 9
        msg_field    - Field of the message (V, M, D, Z)
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
    input [1:0] colour, msg_type, msg_field,
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
localparam  IDLE = 8'h00, START = 8'h01, STOP = 8'h02;
            GBI_MESSAGE = 8'b03;
            char_hash = 8'b00100011, char_dash = 8'b00101101, char_newline = 8'b00001010;
            char_0 = 8'b00110000, char_1 = 8'b00110001, char_2 = 8'b00110010, char_3 = 8'b00110011, char_4 = 8'b00110100;
            char_5 = 8'b00110101, char_6 = 8'b00110110, char_7 = 8'b00110111, char_8 = 8'b00111000, char_9 = 8'b00111001;
            char_G = 8'b01000111, char_B = 8'b01000010, char_I = 8'b01001001, char_M = 8'b01001101, char_W = 8'b01010111, char_D = 8'b01000100;


// Defining Local Parameters
reg [11:0] counter = 0;  
reg [7:0] PRESENT =IDLE; // PRESENT is the state variable
reg [7:0] msg = 0;
reg [3:0] data_index = 0;
reg [2:0] index = 0;
reg tx_done = 0, tx_out = 1;

assign tx = tx_out;
assign done = tx_done;

always @(posedge clk_50M) 
begin 
    if(tx_start == 1) begin   
        tx_done = 0;
		counter = counter + 1;
        case(present)
           IDLE: 
                begin
                if(tx_done == 1) tx_out = tx_idle;
                else if(counter < bpc) tx_out = tx_idle;
                else begin
                    counter = 0;
                    PRESENT = START;
                    end
                end

            START: 
                begin
                if(counter < bpc)   tx_out = START[index];
                else if(counter > bpc-1) begin
                    counter = 0;
                    if(msg_type == 1) PRESENT = GBI_MESSAGE
                    end
                end

            STOP:
                begin
                if(counter < bpc) tx_out = STOP[index];
                else begin
                    counter = 0;
                    PRESENT =IDLE;
                    end
                end

            GBI_MESSAGE:
            // Msg Format : GBI[block_number]-wastetype-#
                begin 
                if (data_index = 0) msg = char_G;
                else if (data_index == 1) msg = char_B;
                else if (data_index == 2) msg = char_I;
                else if (data_index == 3) begin
                    if (!bin_number) msg = char_0;
                    else msg = bin_number;
                    end
                else if (data_index == 4) msg = char_dash;
                else if (data_index == 5) 
                    begin
                    if (colour == 0) msg = char_M;
                    else if (colour == 1) msg = char_D;
                    else if (colour == 2) msg = char_W;
                    end
                else if (data_index == 6) msg = char_dash;
                else if (data_index == 7) msg = char_hash;
                else if (data_index == 8) msg = char_newline;

                if(counter < bpc) tx_out = msg[index];
                else if(index < 8) begin
                    // check why 8
                    counter = 0;
                    if (index!= 7) index = index + 1;
                    else begin
                        counter = 0;
                        index = 0;
                        data_index = data_index + 1;
                        PRESENT = STOP;
                        if(data_index == 12) begin
                            data_index = 0;
                            tx_done = 1;
                        end
                    end
                end
                end

                end

            default:
                tx_out = 1;
        endcase
    end
end

endmodule