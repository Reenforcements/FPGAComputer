package MIPSInstructionPackage;
typedef enum logic [5:0] {
	/*
	Covers:
	NOP
	ADD
	ADDU
	AND
	DIV
	DIVU
	MULT
	MULTU
	NOR
	OR
	SLL
	SLLV
	SRA
	SRAV
	SRL
	SRLV
	SUB
	SUBU
	XOR
	SLT
	SLTU
	JR
	JALR
	MFHI
	MFLO
	MTHI
	MTLO
	*/
	NON_IMMEDIATE_ALU = 6'h0,

	// The immediate instructions have to have different
	//  OP codes because there's no room to specify the function
	//  or shift amount due to the size of the immediate.
	ADDI = 6'h8,
	ADDUI = 6'h9,

	ANDI = 6'hC,
	ORI = 6'hD,
	XORI = 6'hE,

	LUI = 6'hF,

	SLTI = 6'hA,
	SLTIU = 6'hB,

	BC1T_BC1F = 6'h11,
	BEQ = 6'h4,
	BGEZ_BGEZAL_BLTZAL_BLTZ = 6'h1,
	BGTZ = 6'h7,
	BLEZ = 6'h6,
	BNE = 6'h5,
	
	J = 6'h2,
	JAL = 6'h3,
	
	LB = 6'h20,
	LBU = 6'h24,
	LH = 6'h21,
	LHU = 6'h25,
	LW = 6'h23,
	LWC1 = 6'h31,
	LWL = 6'h22,
	LWR = 6'h26,
	
	SB = 6'h28,
	SH = 6'h29,
	SW = 6'h2B,
	SWC1 = 6'h21,
	SWL = 6'h2A,
	SWR = 6'h2E,
	
	MFC1_MTC1 = 6'h11,

	// Return from exception
	RFE = 6'h10
	
	
} OPCode;
endpackage

package ControlLinePackage;

typedef enum logic [1:0] {
	RD = 2'h0,
	RT = 2'h1,
	RA = 2'h2
} WriteAddressModes;

typedef enum logic [1:0] {
	NONE = 2'd0,
	NEXT_PC_ADDRESS = 2'd1,
	DATA_OUTPUT = 2'd2,
	RESULT = 2'd3
} WriteSourceModes;

endpackage


import MIPSInstructionPackage::*;
import ControlLinePackage::WriteAddressModes;
import ALUFunctCodesPackage::FunctCodes;
import MemoryModesPackage::ReadWriteModes;
import BranchModesPackage::BranchModes;

module Control(
input logic clk,
input logic rst,
input logic [31:0]instructionData,

// Register File
output logic registerRead,
output logic registerWrite,
output logic [1:0]registerWriteAddressMode,
output logic [1:0]registerWriteSource,

// ALU
output logic [5:0]funct,
output logic [4:0]shamt,
output logic useImmediate,

// Memory
output logic [2:0]readMode,
output logic [2:0]writeMode,
output logic unsignedLoad,

// Branching
output logic [3:0]branchMode
);

logic [5:0]opCode;
always_comb begin
	opCode = instructionData[31:26];
	unique case (opCode)

		// Default is also NOP
		default: begin
			registerRead = 0;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RD;
			registerWriteSource = ControlLinePackage::NONE;

			funct = ALUFunctCodesPackage::OR;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		
	endcase
end


endmodule

