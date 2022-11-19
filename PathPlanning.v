// SM : Task 2 C : Path Planning
//Authors : Kishore, Arjun, Shashidhar, Ayush
//Implementing Djikstra's Algorithm in verilog
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

reg [11:0] dist [0:27]; 

reg [27:0] visited = 28'b0100_0000_0000_0000_0000_0000_0000;

//For FSM
reg [3:0] state = 3'b000;
reg [4:0] currnode;
reg [4:0] nextnode = 5'b11011;
wire [31:0] graph_op;

reg [7:0] pt1;
reg [7:0] pt2;
reg [7:0] pt3;
reg [7:0] pt4;

reg [6:0] calcdist;
reg [6:0] min_dist;
reg [4:0] p_node;
reg [4:0] c_node;

initial dist[s_node] = {3'b000, s_node};
initial final_path = 0;
integer i;
integer j;
initial begin
  for (i=0;i<=27;i=i+1)
	dist[i] = 12'b1111111_11011; //infty(1111111) + 27(11011)
end

initial_graph map(currnode, graph_op);

always @(posedge clk) begin
	case(state) 
		//State to initialize all values for the current node;
		3'b000: begin
			if (start) begin
				currnode = s_node;
				visited = 28'b0100_0000_0000_0000_0000_0000_0000;
				done = 0;
			  	for (i=0;i<=27;i=i+1) dist[i] = 12'b1111111_11011; //infty(1111111) + 27(11011)
				
				state = 3'b001;
				//$display("Start node: %d", s_node);
			end else state = 3'b000;
			
		end

		3'b001: begin
			//The 4 nodes, i.e., points connected
			pt1 = graph_op[0+:8]; // [7:0] -----> 5'b node, 3'b separation
			pt2 = graph_op[8+:8]; // [15:8]
			pt3 = graph_op[16+:8]; // [23:16]
			pt4 = graph_op[24+:8]; // [31:24]
			//$display("%d", currnode);

			// Start looking at all the 4 nodes connected to currnode ie: Updating dist
			// Calculate full tot distance and see if calc is lesser before adding it to dist
			// 1-by-1
			calcdist = dist[currnode][11:5];

			// pt1 -----> 5'b node, 3'b separation [Neighbour 1]
			if (!visited[pt1[7:3]] && (pt1[2:0] != 3'b111)) begin
				calcdist = dist[currnode][11:5] + pt1[2:0];

				if (calcdist < dist[pt1[7:3]][11:5]) dist[pt1[7:3]] = {calcdist, currnode};
			end
			state = 3'b010;
		end

		3'b010: begin
			calcdist = dist[currnode][11:5];
			
			// pt2 -----> 5'b node, 3'b separation [Neighbour 2]
			if (!visited[pt2[7:3]] && (pt2[2:0] != 3'b111)) begin
				calcdist = dist[currnode][11:5] + pt2[2:0];

				if (calcdist < dist[pt2[7:3]][11:5]) dist[pt2[7:3]] = {calcdist, currnode};
			end
			state = 3'b011;
		end

		3'b011: begin
			calcdist = dist[currnode][11:5];
			
			// pt3 -----> 5'b node, 3'b separation [Neighbour 3]
			if (!visited[pt3[7:3]] && (pt3[2:0] != 3'b111)) begin
				calcdist = dist[currnode][11:5] + pt3[2:0];

				if (calcdist < dist[pt3[7:3]][11:5]) dist[pt3[7:3]] = {calcdist, currnode};
			end
			state = 3'b100;
		end

		3'b100: begin
			calcdist = dist[currnode][11:5];
			
			// pt4 -----> 5'b node, 3'b separation [Neighbour 4]
			if (!visited[pt4[7:3]] && (pt4[2:0] != 3'b111)) begin
				calcdist = dist[currnode][11:5] + pt4[2:0];

				if (calcdist < dist[pt4[7:3]][11:5]) dist[pt4[7:3]] = {calcdist, currnode};
			end
			state = 3'b101;
		end

		3'b101: begin

			visited[currnode] = 1'b1;
			//To calculate minimum dist., i.e., nextnode : for loop
			min_dist = 7'b111_1111; // infty
			for (i = 0; i < node_count; i = i+1) begin
				if ((!visited[i]) && (i != currnode)) begin // look at all unvisited nodes
					if (dist[i][11:5] < min_dist) begin
						nextnode = i;
						min_dist = dist[i][11:5];
					end
				end
			end
			currnode = nextnode;	

			state = 3'b110;
		end

		//End state
		3'b110: begin
			if ((visited[e_node]) == 1'b1) begin

				c_node = e_node;
				for (j=0; j<10; j=j+1) begin
					if (c_node != 5'd27) begin
						final_path[5*j+:5] = c_node;
						p_node = dist[c_node][4:0];
						c_node = p_node;
					end
					else begin 
						final_path[5*j+:5] = 5'd27;
					end
					//$display("%d th node is %d", 9-j, final_path[5*j+:5]);
				end
				done = 1'b1;
				state = 3'b000;
			end
			else state = 3'b001;
		end
	endcase
end
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////