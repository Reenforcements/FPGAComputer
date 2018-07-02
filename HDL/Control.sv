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
	ADDIU = 6'h9,

	ANDI = 6'hC,
	ORI = 6'hD,
	XORI = 6'hE,

	LUI = 6'hF,

	SLTI = 6'hA,
	SLTIU = 6'hB,

	// BC1T, BC1F, MFC1, MTC1 are all 0x11
	BC1T_BC1F_MFC1_MTC1 = 6'h11,
	BEQ = 6'h4,
	BGEZ_BGEZAL_BLTZAL_BLTZ = 6'h1,
	BGTZ = 6'h7,
	BLEZ = 6'h6,
	BNE = 6'h5,
	
	// The documentation for j says its 0x2
	// The compiler turns J into b and has an OPCode of 0x4,
	// which is the same OPCode as BEQ.
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
	SWC1 = 6'h39,
	SWL = 6'h2A,
	SWR = 6'h2E,

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
output logic signExtend,

// Memory
output logic [2:0]readMode,
output logic [2:0]writeMode,
output logic unsignedLoad,

// Branching
output logic [3:0]branchMode
);

logic [5:0]opCodeIn;
logic [4:0]rsIn;
logic [4:0]rtIn;
logic [4:0]rdIn;
logic [4:0]shamtIn;
logic [5:0]functIn;
always_comb begin
	opCodeIn = instructionData[31:26];
	rsIn = instructionData[25:21];
	rtIn = instructionData[20:16];
	rdIn = instructionData[15:11];
	shamtIn = instructionData[10:6];
	functIn = instructionData[5:0];
	
	// Don't care what this is for most instructions.
	signExtend = 1;

	// Change each control line accordingly

	// registerRead
	unique case (opCodeIn)
		
		default: begin
			registerRead = 0;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RD;
			registerWriteSource = ControlLinePackage::NONE;

			funct = ALUFunctCodesPackage::OR;
			shamt = 5'd0;
			useImmediate = 0;
			signExtend = 1;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		// NON_IMMEDIATE_ALU includes NOP
		// "not_immediate_alu" is a block label and just helps
		//   avoid coding errors plus increases readability.
		NON_IMMEDIATE_ALU: begin : not_immediate_alu
			/*
			NON_IMMEDIATE_ALU takes care of all these instructions:
			nop (ALU funct = 0x0)
    		mfhi (ALU funct = 0x10)
    		mthi (ALU funct = 0x11)
    		mflo (ALU funct = 0x12)
    		mtlo (ALU funct = 0x13)
    		mult (ALU funct = 0x18)
    		multu (ALU funct = 0x19)
    		div (ALU funct = 0x1a)
    		divu (ALU funct = 0x1b)
    		add (ALU funct = 0x20)
    		addu (ALU funct = 0x21)
    		sub (ALU funct = 0x22)
    		subu (ALU funct = 0x23)
    		and (ALU funct = 0x24)
    		move (ALU funct = 0x25)
    		or (ALU funct = 0x25)
    		xor (ALU funct = 0x26)
    		nor (ALU funct = 0x27)
    		slt (ALU funct = 0x2a)
    		sltu (ALU funct = 0x2b)
    		sllv (ALU funct = 0x4)
    		srlv (ALU funct = 0x6)
    		srav (ALU funct = 0x7)
    		jr (ALU funct = 0x8)
    		jalr (ALU funct = 0x9)
    		break (ALU funct = 0xd)

			*/

			// We're always reading/writing, but we can
			// use $0 to make the write inconsequential
			registerRead = 1;
			registerWrite = 1;
			
			if (functIn == ALUFunctCodesPackage::ALU_JALR) begin
				// Write to return address if we're linking
				registerWriteSource = ControlLinePackage::NEXT_PC_ADDRESS;
			end
			else begin
				// Write to our regular destination otherwise
				registerWriteSource = ControlLinePackage::RESULT;
			end
			// Whether or not we're linking, both use RD as the write register.
			//  JALR just has 31 put into the instruction by default by the assembler.
			registerWriteAddressMode = ControlLinePackage::RD;
			

			funct = functIn;
			shamt = shamtIn;

			// Never use immediates for these
			useImmediate = 0;
			signExtend = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			unique case (functIn)
				ALUFunctCodesPackage::ALU_JR,
				ALUFunctCodesPackage::ALU_JALR: begin
					branchMode = BranchModesPackage::JR;
				end
				default: begin
					branchMode = BranchModesPackage::NONE;
				end
			endcase
		// "not_immediate_alu" is a block label and just helps
		//   avoid coding errors plus increases readability.
		end : not_immediate_alu

		ADDI,
		ANDI,
		ORI,
		XORI: begin
			registerRead = 1;
			registerWrite = 1;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::RESULT;

			unique case (opCodeIn)
				ADDI: begin
					funct = ALUFunctCodesPackage::ADD;
					signExtend = 1;
				end
				ANDI: begin
					funct = ALUFunctCodesPackage::AND;
					signExtend = 0;
				end
				ORI: begin
					funct = ALUFunctCodesPackage::OR;
					signExtend = 0;
				end
				XORI: begin
					funct = ALUFunctCodesPackage::XOR;
					signExtend = 0;
				end
				default: begin end
			endcase
			shamt = 5'd0;
			useImmediate = 1;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		ADDIU: begin
			registerRead = 1;
			registerWrite = 1;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::RESULT;

			funct = ALUFunctCodesPackage::ADD;
			shamt = 5'd0;
			useImmediate = 1;
			signExtend = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		LUI: begin
			registerRead = 1;
			registerWrite = 1;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::RESULT;

			// Shift the immediate value 16 left
			funct = ALUFunctCodesPackage::SLL;
			shamt = 5'd16;
			useImmediate = 1;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		SLTI: begin
			registerRead = 1;
			registerWrite = 1;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::RESULT;

			funct = ALUFunctCodesPackage::SLT;
			shamt = 5'd0;
			useImmediate = 1;
			signExtend = 1;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		SLTIU: begin
			registerRead = 1;
			registerWrite = 1;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::RESULT;

			funct = ALUFunctCodesPackage::SLTU;
			shamt = 5'd0;
			useImmediate = 1;
			signExtend = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::NONE;
		end

		BEQ: begin
			registerRead = 1;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::NONE;

			funct = ALUFunctCodesPackage::SUB;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::BEQ;
		end

		BGEZ_BGEZAL_BLTZAL_BLTZ: begin
			registerRead = 1;
			// Only link for BGEZAL and BLTZAL
			if (rtIn == BranchModesPackage::BGEZAL || rtIn == BranchModesPackage::BLTZAL) begin
				registerWrite = 1;
			end
			else begin
				registerWrite = 0;
			end
			// These are totally dependent on the value for registerWrite so
			//  we don't have to put them in the if statement.
			// "ControlLinePackage::RA" is just $ra (register 31.)
			registerWriteAddressMode = ControlLinePackage::RA;
			registerWriteSource = ControlLinePackage::NEXT_PC_ADDRESS;

			funct = ALUFunctCodesPackage::SUB;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			// These instructions use rt to hold the branch mode
			//  and branch module is coded to have the same values that rt could have.
			branchMode = rtIn;
		end

		BGTZ: begin
			registerRead = 1;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::NONE;

			funct = ALUFunctCodesPackage::SUB;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::BGTZ;
		end

		BLEZ: begin
			registerRead = 1;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::NONE;

			funct = ALUFunctCodesPackage::SUB;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::BLEZ;
		end

		BNE: begin
			registerRead = 1;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::NONE;

			funct = ALUFunctCodesPackage::SUB;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::BNE;
		end

		J: begin
			registerRead = 0;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::NONE;

			// The function doesn't matter here since we're not writing anything.
			funct = ALUFunctCodesPackage::ADD;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::J;
		end

		JAL: begin
			registerRead = 0;
			registerWrite = 1;
			// Hardcode $ra for the write register since there's no room
			//  in the instruction to specify the register to write to.
			//  (Some of these instructions default to $ra but can be changed)
			registerWriteAddressMode = ControlLinePackage::RA;
			registerWriteSource = ControlLinePackage::NEXT_PC_ADDRESS;

			funct = ALUFunctCodesPackage::ADD;
			shamt = 5'd0;
			useImmediate = 0;

			readMode = MemoryModesPackage::NONE;
			writeMode = MemoryModesPackage::NONE;
			unsignedLoad = 0;

			branchMode = BranchModesPackage::J;
		end

		LB,
		LBU,
		LH,
		LHU,
		LW,
		LWL,
		LWR: begin
			registerRead = 1;
			registerWrite = 1;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::DATA_OUTPUT;

			funct = ALUFunctCodesPackage::ADD;
			shamt = 5'd0;
			useImmediate = 1;

			// Set our read mode
			unique case (opCodeIn)
				LB,
				LBU: begin
					readMode = MemoryModesPackage::BYTE;
				end
				LH,
				LHU: begin
					readMode = MemoryModesPackage::HALFWORD;
				end
				LW: begin
					readMode = MemoryModesPackage::WORD;
				end
				LWL: begin
					readMode = MemoryModesPackage::WORDLEFT;
				end
				LWR: begin
					readMode = MemoryModesPackage::WORDRIGHT;
				end
				default: begin
					readMode = MemoryModesPackage::NONE;
				end
			endcase
			
			// Not writing
			writeMode = MemoryModesPackage::NONE;

			if (opCodeIn == LBU || opCodeIn == LHU) begin
				unsignedLoad = 1;
			end
			else begin
				unsignedLoad = 0;
			end

			branchMode = BranchModesPackage::NONE;
		end

		SB,
		SH,
		SW,
		SWL,
		SWR: begin
			registerRead = 1;
			registerWrite = 0;
			registerWriteAddressMode = ControlLinePackage::RT;
			registerWriteSource = ControlLinePackage::DATA_OUTPUT;

			funct = ALUFunctCodesPackage::ADD;
			shamt = 5'd0;
			useImmediate = 1;

			// Set our read mode
			unique case (opCodeIn)
				SB: begin
					writeMode = MemoryModesPackage::BYTE;
				end
				SH: begin
					writeMode = MemoryModesPackage::HALFWORD;
				end
				SW: begin
					writeMode = MemoryModesPackage::WORD;
				end
				SWL: begin
					writeMode = MemoryModesPackage::WORDLEFT;
				end
				SWR: begin
					writeMode = MemoryModesPackage::WORDRIGHT;
				end
				default: begin
					writeMode = MemoryModesPackage::NONE;
				end
			endcase
			
			readMode = MemoryModesPackage::NONE;

			if (opCodeIn == LBU || opCodeIn == LHU) begin
				unsignedLoad = 1;
			end
			else begin
				unsignedLoad = 0;
			end

			branchMode = BranchModesPackage::NONE;
		end

	endcase
end


endmodule

