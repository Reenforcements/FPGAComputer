module PC(
input logic clk,
input logic rst,

input logic count,
input logic shouldUseNewPC,
input logic [31:0]newPC,

output logic [31:0]pcAddress,
output logic [31:0]nextPCAddress
);

logic [31:0]currentPC = 32'h00400000;

logic [31:0]nextPC;
always_comb begin
	// Are we jumping/branching or just counting?
	if (shouldUseNewPC) begin
		nextPC = newPC;
	end
	else begin
		nextPC = currentPC;
	end

	// This is used for linking the next instruction
	//  upon branching/jumping.
	nextPCAddress = nextPC + 32'h4;

	// Always add 4 (unless we're not counting)
	// The compiler/assembly author will know this
	//  and take it into account in their code.
	if (count == 1'b1) begin
		nextPC = nextPC + 32'h4;
	end
	else begin
		nextPC = nextPC;
	end
end

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		currentPC <= 32'h400000;
	end
	else begin
		// Update to next PC on the clock.
		currentPC <= nextPC;
	end
end

always_comb begin
	pcAddress = currentPC;
end

endmodule