module ALU(
input logic clk,
input logic rst,

input logic [31:0]dataIn0,
input logic [31:0]dataIn1,
input logic [4:0]shamt,
input logic [5:0]funct,

output logic [31:0]result,
output logic outputZero,
output logic outputNegative,
output logic outputPositive
);

// Make sure Quartus is set to user encoded.
typedef enum logic [5:0] {
	ADD = 6'h20,
	ADDU = 6'h21,
	SUB = 6'h22,
	SUBU = 6'h23,
	MUL = 6'h18,
	MULU = 6'h19,
	DIV = 6'h1a,
	DIVU = 6'h1b,

	AND = 6'h24,
	NOR = 6'h27,
	OR = 6'h25,
	XOR = 6'h26,

	SLL = 6'h0,
	SLLV = 6'h4,
	SRA = 6'h3,
	SRAV = 6'h7,
	SRL = 6'h2,
	SRLV = 6'h6,

	SLT = 6'h2a,
	SLTU = 6'h2b,
	
	MFHI = 6'h10,
	MFLO = 6'h12,
	MTHI = 6'h11,
	MTLO = 6'h13
	
} functCodes;

logic carry;
logic [31:0]hiResult;
logic [31:0]loResult;
logic [31:0]lo;
logic [31:0]hi;

always_ff @(posedge clk or negedge rst) begin
	if (rst == 1'b1) begin
		
	end
	else
	begin
		// Save hi and lo on the clock, but only for certain instructions
		unique case (funct)
			MUL,
			MULU,
			DIV,
			DIVU: begin
				lo <= loResult;
				hi <= hiResult;
			end
			MTHI: begin
				hi <= hiResult;
			end
			MTLO: begin
				lo <= loResult;
			end
			default: begin end
		endcase
	end
end

always_comb begin
	// Make sure result is always driven
	result = 0;
	unique case (funct)

		ADD: begin
			{carry, result} = signed'(dataIn0) + signed'(dataIn1);
		end
		ADDU: begin
			result = unsigned'(dataIn0) + unsigned'(dataIn1);
		end
		SUB: begin
			{carry, result} = signed'(dataIn0) - signed'(dataIn1);
		end
		SUBU: begin
			result = unsigned'(dataIn0) - unsigned'(dataIn1);
		end
		MUL: begin
			// Multiplication goes into hi and lo
			//  on the clock above.
			{hiResult, loResult} = signed'(dataIn0) * signed'(dataIn1);
		end
		MULU: begin
			{hiResult, loResult} = unsigned'(dataIn0) * unsigned'(dataIn1);
		end
		DIV: begin
			{hiResult, loResult} = signed'(dataIn0) / signed'(dataIn1);
		end
		DIVU: begin
			{hiResult, loResult} = unsigned'(dataIn0) / unsigned'(dataIn1);
		end
		

		AND: begin
			result = dataIn0 & dataIn1;
		end
		NOR: begin
			result = ~(dataIn0 | dataIn1);
		end
		OR: begin
			result = dataIn0 | dataIn1;
		end
		XOR: begin
			result = dataIn0 ^ dataIn1;
		end

		
		SLL: begin
			result = dataIn0 << unsigned'(shamt);
		end
		SLLV: begin
			// Don't bother shifting if the shift is
			//  greater than 32 bits.
			if (unsigned'(dataIn1) >= 32'd32) begin
				result = 32'b0;
			end
			else begin
				result = dataIn0 << unsigned'(dataIn1[4:0]);
			end
		end
		SRL: begin
			result = dataIn0 >> unsigned'(shamt);
		end
		SRLV: begin
			// Don't bother shifting if the shift is
			//  greater than 32 bits.
			if (unsigned'(dataIn1) >= 32'd32) begin
				result = 32'b0;
			end
			else begin
				result = dataIn0 >> unsigned'(dataIn1[4:0]);
			end
		end

		SRA: begin
			result = signed'(dataIn0) >>> unsigned'(shamt);
		end
		SRAV: begin
			// If the number is negative, shifting 32 or
			//  more should always produce -1.
			// If the number is positive, shifting 32 or
			//  more should always produce 0.
			if (unsigned'(dataIn1) >= 32'd32) begin
				if(dataIn0[31] == 1'b1) begin
					// Always -1
					result = -(32'd1);
				end
				else begin
					// Always 0
					result = 0;
				end
			end
			else begin
				// The shift is < 32.
				result = signed'(dataIn0) >>> unsigned'(dataIn1[4:0]);
			end
		end


		SLT: begin
			result = {31'b0, signed'(dataIn0) < signed'(dataIn1)};
		end
		SLTU: begin
			result = {31'b0, unsigned'(dataIn0) < unsigned'(dataIn1)};
		end


		MFHI: begin
			result = hi;
		end
		MFLO: begin
			result = lo;
		end
		MTHI: begin
			hiResult = dataIn0;
		end
		MTLO: begin
			loResult = dataIn0;
		end


		default: begin
			{hiResult, loResult} = 0;
			result = 0;
 		end
	endcase

	// Should this take lo and hi into account?
	outputZero = (result == 32'b0) ? 1'b1 : 1'b0;
	outputNegative = (result[31] == 1'b1) ? 1'b1 : 1'b0;
	outputPositive = (~outputNegative) & !outputZero;
end

endmodule