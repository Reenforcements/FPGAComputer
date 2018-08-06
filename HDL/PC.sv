`timescale 1ps / 1ps

module PC(
input logic clk,
input logic rst,

input logic shouldUseNewPC,
input logic [31:0]newPC,

output logic [31:0]pcAddress,
// nextPCAddress is used for linking
output logic [31:0]nextPCAddress,

// This is the address used when the module is reset.
input logic [31:0]resetAddress
);

// The reserved addresses end at 0x00400000, but we don't
//  have that much memory. Let's use 0x400
logic [31:0]currentPC = 32'h3FC;

logic [31:0]oldPC;
always_comb begin
	// Are we jumping/branching or just counting?
	if (shouldUseNewPC) begin
		// New PC is the branch/jump address
		oldPC = newPC;
	end
	else begin
		oldPC = currentPC + 32'h4;
	end

	

	// Always add 4
	// The compiler/assembly author will know this
	//  and take it into account in their code.
	// This is the next address, used if we need to link.
	pcAddress = oldPC;
	nextPCAddress = pcAddress + 32'd4;
end

// We want the reset to run as long as rst == 0
// This is because resetAddress will probably change while
//  we're in the reset state and it needs to be updated.
always_ff @ (posedge clk) begin
	if (rst == 1'b0) begin
		currentPC <= resetAddress;//32'h3FC;
	end
	else begin
		// Update to next PC on the clock
		currentPC <= pcAddress;
	end
end

endmodule