// verilog description of a cartesian graph 
// 26 nodes 

module cartesian_graph(
    input[4:0] n1, n2, n3,
    output [2:0] x1, x2, x3, y1, y2, y3
);
    reg [5:0] node [4:0];

    initial begin 
        // node[0] = {3'd0, 3'd0};
        node[0] = {3'd0, 3'd0};
        node[1] = {3'd2, 3'd0};
        node[2] = {3'd3, 3'd0};
        node[3] = {3'd3, 3'd1};
        node[4] = {3'd7, 3'd0};
        node[5] = {3'd4, 3'd0};
        node[6] = {3'd6, 3'd0};
        node[7] = {3'd1, 3'd1};
        node[8] = {3'd3, 3'd2};
        node[9] = {3'd4, 3'd2};
        node[10] = {3'd5, 3'd3};
        node[11] = {3'd0, 3'd2};
        node[12] = {3'd1, 3'd2};
        node[13] = {3'd2, 3'd2};
        node[14] = {3'd3, 3'd3};
        node[15] = {3'd4, 3'd3};
        node[16] = {3'd6, 3'd3};
        node[17] = {3'd1, 3'd3};
        node[18] = {3'd2, 3'd4};
        node[19] = {3'd2, 3'd5};
        node[20] = {3'd3, 3'd4};
        node[21] = {3'd3, 3'd5};
        node[22] = {3'd4, 3'd4};
        node[23] = {3'd6, 3'd4};
        node[24] = {3'd6, 3'd5};
        node[25] = {3'd4, 3'd5};

    end

    assign x1 = (node[n1])[5:3];
    assign y1 = (node[n1])[2:0];
    assign x2 = (node[n2])[5:3];
    assign y2 = (node[n2])[2:0];
    assign x3 = (node[n3])[5:3];
    assign y3 = (node[n3])[2:0];
    

endmodule