
// This module implements the register file
//  of the processor.

module RegisterFile(
input logic clk,
input logic rst,
input logic [4:0]rsAddress,
input logic [4:0]rtAddress,
input logic [4:0]writeAddress,

input logic registerRead,
input logic registerWrite,

input logic [31:0]writeData,

output logic [31:0]readValue0,
output logic [31:0]readValue1
);

// 31, 32 bit registers
// The 32nd register is always zero.
logic [31:0]registers[0:31];


always_ff @(posedge clk or negedge rst) begin
	if(rst == 1'b1) begin:reset
		
	end:reset
	else
	begin:clk

	end:clk
end

// rs
always_comb begin
	unique case()

	endcase
end

// rt

// write

endmodule