package BranchModesPackage;
// Certain branch commands use rt as their "funct"
typedef enum logic [3:0] {

// These have specific values
BranchMode_BGEZ = 4'h1,
BranchMode_BLTZ = 4'h0,

// These can be anything.
BranchMode_NONE = 4'h2,
BranchMode_BEQ = 4'h3,
BranchMode_BGTZ = 4'h4,
BranchMode_BLEZ = 4'h5,
BranchMode_BNE = 4'h6,
BranchMode_BC1T = 4'h7,
BranchMode_BC1F = 4'h8,
BranchMode_J = 4'h9,
BranchMode_JR = 4'hA
} BranchModes;

typedef enum logic [4:0] {
// These are paired with BranchMode_BGEZ and BranchMode_BLTZ above but
//  they have a "1" in the 16's place
BranchMode_BGEZAL = 5'h11,
BranchMode_BLTZAL = 5'h10
} LinkBranchModes;

endpackage

import BranchModesPackage::*;
module Branch(
input logic clk,
input logic rst,
input logic [3:0]mode,

input logic [31:0]pcAddress,
input logic signed[15:0]branchAddressOffset,
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
		BranchMode_NONE: begin
			branchCompareResult = 0;
		end
		BranchMode_BEQ: begin
			branchCompareResult = resultZero && !resultNegative && !resultPositive;
		end
		BranchMode_BGEZ: begin
			branchCompareResult = (resultZero || resultPositive) && !resultNegative;
		end
		BranchMode_BGTZ: begin
			branchCompareResult = resultPositive && !resultZero && !resultNegative;
		end
		BranchMode_BLEZ: begin
			branchCompareResult = !resultPositive && (resultZero || resultNegative);
		end
		BranchMode_BLTZ: begin
			branchCompareResult = !resultPositive && !resultZero && resultNegative;
		end
		BranchMode_BNE: begin
			branchCompareResult = (resultPositive || resultNegative) && !resultZero;
		end
		BranchMode_BC1T: begin
			branchCompareResult = 0;
		end
		BranchMode_BC1F: begin
			branchCompareResult = 0;
		end
		BranchMode_J: begin
			branchCompareResult = 1;
		end
		BranchMode_JR: begin
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
			BranchMode_NONE: begin
				branchTo = 32'b0;
			end

			BranchMode_BEQ,
			BranchMode_BGEZ,
			BranchMode_BGTZ,
			BranchMode_BLEZ,
			BranchMode_BLTZ,
			BranchMode_BNE,
			BranchMode_BC1T,
			BranchMode_BC1F: begin
				// Branches take into account the pc being auto
				//  incremented by 4 every clock cycle. The compiler
				//  (or assembly code author) takes this into account.
				
				// However, branches count by instruction, not by byte
				// We need to multiply by 4 to convert to bytes.
				logic signed[31:0]sBranchAddressOffset;
				sBranchAddressOffset = 32'(branchAddressOffset) << 32'd2;
				branchTo = pcAddress + sBranchAddressOffset;
				/*$display("Branching to %d + %d = %d", 
						sBranchAddressOffset,
						pcAddress,
						branchTo);*/
			end

			BranchMode_J: begin
				// Jumping uses the four MBbs of the PC,
				//  the jump address, and then the two LSBs
				//  are zero because instructions are word aligned.
				branchTo = {pcAddress[31:28], jumpAddress, 2'b0} - 32'd4;
			end

			BranchMode_JR: begin
				branchTo = jumpRegisterAddress - 32'd4;
			end

			default: begin
				branchTo = 32'd0;
			end
		endcase
	end
	else begin
		branchTo = {32'hxxxxxxxx};
	end
end


endmodule
