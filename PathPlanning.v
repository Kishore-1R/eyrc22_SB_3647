// SM : Task 2 C : Path Planning
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design path planner.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Path Planner design
//Parameters : node_count : for total no. of nodes + 1 (consider an imaginary node, refer discuss forum),
//					max_edges : no. of max edges for every node.


//Inputs  	 : clk : 50 MHz clock, 
//				   start : start signal to initiate the path planning,
//				   s_node : start node,
//				   e_node : destination node.
//
//Output     : done : Path planning completed signal,
//             final_path : the final path from start to end node.



//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////

module path_planner
#(parameter node_count = 27, parameter max_edges = 4)
(
	input clk,
	input start,
	input [4:0] s_node,
	input [4:0] e_node,
	output reg done,	
	output reg [10*5-1:0] final_path
);

////////////////////////WRITE YOUR CODE FROM HERE////////////////////

reg [11:0] dist [27:0] = 12'b1111111_11011; //infty(1111111) + 27(11011)
// Arjun - "I don't think we can do this, use a for loop to initialize"
// https://stackoverflow.com/questions/29053120/initializing-arrays-in-verilog
reg [27:0] visited = 27'b0100000000000000000000000000;
reg [4:0] visnum = 5'b00000;	//Max value = 26 (Nodes 0 to 25)
reg [4:0] snode; // Arjun - "Are you initializing it to zero?"
reg [4:0] enode;

//For FSM
reg [3:0] state = 3'b000;
reg [4:0] currnode = snode;
reg [4:0] prevnode = snode; // "why snode?""

assign snode = s_node;
assign enode = e_node; 

dist[snode] = {3'b000, snode};

case(state) begin // "case statement should be within always/initial block"
	//State to initialize all values for the current node; MAKE SOME LOGIC TO UPDATE DIST FROM GRAPH ???
	3'b000: begin 
		//The 4 nodes ie:points connected
		//CHANGE DIST TO GRAPH AND CORRECT THIS
		reg [11:0] pt1 = dist[currnode][0];
		reg [11:0] pt2 = dist[currnode][1];
		reg [11:0] pt3 = dist[currnode][2];
		reg [11:0] pt4 = dist[currnode][3];

		state <= 3'b001;
	end
	// Start looking at all the 4 nodes connected to currnode ie: Updating dist
	// Calculate full tot distance and see if calc is lesser before adding it to dist
	3'b001: begin
		reg [6:0] calcdist = dist[currnode][11:5];
		dist[pt1[4:0]] = {pt1[11:5]+calcdist, currnode};
		dist[pt2[4:0]] = {pt1[11:5]+calcdist, currnode};
		dist[pt3[4:0]] = {pt1[11:5]+calcdist, currnode};
		dist[pt4[4:0]] = {pt1[11:5]+calcdist, currnode};

		state <= 3'b010;
	end
	//To calculate min ie nextnode : The for loop from Arjun
	/*****

	******/
	min_dist = 7'b111_1111; // infty
	for (int i = 0; i < node_count; i = i+1) begin
		if ((!visited[i]) && (i != currnode)) begin // look at all unvisited nodes
			if (dist[i][11:5] < min_dist) begin
				nextnode = i;
				min_dist = dist[i][11:5];
			end
		end
	end

	3'b010: begin

		state <= 3'b011;
	end
	//End state
	3'b011: begin
		visited[currnode] = 1'b1;
		visnum <= visnum + 1;
		prevnode <= currnode;
		currnode <= nextnode;	//nextnode = the decided currnode for next iteration; WHERE TO DEFINE IT

		state <= 3'b000;
	end
endcase

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////