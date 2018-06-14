module Memory(
	input logic clk,
	input logic rst,

	input logic [31:0]address,
	input logic [31:0]data,
	input logic [2:0]writeMode,
	input logic [2:0]readMode,

	input logic unsignedLoad,
	input logic unalignedLeft,
	input logic unalignedRight,

	input logic [31:0]pcAddress,


	output logic [31:0]dataOutput,
	output logic [31:0]pcDataOutput
);

// Modes for "readMode" and "writeMode"
typedef enum logic [2:0] {
	NONE = 3'h0,
	BYTE = 3'h1,
	HALFWORD = 3'h2,
	WORD = 3'h3,
	WORDLEFT = 3'h4,
	WORDRIGHT = 3'h5
} readWriteModes;

// 2^16 bytes of memory
logic [7:0]memory[65535:0];

logic [15:0]baseAddress;
logic [31:0]readData0;
logic [31:0]writeData0;
logic [3:0]writeMask;

always_comb begin
	baseAddress = address[15:0];

	unique case (readMode)
		NONE: begin
			readData0 = 32'b0;
		end
		BYTE: begin
			// Get a single byte from memory
			logic [7:0]singleByte;
			singleByte = memory[ baseAddress ];
			if (unsignedLoad) begin
				// Don't sign extend
				readData0 = { {24{1'b0}}, singleByte};
			end else begin
				// Sign extend using the MSb
				// (Can't use replication operator here :( )
				if (singleByte[7] == 1'b1)
					readData0 = { {24{1'b1}}, singleByte};
				else
					readData0 = { {24{1'b0}}, singleByte};
			end
		end
		HALFWORD: begin
			// Get a halfword from memory
			logic [15:0]singleHalfword;
			// "+:" is called array slicing.
			// "16'" is a cast.
			// In this case, its returning:
			// { memory[baseAddress + 32'b1], memory[baseAddress] }
			singleHalfword = 16'(memory[baseAddress+:1]);
			if (unsignedLoad) begin
				// Don't sign extend
				readData0 = { {16{1'b0}}, singleHalfword};
			end else begin
				// Sign extend using the MSb
				// (Can't use replication operator here :( )
				if (singleHalfword[15] == 1'b1)
					readData0 = { {16{1'b1}}, singleHalfword};
				else
					readData0 = { {16{1'b0}}, singleHalfword};
			end
		end
		WORD: begin
			// lw
			readData0 = 32'(memory[baseAddress+:4]);
		end
		WORDLEFT: begin
			// lwl
			// count down to word boundary
				
			// See how many bytes we have until the
			//  right word boundary.
			unique case (baseAddress[1:0])
				2'd3: begin
					readData0 = 32'(memory[baseAddress-:3]);
				end
				2'd2: begin
					readData0 = {24'(memory[baseAddress-:2]), {8{1'b0}}};
				end
				2'd1: begin
					readData0 = {16'(memory[baseAddress-:1]), {16{1'b0}}};
				end
				2'd0: begin
					readData0 = {8'(memory[baseAddress]), {24{1'b0}}};
				end
			endcase
		end
		WORDRIGHT: begin
			// lwr
			// count up to word boundary
			unique case (baseAddress[1:0])
				2'd0: begin
					readData0 = 32'(memory[baseAddress+:3]);
				end
				2'd1: begin
					readData0 = {{8{1'b0}}, 24'(memory[baseAddress+:2])};
				end
				2'd2: begin
					readData0 = {{16{1'b0}}, 16'(memory[baseAddress+:1])};
				end
				2'd3: begin
					readData0 = {{24{1'b0}}, 8'(memory[baseAddress])};
				end
			endcase

		end
		default: begin 
			readData0 = 32'b0; 
		end
	endcase
	unique case (writeMode)
		NONE: begin
			writeData0 = 32'b0;
			writeMask = 4'b0;
		end
		BYTE: begin
			writeData0 = data[7:0];
			writeMask = {1'b0, 1'b0, 1'b0, 1'b1};
		end
		HALFWORD: begin
			writeData0 = data[15:0];
			writeMask = {1'b0, 1'b0, 1'b1, 1'b1};
		end
		WORD: begin
			writeData0 = data[31:0];
			writeMask = {1'b1, 1'b1, 1'b1, 1'b1};
		end
		WORDLEFT: begin
			//swl
			unique case (baseAddress[1:0])
				2'd3: begin
					writeData0 = data;
					writeMask = {1'b1, 1'b1, 1'b1, 1'b1};
				end
				2'd2: begin
					writeData0[23:0] = data[31:8];
					writeMask = {1'b0, 1'b1, 1'b1, 1'b1};
				end
				2'd1: begin
					writeData0[15:0] = data[31:16];
					writeMask = {1'b0, 1'b0, 1'b1, 1'b1};
				end
				2'd0: begin
					writeData0[7:0] = data[31:24];
					writeMask = {1'b0, 1'b0, 1'b0, 1'b1};
				end
			endcase
		end
		WORDRIGHT: begin
			//swr
			unique case (baseAddress[1:0])
				2'd0: begin
					writeData0 = data;
					writeMask = {1'b1, 1'b1, 1'b1, 1'b1};
				end
				2'd1: begin
					writeData0[31:8] = data[23:0];
					writeMask = {1'b1, 1'b1, 1'b1, 1'b0};
				end
				2'd2: begin
					writeData0[31:16] = data[15:0];
					writeMask = {1'b1, 1'b1, 1'b0, 1'b0};
				end
				2'd3: begin
					writeData0[31:24] = data[7:0];
					writeMask = {1'b1, 1'b0, 1'b0, 1'b0};
				end
			endcase
		end

		default: begin 
			writeData0 = 32'b0; 
		end
	endcase
end

always_ff @(posedge clk or negedge rst) begin
	if (rst == 1'b1) begin
		
	end
	else begin
		// Write on the clock
		// Only write the bytes that we have values for.
		if (writeMask[3] == 1'b1) begin
			memory[baseAddress + 16'd3] <= writeData0[3];
		end
		if (writeMask[2] == 1'b1) begin
			memory[baseAddress + 16'd2] <= writeData0[2];
		end
		if (writeMask[1] == 1'b1) begin
			memory[baseAddress + 16'd1] <= writeData0[1];
		end
		if (writeMask[0] == 1'b1) begin
			memory[baseAddress] <= writeData0[0];
		end
	end
end

endmodule