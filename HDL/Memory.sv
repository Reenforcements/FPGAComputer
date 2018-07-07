
package MemoryModesPackage;
// Modes for "readMode" and "writeMode"
typedef enum logic [2:0] {
	ReadWriteMode_NONE = 3'h0,
	BYTE = 3'h1,
	HALFWORD = 3'h2,
	WORD = 3'h3,
	WORDLEFT = 3'h4,
	WORDRIGHT = 3'h5
} ReadWriteModes;
endpackage

import MemoryModesPackage::*;

module Memory(
	input logic clk,
	input logic rst,

	input logic [31:0]address,
	input logic [31:0]data,
	input logic [2:0]writeMode,
	input logic [2:0]readMode,

	input logic unsignedLoad,

	input logic [31:0]pcAddress,

	output logic [31:0]dataOutput,
	output logic [31:0]pcDataOutput
);

// a is used for reading/writing
// b is strictly used for PC data
logic	[15:0]address_a;
logic	[15:0]address_b;
logic	[3:0]byteena_a;
logic	[31:0]data_a;
logic	[31:0]data_b;
logic	  rden_a;
logic	  rden_b;
logic	  wren_a;
logic	  wren_b;

logic	[31:0]q_a;
logic	[31:0]q_b;

RAM32Bit ram(
	.address_a(address_a),
	.address_b(address_b),
	.byteena_a(byteena_a),
	.clock(clk),
	.data_a(data_a),
	.data_b(data_b),
	.rden_a(rden_a),
	.rden_b(rden_b),
	.wren_a(wren_a),
	.wren_b(wren_b),
	.q_a(q_a),
	.q_b(q_b));


logic [15:0]baseAddress;
logic [15:0]wordAlignedBase;
logic [1:0]byteOffset;

// Set control lines common to reading/writing
always_comb begin
	baseAddress = address[15:0];
	wordAlignedBase = {baseAddress[15:2], 2'b0};
	byteOffset = address[1:0];
	
	// Set the RAM's read/write enables.
	if (writeMode != ReadWriteMode_NONE) begin
		// We're writing
		wren_a = 1'b1;
		rden_a = 1'b0;
	end 
	else if (readMode != ReadWriteMode_NONE) begin
		// We're reading
		wren_a = 1'b0;
		rden_a = 1'b1;
	end 
	else begin
		// Neither
		wren_a = 1'b0;
		rden_a = 1'b0;
	end
	
	// Read/write address
	// Use the word aligned base because our RAM uses
	//  32 bit words.
	// We adjust the input data separately to write single bytes, etc.
	address_a = wordAlignedBase;
end

// Determine byte_enable mask if we're writing.
always_comb begin
	// How many bits should we shift our byte/halfword?
	logic [4:0]writeShiftAmount;
	writeShiftAmount = (5'd8 * byteOffset);
	
	unique case (writeMode)
		BYTE: begin
			// Adjust the byte enable to write to the correct
			//  byte within the word.
			byteena_a = 4'b0001 << byteOffset;
			// Shift our input data to match the byte position specified.
			data_a = data << writeShiftAmount;
		end
		HALFWORD: begin
			byteena_a = 4'b0011 << byteOffset;
			data_a = data << writeShiftAmount;
		end
		WORD: begin
			// Writing full words is easy.
			byteena_a = 4'b1111;
			data_a = data;
		end
		WORDLEFT: begin
			logic [3:0]byteen;
			byteen = 4'b1111;
			byteena_a = byteen >> (2'd3 - byteOffset);
			// Shift our input data right until it aligns with byteena_a
			data_a = data >> ( 5'd8 * (2'd3 - byteOffset));
		end
		WORDRIGHT: begin
			logic [3:0]byteen;
			byteen = 4'b1111;
			byteena_a = byteen << byteOffset;
			
			data_a = data << (5'd8 * byteOffset);
		end
		default: begin
			byteena_a = 4'd0;
			data_a = 32'd0;
		end
	endcase
end

// Delayed lines so we can adjust our read value after it appears
//  a clock cycle later.
logic [31:0]address_d0;
logic [3:0]readMode_d0;
logic unsignedLoad_d0;
logic rden_a_d0;

always_ff @(posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		address_d0 <= 32'd0;
		readMode_d0 <= ReadWriteMode_NONE;
		unsignedLoad_d0 <= 0;
		rden_a_d0 <= 0;
	end
	else begin
		// Save certain control lines so we can adjust the output
		//  if we're reading.
		address_d0 <= address;
		readMode_d0 <= readMode;
		unsignedLoad_d0 <= unsignedLoad;
		rden_a_d0 <= rden_a;
	end
end

// Now that we have our output, we can adjust it to what the
//  input lines originally wanted.
always_comb begin
	// Make sure the last thing we did was read and not write.
	dataOutput = {32{1'bx}};
	if (rden_a_d0 == 1'b1) begin
		unique case (readMode_d0)
				BYTE: begin
					// Output the byte and sign extend if needed
					dataOutput = { 
					(unsignedLoad_d0 == 1'b0 & (q_a[7] == 1'b1)) ? {24{1'b1}} : {24{1'b0}}, 
					8'( (q_a >> (5'd8 * address[1:0])) & (32'h000000FF) )
					};
				end
				HALFWORD: begin
					dataOutput = { 
					(unsignedLoad_d0 == 1'b0 & (q_a[15] == 1'b1)) ? {16{1'b1}} : {16{1'b0}}, 
					16'( (q_a >> (5'd8 * address[1:0])) & (32'h0000FFFF << (5'd8 * address[1:0])))
					};
				end
				WORD: begin
					dataOutput = q_a;
				end
				WORDLEFT: begin
					logic [1:0]byteShift;
					byteShift = address_d0[1:0];
					dataOutput = q_a << (5'd8 * (2'd3 - byteShift));
				end
				WORDRIGHT: begin
					logic [1:0]byteShift;
					byteShift = address_d0[1:0];
					dataOutput = q_a >> (5'd8 * byteShift);
				end
				default: begin
					// Do nothing to q_a
					dataOutput = q_a;
				end
		endcase
	end
end

// PC related things:
// Output next instruction
always_comb begin
	rden_b = 1'b1;
	wren_b = 1'b0;
	address_b = pcAddress[15:0];
	pcDataOutput = q_b;
end

endmodule