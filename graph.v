// DIJKSTRA's algorithm for E-YRC
// declaring the graph 
// 5-bits for graph number
// 3-bits for distance

module initial_graph(
    input [4:0] currnode,
    output [31:0] graph_op
);

	reg [7:0] graph [0:27][0:3];
	// graph[x][y] implies xth graph's yth nearest graph (zero adjusted)
	
	// there are 26 nodes, 
	// 4 neighbours of each node
	// node 27 being at infinity, inf represented by 3'b111
	
	//                       graph[i][0]
	//                            |
	//                            |
	//                            |
	//                            |
	// graph[i][1]------------graph[i]--------------graph[i][2]
	//                            |
	//                            |
	//                            |
	//                            |
	//                        graph[i][3]
	
	// the array looks like
	// graph[1] = [[0,3], [2,3], [13,3], [27,inf]];
	// each graph[x][y] is an eight-bit value
	
	// the given graph is stored as a 2D array in ROM


	initial begin
		graph[0][0] = {5'd1, 3'd3};
		graph[0][1] = {5'd27, 3'd7};
		graph[0][2] = {5'd27, 3'd7};
		graph[0][3] = {5'd27, 3'd7};

		graph[1][0] = {5'd0, 3'd3};
		graph[1][1] = {5'd2, 3'd3};
		graph[1][2] = {5'd13, 3'd3};
		graph[1][3] = {5'd27, 3'd7};

		graph[2][0] = {5'd3, 3'd1};
		graph[2][1] = {5'd1, 3'd3};
		graph[2][2] = {5'd5, 3'd3};
		graph[2][3] = {5'd27, 3'd7};

		graph[3][0] = {5'd2, 3'd1};
		graph[3][1] = {5'd27, 3'd7};
		graph[3][2] = {5'd27, 3'd7};
		graph[3][3] = {5'd27, 3'd7};

		graph[4][0] = {5'd6, 3'd3};
		graph[4][1] = {5'd27, 3'd7};
		graph[4][2] = {5'd27, 3'd7};
		graph[4][3] = {5'd27, 3'd7};

		graph[5][0] = {5'd6, 3'd1};
		graph[5][1] = {5'd9, 3'd2};
		graph[5][2] = {5'd2, 3'd3};
		graph[5][3] = {5'd27, 3'd7};

		graph[6][0] = {5'd5, 3'd1};
		graph[6][1] = {5'd4, 3'd3};
		graph[6][2] = {5'd16, 3'd3};
		graph[6][3] = {5'd27, 3'd7};

		graph[7][0] = {5'd12, 3'd2};
		graph[7][1] = {5'd27, 3'd7};
		graph[7][2] = {5'd27, 3'd7};
		graph[7][3] = {5'd27, 3'd7};

		graph[8][0] = {5'd9, 3'd1};
		graph[8][1] = {5'd27, 3'd7};
		graph[8][2] = {5'd27, 3'd7};
		graph[8][3] = {5'd27, 3'd7};

		graph[9][0] = {5'd8, 3'd1};
		graph[9][1] = {5'd15, 3'd1};
		graph[9][2] = {5'd5, 3'd2};
		graph[9][3] = {5'd27, 3'd7};

		graph[10][0] = {5'd16, 3'd2};
		graph[10][1] = {5'd27, 3'd7};
		graph[10][2] = {5'd27, 3'd7};
		graph[10][3] = {5'd27, 3'd7};

		graph[11][0] = {5'd12, 3'd3};
		graph[11][1] = {5'd27, 3'd7};
		graph[11][2] = {5'd27, 3'd7};
		graph[11][3] = {5'd27, 3'd7};

		graph[12][0] = {5'd13, 3'd1};
		graph[12][1] = {5'd7, 3'd2};
		graph[12][2] = {5'd11, 3'd3};
		graph[12][3] = {5'd17, 3'd3};

		graph[13][0] = {5'd12, 3'd1};
		graph[13][1] = {5'd18, 3'd2};
		graph[13][2] = {5'd1, 3'd3};
		graph[13][3] = {5'd27, 3'd7};

		graph[14][0] = {5'd15, 3'd1};
		graph[14][1] = {5'd27, 3'd7};
		graph[14][2] = {5'd27, 3'd7};
		graph[14][3] = {5'd27, 3'd7};

		graph[15][0] = {5'd9, 3'd1};
		graph[15][1] = {5'd14, 3'd1};
		graph[15][2] = {5'd22, 3'd1};
		graph[15][3] = {5'd27, 3'd7};

		graph[16][0] = {5'd10, 3'd2};
		graph[16][1] = {5'd23, 3'd2};
		graph[16][2] = {5'd6, 3'd3};
		graph[16][3] = {5'd27, 3'd7};

		graph[17][0] = {5'd12, 3'd3};
		graph[17][1] = {5'd27, 3'd7};
		graph[17][2] = {5'd27, 3'd7};
		graph[17][3] = {5'd27, 3'd7};

		graph[18][0] = {5'd19, 3'd1};
		graph[18][1] = {5'd20, 3'd1};
		graph[18][2] = {5'd13, 3'd2};
		graph[18][3] = {5'd27, 3'd7};

		graph[19][0] = {5'd18, 3'd1};
		graph[19][1] = {5'd27, 3'd1};
		graph[19][2] = {5'd27, 3'd1};
		graph[19][3] = {5'd27, 3'd1};

		graph[20][0] = {5'd18, 3'd1};
		graph[20][1] = {5'd21, 3'd1};
		graph[20][2] = {5'd22, 3'd2};
		graph[20][3] = {5'd27, 3'd7};

		graph[21][0] = {5'd20, 3'd1};
		graph[21][1] = {5'd27, 3'd7};
		graph[21][2] = {5'd27, 3'd7};
		graph[21][3] = {5'd27, 3'd7};

		graph[22][0] = {5'd15, 3'd1};
		graph[22][1] = {5'd23, 3'd1};
		graph[22][2] = {5'd20, 3'd2};
		graph[22][3] = {5'd25, 3'd3};

		graph[23][0] = {5'd22, 3'd1};
		graph[23][1] = {5'd16, 3'd2};
		graph[23][2] = {5'd24, 3'd2};
		graph[23][3] = {5'd27, 3'd7};

		graph[24][0] = {5'd23, 3'd2};
		graph[24][1] = {5'd27, 3'd7};
		graph[24][2] = {5'd27, 3'd7};
		graph[24][3] = {5'd27, 3'd7};

		graph[25][0] = {5'd22, 3'd3};
		graph[25][1] = {5'd27, 3'd7};
		graph[25][2] = {5'd27, 3'd7};
		graph[25][3] = {5'd27, 3'd7};

		graph[26][0] = {5'd27, 3'd7};
	end
	
    assign graph_op = {graph[currnode][3], graph[currnode][2], graph[currnode][1], graph[currnode][0]};
endmodule
