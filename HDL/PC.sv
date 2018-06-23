module PC(
input logic clk,
input logic rst,

input logic shouldUseNewPC,
input logic [31:0]newPC,

output logic [31:0]pcAddress,
// nextPCAddress is used for linking
output logic [31:0]nextPCAddress
);

logic [31:0]currentPC = 32'h00400000;

logic [31:0]oldPC;
always_comb begin
	// Are we jumping/branching or just counting?
	if (shouldUseNewPC) begin
		// New PC is the branch/jump address
		oldPC = newPC;
	end
	else begin
		oldPC = currentPC;
	end

	

	// Always add 4
	// The compiler/assembly author will know this
	//  and take it into account in their code.
	//nextPC = oldPC + 32'h4;
	// This is the next address, used if we need to link.
	nextPCAddress = oldPC + 32'h4;
end

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		currentPC <= 32'h400000;
	end
	else begin
		// Update to next PC on the clock
		currentPC <= oldPC + 32'h4;
	end
end

always_comb begin
	// Update the PC output
	pcAddress = currentPC;
end

endmodule