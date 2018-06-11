
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
	begin
		if (registerWrite == 1'b1) begin
			registers[writeAddress] <= writeData;
		end
	end
end

// rs and rt
always_comb begin
	if (registerRead == 1'b1) begin
		// Output values for the input addresses.
		unique case(rsAddress)
			5'd0:
				begin
					readValue0 = 32'd0;
				end
			default:
				begin
					readValue0 = registers[rsAddress];
				end
		endcase
		unique case(rtAddress)
			5'd0:
				begin
					readValue1 = 32'd0;
				end
			default:
				begin
					readValue1 = registers[rtAddress];
				end
		endcase

	end
	else
	begin
		// Not reading from registers
		readValue0 = 32'd0;
		readValue1 = 32'd0;
	end
end

endmodule