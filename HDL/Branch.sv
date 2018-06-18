package BranchModesPackage;
typedef enum logic [3:0] {
NONE = 4'h0,
BEQ = 4'h1,
BGEZ = 4'h2,
BGTZ = 4'h3,
BLEZ = 4'h4,
BLTZ = 4'h5,
BNE = 4'h6,
BC1T = 4'h7,
BC1F = 4'h8,
J = 4'h9,
JR = 4'hA
} BranchMode;
endpackage

import BranchModesPackage::*;
module Branch(
input logic clk,
input logic rst,
input logic [3:0]mode,

input logic [31:0]pcAddress,
input logic [15:0]branchAddressOffset,
input logic [25:0]jumpAddress,
input logic [31:0]jumpRegisterAddress,

input logic resultZero,
input logic resultNegative,
input logic resultPositive,

output logic shouldUseNewPC,
output logic [31:0]branchTo
);

always_ff @(posedge clk or negedge rst) begin
	if (rst == 1'b0) begin

	end 
	else begin

	end
end

// This will be set true by the combitorial
//  block below if the required condition(s)
//  are met.
logic branchCompareResult;
always_comb begin
	unique case (mode)
		NONE: begin
			branchCompareResult = 0;
		end
		BEQ: begin
			branchCompareResult = resultZero && !resultNegative && !resultPositive;
		end
		BGEZ: begin
			branchCompareResult = (resultZero || resultPositive) && !resultNegative;
		end
		BGTZ: begin
			branchCompareResult = resultPositive && !resultZero && !resultNegative;
		end
		BLEZ: begin
			branchCompareResult = !resultPositive && (resultZero || resultNegative);
		end
		BLTZ: begin
			branchCompareResult = !resultPositive && !resultZero && resultNegative;
		end
		BNE: begin
			branchCompareResult = (resultPositive || resultNegative) && !resultZero;
		end
		BC1T: begin
			branchCompareResult = 0;
		end
		BC1F: begin
			branchCompareResult = 0;
		end
		J: begin
			branchCompareResult = 1;
		end
		JR: begin
			branchCompareResult = 1;
		end
		default: begin
			branchCompareResult = 0;
		end
	endcase
	shouldUseNewPC = branchCompareResult;
end

always_comb begin
	// shouldUseNewPC is an output that gets
	//  sent to the PC module to tell it that we're
	//  outputting a branch/jump address.
	if (shouldUseNewPC) begin
		case (mode)
			NONE: begin
				branchTo = 32'b0;
			end

			BEQ,
			BGEZ,
			BGTZ,
			BLEZ,
			BLTZ,
			BNE,
			BC1T,
			BC1F: begin
				// Branches take into account the pc being auto
				//  incremented by 4 every clock cycle. The compiler
				//  (or assembly code author) takes this into account.
				branchTo = pcAddress + 32'(branchAddressOffset);
			end

			J: begin
				// Jumping uses the four MBbs of the PC,
				//  the jump address, and then the two LSBs
				//  are zero because instructions are word aligned.
				branchTo = {pcAddress[31:28], jumpAddress, 2'b0};
			end

			JR: begin
				branchTo = jumpRegisterAddress;
			end

			default: begin end
		endcase
	end
	else begin
		branchTo = {32'hxxxxxxxx};
	end
end


endmodule
