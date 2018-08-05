
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
	if(rst == 1'b0) begin
		// Initialize the stack pointer to the top of memory.
		registers[5'd0] <= 32'd0;
		registers[5'd1] <= 32'd0;
		registers[5'd2] <= 32'd0;
		registers[5'd3] <= 32'd0;
		registers[5'd4] <= 32'd0;
		registers[5'd5] <= 32'd0;
		registers[5'd6] <= 32'd0;
		registers[5'd7] <= 32'd0;
		registers[5'd8] <= 32'd0;
		registers[5'd9] <= 32'd0;
		registers[5'd10] <= 32'd0;
		registers[5'd11] <= 32'd0;
		registers[5'd12] <= 32'd0;
		registers[5'd13] <= 32'd0;
		registers[5'd14] <= 32'd0;
		registers[5'd15] <= 32'd0;
		registers[5'd16] <= 32'd0;
		registers[5'd17] <= 32'd0;
		registers[5'd18] <= 32'd0;
		registers[5'd19] <= 32'd0;
		registers[5'd20] <= 32'd0;
		registers[5'd21] <= 32'd0;
		registers[5'd22] <= 32'd0;
		registers[5'd23] <= 32'd0;
		registers[5'd24] <= 32'd0;
		registers[5'd25] <= 32'd0;
		registers[5'd26] <= 32'd0;
		registers[5'd27] <= 32'd0;
		registers[5'd28] <= 32'd0;
		registers[5'd29] <= 32'd65532;
		registers[5'd30] <= 32'd0;
		registers[5'd31] <= 32'd0;
	end
	else
	begin
		// Allow a write if registerWrite is enabled
		//  and the write address isn't zero.
		if (registerWrite == 1'b1 &
			writeAddress != 5'b0) begin
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
					// If we're writing the same one, take the most current value.
					if (registerWrite == 1'b1 && rsAddress == writeAddress) begin
						readValue0 = writeData;
					end
					else begin
						// We're not writing to rs right now so just take the stored value.
						readValue0 = registers[rsAddress];
					end
				end
		endcase
		unique case(rtAddress)
			5'd0:
				begin
					readValue1 = 32'd0;
				end
			default:
				begin
					//readValue1 = registers[rtAddress];
					// If we're writing the same one, take the most current value.
					if (registerWrite == 1'b1 && rtAddress == writeAddress) begin
						readValue1 = writeData;
					end
					else begin
						// We're not writing to rs right now so just take the stored value.
						readValue1 = registers[rtAddress];
					end
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