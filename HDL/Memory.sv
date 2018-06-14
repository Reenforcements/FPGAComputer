module Memory(
	input logic clk,
	input logic rst,

	input logic [31:0]address,
	input logic [31:0]data,
	input logic [1:0]writeMode,
	input logic [1:0]readMode,

	input logic unsignedLoad,
	input logic unalignedLeft,
	input logic unalignedRight,

	input logic [31:0]pcAddress,


	output logic [31:0]dataOutput,
	output logic [31:0]pcDataOutput
);

// Modes for "readMode" and "writeMode"
typedef enum logic [1:0] {
	NONE = 2'h0,
	BYTE = 2'h1,
	HALFWORD = 2'h2,
	WORD = 2'h3
} readWriteModes;

// 2^16 bytes of memory
logic [7:0]memory[65535:0];

always_ff @(posedge clk or negedge rst) begin
	if (rst == 1'b1) begin
		
	end
	else begin
		
	end
end

logic [31:0]readData0;
logic [31:0]writeData0;

always_comb begin
	logic [31:0]baseAddress;
	baseAddress = {{16{1'b0}}, address[15:0]};
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
			// This is the only case where lwl and lwr can occur.
		end
		default: begin 
			readData0 = 32'b0; 
		end
	endcase
	unique case (writeMode)
		default: begin 
			writeData0 = 32'b0; 
		end
	endcase
end

endmodule