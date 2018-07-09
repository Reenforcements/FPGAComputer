package ProcessorPackage;

endpackage

import ProcessorPackage::*;
import ControlLinePackage::*;
import MemoryModesPackage::ReadWriteModes;
module Processor(
input logic rst,
input logic clk,

// Pauses the processor so we can change data in memory.
input logic pause,

// Allows us to write to the memory from an external source
// such as a ModelSim test or RS232 serial connection.
input logic externalMemoryControl,
input logic [31:0]externalAddress,
input logic [31:0]externalData,
input logic [2:0]externalReadMode,
input logic [2:0]externalWriteMode,
output logic [31:0]externalDataOut
);

// pClk stands for pausable clock.
// We may want to be able to "pause" the processor at times.
logic pClk;
always_ff @ (posedge clk) begin
	if (pause == 1'b1) begin
		// Maintain current clock state
		pClk <= pClk;
	end
	else begin
		// Change with the clock.
		pClk <= clk;
	end
end


// PC
logic [31:0]pc_newPC;
logic pc_shouldUseNewPC;

logic [31:0]pc_pcAddress;
logic [31:0]pc_nextPCAddress;
PC pc(
	.clk(pClk),
	.rst(rst),

	.newPC(pc_newPC),
	.shouldUseNewPC(pc_shouldUseNewPC),

	.pcAddress(pc_pcAddress),
	.nextPCAddress(pc_nextPCAddress)
);


always @ (posedge clk) begin
	if (pause == 1'b0)
		$display("Current PC: %d", pc_pcAddress);
end


// Register File
logic [4:0]registerFile_rsAddress;
logic [4:0]registerFile_rtAddress;
logic [4:0]registerFile_writeAddress;

logic registerFile_registerRead;
logic registerFile_registerWrite;

logic [31:0]registerFile_writeData;
logic [31:0]registerFile_readValue0;
logic [31:0]registerFile_readValue1;

RegisterFile registerFile(
	.clk(pClk),
	.rst(rst),

	.rsAddress(registerFile_rsAddress),
	.rtAddress(registerFile_rtAddress),
	.writeAddress(registerFile_writeAddress),

	.registerRead(registerFile_registerRead),
	.registerWrite(registerFile_registerWrite),
	
	.writeData(registerFile_writeData),
	.readValue0(registerFile_readValue0),
	.readValue1(registerFile_readValue1)
);


logic [31:0]alu_dataIn0;
logic [31:0]alu_dataIn1;

logic [5:0]alu_funct;
logic [4:0]alu_shamt;

logic [31:0]alu_result;
logic alu_outputZero;
logic alu_outputPositive;
logic alu_outputNegative;

// ALU
ALU alu(
	.clk(pClk),
	.rst(rst),

	.dataIn0(alu_dataIn0),
	.dataIn1(alu_dataIn1),
	.shamt(alu_shamt),
	.funct(alu_funct),

	.result(alu_result),
	.outputZero(alu_outputZero),
	.outputNegative(alu_outputNegative),
	.outputPositive(alu_outputPositive)
);

// Branch
logic [3:0]branch_mode;

logic branch_shouldUseNewPC;
logic [31:0]branch_jumpRegisterAddress;
logic [25:0]branch_jumpAddress;

logic branch_resultZero;
logic branch_resultPositive;
logic branch_resultNegative;

logic [31:0]branch_pcAddress;
logic [15:0]branch_branchAddressOffset;
logic [31:0]branch_branchTo;

Branch branch(
	.clk(pClk),
	.rst(rst),
	
	.shouldUseNewPC(branch_shouldUseNewPC),
	.mode(branch_mode),
	.jumpRegisterAddress(branch_jumpRegisterAddress),
	.jumpAddress(branch_jumpAddress),

	.resultZero(branch_resultZero),
	.resultPositive(branch_resultPositive),
	.resultNegative(branch_resultNegative),

	.pcAddress(branch_pcAddress),
	.branchAddressOffset(branch_branchAddressOffset),
	.branchTo(branch_branchTo)
);

// Memory

// The memory has a separate clock because we might want
//  to use the memory externally while the processor is running.
logic memory_clk;

logic [31:0]memory_address;
logic [31:0]memory_dataIn;
logic [2:0]memory_writeMode;
logic [2:0]memory_readMode;
logic [31:0]memory_dataOut;

logic memory_unsignedLoad;

logic [31:0]memory_pcAddress;
logic [31:0]memory_pcData;
Memory mem(
	.clk(memory_clk), 
	.rst(rst),

	.address(memory_address),
	.data(memory_dataIn),
	.writeMode(memory_writeMode),
	.readMode(memory_readMode),
	.dataOutput(memory_dataOut),

	.unsignedLoad(memory_unsignedLoad),

	.pcAddress(memory_pcAddress),
	.pcDataOutput(memory_pcData)
);

// Control
logic [31:0]control_instructionData;
// Register File
logic control_registerRead;
logic control_registerWrite;
logic [1:0]control_registerWriteAddressMode;
logic [1:0]control_registerWriteSource;
// ALU
logic [5:0]control_funct;
logic [4:0]control_shamt;
logic control_useImmediate;
logic control_signExtend;
// Memory
logic [2:0]control_readMode;
logic [2:0]control_writeMode;
logic control_unsignedLoad;
// Branching
logic [3:0]control_branchMode;

Control control(
	.clk(pClk),
	.rst(rst),

	.instructionData(control_instructionData),

	.registerRead(control_registerRead),
	.registerWrite(control_registerWrite),
	.registerWriteAddressMode(control_registerWriteAddressMode),
	.registerWriteSource(control_registerWriteSource),
	
	.funct(control_funct),
	.shamt(control_shamt),
	.useImmediate(control_useImmediate),
	.signExtend(control_signExtend),

	.readMode(control_readMode),
	.writeMode(control_writeMode),
	.unsignedLoad(control_unsignedLoad),

	.branchMode(control_branchMode)
);

// PIPELINE REGISTERS

// Standard connection ordering:
// PC
// Instruction
// Control
// RegisterFile
// ALU
// Branch
// Memory

// dIF (delay_InstructionFetch)
logic [31:0]pc_pcAddress_dIF;
logic [31:0]pc_nextPCAddress_dIF;


// d0
logic [31:0]pc_pcAddress_d0;
logic [31:0]pc_nextPCAddress_d0;

logic [31:0]instructionData_d0;
logic [4:0]instruction_rsIn_d0;
logic [4:0]instruction_rtIn_d0;
logic [31:0]instruction_immediateExtended_d0;
logic [25:0]instruction_jumpAddress_d0;

logic [1:0]control_registerWriteSource_d0;
logic control_registerWrite_d0;
logic [5:0]control_funct_d0;
logic [4:0]control_shamt_d0;
logic control_useImmediate_d0;
logic [2:0]control_readMode_d0;
logic [2:0]control_writeMode_d0;
logic control_unsignedLoad_d0;
logic [3:0]control_branchMode_d0;

logic [31:0]registerFile_readValue0_d0;
logic [31:0]registerFile_readValue1_d0;
logic [4:0]registerFile_writeAddress_d0;

// d1
logic [31:0]pc_nextPCAddress_d1;

	// Need these to check if we can use the ALU result immediately for the next instruction.
logic [4:0]instruction_rsIn_d1;
logic [4:0]instruction_rtIn_d1;

logic [1:0]control_registerWriteAddressMode_d1;
logic control_registerWrite_d1;
logic [2:0]control_readMode_d1;
logic [2:0]control_writeMode_d1;
logic control_unsignedLoad_d1;
logic [1:0]control_registerWriteSource_d1;

logic [4:0]registerFile_writeAddress_d1;

logic [31:0]alu_result_d1;

// The memory data/address has built in input registers.

// d2
logic [31:0]pc_nextPCAddress_d2;

logic [1:0]control_registerWriteSource_d2;
logic control_registerWrite_d2;

logic [4:0]registerFile_writeAddress_d2;

logic [31:0]alu_result_d2;

logic [31:0]memory_dataOut_d2;


// PIPELINE STAGE IF BELOW
// The instruction data is "registered" from the input to the memory module.

// Get the current instruction from memory.
logic [31:0]instructionData;
always_comb begin
	// The RAM inside the Memory module will save
	//  the address on the clock and hold the output after that.
	memory_pcAddress = pc_pcAddress;
 	instructionData = memory_pcData;
end
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		pc_pcAddress_dIF <= 32'd0;
		pc_nextPCAddress_dIF <= 32'd0;
	end
	else begin
		pc_pcAddress_dIF <= pc_pcAddress;
		pc_nextPCAddress_dIF <= pc_nextPCAddress;
	end
end

// Debug
always @ (posedge clk) begin
	if (pause == 1'b0)
		$display("Current instruction: %h", instructionData);
end

// PIPELINE STAGE 0 BELOW (using clocked output from memory)


// Split up the instruction
//logic [5:0]instruction_opCode;
logic [4:0]instruction_rsIn;
logic [4:0]instruction_rtIn;
logic [4:0]instruction_rdIn;
//logic [4:0]instruction_shamtIn;
//logic [5:0]instruction_functIn;
logic [15:0]instruction_immediate;
logic [31:0]instruction_immediateExtended;
//logic [31:0]instruction_zeroExtended;
logic [25:0]instruction_jumpAddress;
always_comb begin
	//instruction_opCode = instructionData[31:26];
	instruction_rsIn = instructionData[25:21];
	instruction_rtIn = instructionData[20:16];
	instruction_rdIn = instructionData[15:11];
	//instruction_shamtIn = instructionData[10:6];
	//instruction_functIn = instructionData[5:0];
	instruction_immediate = instructionData[15:0];
	if (control_signExtend == 1'b1) begin
		// Sign extend the immediate to 32 bits
		if (instructionData[15] == 1'b1) begin
			instruction_immediateExtended = { {16{1'b1}}, instruction_immediate};
		end
		else begin
			instruction_immediateExtended = { {16{1'b0}}, instruction_immediate};
		end
	end
	else begin
		// Zero extend
		instruction_immediateExtended = { {16{1'b0}}, instruction_immediate };
	end
	instruction_jumpAddress = instructionData[25:0];
end

// Assign inputs for this cycle
always_comb begin
	// Assign control input.
	control_instructionData = instructionData;

	// Assign register file read inputs.
	registerFile_registerRead = control_registerRead;
	registerFile_rsAddress = instruction_rsIn;
	registerFile_rtAddress = instruction_rtIn;
	
end

// Save results in registers
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		pc_pcAddress_d0 <= 32'd0;
		pc_nextPCAddress_d0 <= 32'd0;
	
		instructionData_d0 <= 32'd0;
		instruction_rsIn_d0 <= 5'd0;
		instruction_rtIn_d0 <= 5'd0;
		instruction_immediateExtended_d0 <= 32'd0;
		instruction_jumpAddress_d0 <= 26'd0;
		
		control_registerWriteSource_d0 <= ControlLinePackage::NONE;
		control_registerWrite_d0 <= 0;
		control_funct_d0 <= 6'd0;
		control_shamt_d0 <= 5'd0;
		control_useImmediate_d0 <= 0;
		control_readMode_d0 <= ReadWriteMode_NONE;
		control_writeMode_d0 <= ReadWriteMode_NONE;
		control_unsignedLoad_d0 <= 1'b1;
		control_branchMode_d0 <= BranchModesPackage::BranchMode_NONE;
		
		registerFile_readValue0_d0 <= 32'd0;
		registerFile_readValue1_d0 <= 32'd0;
		registerFile_writeAddress_d0 <= 5'd0;
	end
	else begin
		pc_pcAddress_d0 <= pc_pcAddress_dIF;
		pc_nextPCAddress_d0 <= pc_nextPCAddress_dIF;
	
		instructionData_d0 <= instructionData;
		instruction_rsIn_d0 <= instruction_rsIn;
		instruction_rtIn_d0 <= instruction_rtIn;
		instruction_immediateExtended_d0 <= instruction_immediateExtended;
		instruction_jumpAddress_d0 <= instruction_jumpAddress;
		
		control_registerWriteSource_d0 <= control_registerWriteSource;
		control_registerWrite_d0 <= control_registerWrite;
		control_funct_d0 <= control_funct;
		control_shamt_d0 <= control_shamt;
		control_useImmediate_d0 <= control_useImmediate;
		control_readMode_d0 <= control_readMode;
		control_writeMode_d0 <= control_writeMode;
		control_unsignedLoad_d0 <= control_unsignedLoad;
		control_branchMode_d0 <= control_branchMode;
		
		registerFile_readValue0_d0 <= registerFile_readValue0;
		registerFile_readValue1_d0 <= registerFile_readValue1;
		// Choose our register write address based on the address mode.
		unique case (control_registerWriteAddressMode)
			ControlLinePackage::RD: begin
				registerFile_writeAddress_d0 <= instruction_rdIn;
			end
			ControlLinePackage::RT: begin
				registerFile_writeAddress_d0 <= instruction_rtIn;
			end
			ControlLinePackage::RA: begin
				registerFile_writeAddress_d0 <= 5'd31;
			end
			default: begin 
				// Default to zero.
				registerFile_writeAddress_d0 <= 5'd0; 
			end
		endcase
	end
end

// PIPELINE STAGE 1 BELOW

// Assign values passed from last stage
always_comb begin

	// PC
	pc_newPC = branch_branchTo;
	pc_shouldUseNewPC = branch_shouldUseNewPC;

	// ALU
	if(instruction_rsIn_d1 == instruction_rsIn_d0)
		alu_dataIn0 = alu_result_d1;
	else
		alu_dataIn0 = registerFile_readValue0_d0;
	
	if(instruction_rtIn_d1 == instruction_rtIn_d0) begin
		// Use our last ALU result which hasn't been written back to the register file yet.
		alu_dataIn1 = alu_result_d1;
	end
	else begin
		// We're not using data we just calculated.
		if (control_useImmediate_d0 == 1'b1) begin
			alu_dataIn1 = instruction_immediateExtended_d0;
		end 
		else begin
			alu_dataIn1 = registerFile_readValue1_d0;
		end
	end

	alu_funct = control_funct_d0;
	alu_shamt = control_shamt_d0;
	
	// Branch
	branch_mode = control_branchMode_d0;
	
	branch_jumpRegisterAddress = alu_result;
	branch_jumpAddress = instruction_jumpAddress_d0;
	branch_pcAddress = pc_pcAddress_d0;
	branch_branchAddressOffset = instruction_immediateExtended_d0[15:0];
	
	branch_resultZero = alu_outputZero;
	branch_resultPositive = alu_outputPositive;
	branch_resultNegative = alu_outputNegative;
	
	// Memory
	// The memory has its own internal registers for the address/data
	// The memory control lines are stored in other registers and then assigned next clock cycle.
	if (externalMemoryControl == 1'b1) begin
		// Force the memory to be controlled externally.
		// This could be RS232 serial or ModelSim.
		memory_clk = clk;
		memory_address = externalAddress;
		memory_dataIn = externalData;
	end
	else begin	
		memory_clk = pClk;
		memory_address = alu_result;
		memory_dataIn = registerFile_readValue1_d0;
	end
end


always_ff begin
	if (rst == 1'b0) begin
		pc_nextPCAddress_d1 <= 32'd0;
	
		instruction_rsIn_d1 <= R0;
		instruction_rtIn_d1 <= R0;
		
		control_registerWriteSource_d1 <= ControlLinePackage::NONE;
		control_registerWrite_d1 <= 1'b0;
		control_readMode_d1 <= ReadWriteMode_NONE;
		control_writeMode_d1 <= ReadWriteMode_NONE;
		control_unsignedLoad_d1 <= 1'b1;
	
		alu_result_d1 <= 32'd0;
		
		registerFile_writeAddress_d1 <= 5'd0;
	end
	else begin
		pc_nextPCAddress_d1 <= pc_nextPCAddress_d0;
	
		instruction_rsIn_d1 <= instruction_rsIn_d0;
		instruction_rtIn_d1 <= instruction_rtIn_d0;
		
		control_registerWriteSource_d1 <= control_registerWriteSource_d0;
		control_registerWrite_d1 <= control_registerWrite_d0;
		control_readMode_d1 <= control_readMode_d0;
		control_writeMode_d1 <= control_writeMode_d0;
		control_unsignedLoad_d1 <= control_unsignedLoad_d0;
	
		alu_result_d1 <= alu_result;
		
		registerFile_writeAddress_d1 <= registerFile_writeAddress_d0;
	end
end


// PIPELINE STAGE 2 BELOW

// Assign inputs from previous registers
always_comb begin

	if (externalMemoryControl == 1'b1) begin
		memory_readMode = externalReadMode;
		memory_writeMode = externalWriteMode;
		memory_unsignedLoad = 1'b1;
		externalDataOut = memory_dataOut;
	end
	else begin	
		memory_readMode = control_readMode_d1;
		memory_writeMode = control_writeMode_d1;
		memory_unsignedLoad = control_unsignedLoad_d1;
		externalDataOut = 32'd0;
	end
end

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		pc_nextPCAddress_d2 <= 32'd0;
		
		control_registerWriteSource_d2 <= ControlLinePackage::NONE;
		control_registerWrite_d2 <= 1'b0;
		
		registerFile_writeAddress_d2 <= 5'd0;
		
		alu_result_d2 <= 32'd0;
		
		memory_dataOut_d2 <= 32'd0;
	end
	else begin
		pc_nextPCAddress_d2 <= pc_nextPCAddress_d1;
		
		control_registerWriteSource_d2 <= control_registerWriteSource_d1;
		control_registerWrite_d2 <= control_registerWrite_d1;
		
		registerFile_writeAddress_d2 <= registerFile_writeAddress_d1;
		
		alu_result_d2 <= alu_result_d1;
		
		memory_dataOut_d2 <= memory_dataOut;
	end
end

// d3 

always_comb begin
	

	registerFile_writeAddress = registerFile_writeAddress_d2;
	registerFile_registerWrite= control_registerWrite_d2;
	
	unique case (control_registerWriteSource_d2)
		ControlLinePackage::NONE: begin
			registerFile_writeData = 32'd0;
		end
		ControlLinePackage::NEXT_PC_ADDRESS: begin
			registerFile_writeData = pc_nextPCAddress_d2 + 32'd4;
		end
		ControlLinePackage::DATA_OUTPUT: begin
			registerFile_writeData = memory_dataOut_d2;
		end

		ControlLinePackage::RESULT: begin
			registerFile_writeData = alu_result_d2;
		end
		default: begin
			registerFile_writeData = 32'd0;
		end
	endcase
end


// NEW CODE ABOVE HERE.
// (ORIGINAL IMPLEMENTATION BELOW)

/*
always_comb begin

	// Assign control input.
	control_instructionData = instructionData;

	// Assign register file inputs.
	registerFile_registerRead = control_registerRead;
	registerFile_registerWrite = control_registerWrite;

	registerFile_rsAddress = instruction_rsIn;
	registerFile_rtAddress = instruction_rtIn;

	// Choose our register write address based on the address mode.
	unique case (control_registerWriteAddressMode)
		ControlLinePackage::RD: begin
			registerFile_writeAddress = instruction_rdIn;
		end
		ControlLinePackage::RT: begin
			registerFile_writeAddress = instruction_rtIn;
		end
		ControlLinePackage::RA: begin
			registerFile_writeAddress = 5'd31;
		end
		default: begin 
			// Default to zero.
			registerFile_writeAddress = 5'd0; 
		end
	endcase
end

// Choose our register write data based on registerWriteSource
always_comb begin
	unique case (control_registerWriteSource)
		ControlLinePackage::NONE: begin
			registerFile_writeData = 32'd0;
		end
		ControlLinePackage::NEXT_PC_ADDRESS: begin
			registerFile_writeData = pc_nextPCAddress + 32'd4;
		end
		ControlLinePackage::DATA_OUTPUT: begin
			registerFile_writeData = memory_dataOut;
		end

		ControlLinePackage::RESULT: begin
			registerFile_writeData = alu_result;
		end
		default: begin
			registerFile_writeData = 32'd0;
		end
	endcase
end

// Assign ALU inputs
always_comb begin
	alu_funct = control_funct;
	alu_shamt = control_shamt;
end

always_comb begin
//	alu_dataIn0 = registerFile_readValue0;
//
//	if (control_useImmediate == 1'b1) begin
//		alu_dataIn1 = instruction_immediateExtended;
//	end 
//	else begin
//		alu_dataIn1 = registerFile_readValue1;
//	end
end

// Assign memory inputs

// External memory reading/writing
always_comb begin
	if (externalMemoryControl == 1'b1) begin
		// Force the memory to be controlled externally.
		// This could be RS232 serial or ModelSim.
		memory_clk = clk;
		memory_address = externalAddress;
		memory_dataIn = externalData;
		memory_readMode = externalReadMode;
		memory_writeMode = externalWriteMode;
		memory_unsignedLoad = 1'b1;
		externalDataOut = memory_dataOut;
	end
	else begin	
		memory_clk = pClk;
		memory_address = alu_result;
		memory_dataIn = registerFile_readValue1;
		memory_readMode = control_readMode;
		memory_writeMode = control_writeMode;
		memory_unsignedLoad = control_unsignedLoad;
		externalDataOut = 32'd0;
	end
end


logic [25:0]branch_jumpAddress_d0;
logic [31:0]branch_jumpRegisterAddress_d0;

logic [31:0]branch_pcAddress_d0;
logic [15:0]branch_branchAddressOffset_d0;

logic branch_resultZero_d0;
logic branch_resultNegative_d0;
logic branch_resultPositive_d0;

logic [3:0]branch_mode_d0;

// Assign branch inputs
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		branch_jumpAddress_d0 <= 26'd0;
		branch_jumpRegisterAddress_d0 <= 32'd0;
		
		branch_pcAddress_d0 <= 32'd0;
		branch_branchAddressOffset_d0 <= 16'd0;
	
		branch_resultZero_d0 <= 1'd0;
		branch_resultNegative_d0 <= 1'd0;
		branch_resultPositive_d0 <= 1'd0;
		
		branch_mode_d0 <= BranchModesPackage::NONE;
	end
	else begin
		// Assign inputs to delay flip-flops on the clock.
		branch_jumpAddress_d0 <= instruction_jumpAddress;
		branch_jumpRegisterAddress_d0 <= alu_result;

		branch_pcAddress_d0 <= pc_pcAddress;
		branch_branchAddressOffset_d0 <= instruction_immediate;

		branch_resultZero_d0 <= alu_outputZero;
		branch_resultNegative_d0 <= alu_outputNegative;
		branch_resultPositive_d0 <= alu_outputPositive;

		branch_mode_d0 <= control_branchMode;
	end
end
always_comb begin
	branch_jumpAddress = branch_jumpAddress_d0;
	branch_jumpRegisterAddress = branch_jumpRegisterAddress_d0;

	branch_pcAddress = branch_pcAddress_d0;
	branch_branchAddressOffset = branch_branchAddressOffset_d0;

	branch_resultZero = branch_resultZero_d0;
	branch_resultNegative = branch_resultNegative_d0;
	branch_resultPositive = branch_resultPositive_d0;

	branch_mode = branch_mode_d0;

	// These are just outputs from Branch so they'll
	//  follow the delayed inputs to Branch.
	pc_newPC = branch_branchTo;
	pc_shouldUseNewPC = branch_shouldUseNewPC;
end


logic [31:0]g;
Register 
#(.SIZE(32)) 
r(
.clk(clk), 
.rst(rst), 
.in(32'd0), 
.out(g));*/

endmodule
