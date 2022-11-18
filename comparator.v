// COMPARATOR
// 32 7-bit numbers
// Find the minimum of them
module find_smallest(
	input [6:0] num[0:31],
	output [6:0] smallest);
	
	reg [7:0] stage1 [0:15];
	reg [7:0] stage2 [0:7];
	reg [7:0] stage3 [0:3];
	reg [7:0] stage4 [0:1];
	reg [7:0] smol;
	
	assign smallest = smol;
	
	always@(*) begin
		// compute stage-1 regs
		stage1[0] = num[0] > num[1] ? num[1] : num[0];
		stage1[1] = num[2] > num[3] ? num[3] : num[2];
		stage1[2] = num[4] > num[5] ? num[5] : num[4];
		stage1[3] = num[6] > num[7] ? num[7] : num[6];
		stage1[4] = num[8] > num[9] ? num[9] : num[8];
		stage1[5] = num[10] > num[11] ? num[11] : num[10];
		stage1[6] = num[12] > num[13] ? num[13] : num[12];
		stage1[7] = num[14] > num[15] ? num[15] : num[14];
		stage1[8] = num[16] > num[17] ? num[17] : num[16];
		stage1[9] = num[18] > num[19] ? num[19] : num[18];
		stage1[10] = num[20] > num[21] ? num[21] : num[20];
		stage1[11] = num[22] > num[23] ? num[23] : num[22];
		stage1[12] = num[24] > num[25] ? num[25] : num[24];
		stage1[13] = num[26] > num[27] ? num[27] : num[26];
		stage1[14] = num[28] > num[29] ? num[29] : num[28];
		stage1[15] = num[30] > num[31] ? num[31] : num[30];

		// compute stage-2
		stage2[0] = stage1[0] > stage1[1] ? stage1[1] : stage1[0];
		stage2[1] = stage1[2] > stage1[3] ? stage1[3] : stage1[2];
		stage2[2] = stage1[4] > stage1[5] ? stage1[5] : stage1[4];
		stage2[3] = stage1[6] > stage1[7] ? stage1[7] : stage1[6];
		stage2[4] = stage1[8] > stage1[9] ? stage1[9] : stage1[8];
		stage2[5] = stage1[10] > stage1[11] ? stage1[11] : stage1[10];
		stage2[6] = stage1[12] > stage1[13] ? stage1[13] : stage1[12];
		stage2[7] = stage1[14] > stage1[15] ? stage1[15] : stage1[14];

		// compute stage-3
		stage3[0] = stage2[0] > stage2[1] ? stage2[1] : stage2[0];
		stage3[1] = stage2[2] > stage2[3] ? stage2[3] : stage2[2];
		stage3[2] = stage2[4] > stage2[5] ? stage2[5] : stage2[4];
		stage3[3] = stage2[6] > stage2[7] ? stage2[7] : stage2[6];
		
		// compute stage-4
		stage4[0] = stage3[0] > stage3[1] ? stage3[1] : stage3[0];
		stage4[1] = stage3[2] > stage3[3] ? stage3[3] : stage3[2];
		
		// compute stage-5
		smol = stage4[0] > stage4[1] ? stage4[1] : stage4[0];
	end
endmodule