module Memory(
	input logic clk,
	input logic rst,

	input logic address[31:0],
	input logic data[31:0],
	input logic writeMode[1:0],
	input logic readMode[1:0],

	input logic unalignedLeft,
	input logic unalignedRight,

	input logic pcAddress[31:0],


	output logic dataOutput[31:0],
	output logic pcDataOutput[31:0]
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
	unique case (readMode)
		NONE: begin
			readData0 = 32'b0;
		end
		BYTE: begin
			
		end
		HALFWORD: begin
			
		end
		WORD: begin
			
		end
		default: begin end
	endcase
	unique case (writeMode)
		default: begin end
	endcase
end

endmodule