package ProcessorPackage;


endpackage

import ProcessorPackage::*;
import ControlLinePackage::*;
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
input logic [2:0]externalWriteMode
);

// pClk stands for pausable clock.
// We may want to be able to "pause" the processor at times.
logic pClk;
always_ff @ (posedge clk or negedge clk) begin
	if (pause == 1'b0) begin
		// Maintain current clock state
		pClk <= pClk;
	end
	else begin
		// Change with the clock.
		pClk <= clk;
	end
end


// PC
logic [31:0]newPC;
logic pc_shouldUseNewPC;

logic [31:0]pc_pcAddress;
logic [31:0]nextPCAddress;
PC pc(
	.clk(pClk),
	.rst(rst),

	.newPC(newPC),
	.shouldUseNewPC(pc_shouldUseNewPC),

	.pcAddress(pc_pcAddress),
	.nextPCAddress(nextPCAddress)
);

// Register File
logic [4:0]rsAddress;
logic [4:0]rtAddress;
logic [4:0]registerFile_writeAddress;

logic registerRead;
logic registerWrite;

logic [31:0]registerFile_writeData;
logic [31:0]registerFile_readValue0;
logic [31:0]registerFile_readValue1;

RegisterFile registerFile(
	.clk(pClk),
	.rst(rst),

	.rsAddress(rsAddress),
	.rtAddress(rtAddress),

	.registerRead(registerRead),
	.registerWrite(registerWrite),
	
	.writeData(registerFile_writeData),
	.readValue0(registerFile_readValue0),
	.readValue1(registerFile_readValue1)
);


logic [31:0]alu_dataIn0;
logic [31:0]alu_dataIn1;

logic [5:0]funct;
logic [4:0]shamt;

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
	.funct(funct),
	.shamt(shamt),

	.result(alu_result),
	.outputZero(alu_outputZero),
	.outputPositive(alu_outputPositive),
	.outputNegative(alu_outputNegative)
);

// Branch
logic [3:0]branch_mode;

logic branch_shouldUseNewPC;
logic [31:0]jumpRegisterAddress;
logic [25:0]jumpAddress;

logic branch_outputZero;
logic branch_outputPositive;
logic branch_outputNegative;

logic [31:0]branch_pcAddress;
logic [15:0]branchAddressOffset;
logic [31:0]branchTo;

Branch branch(
	.clk(pClk),
	.rst(rst),
	
	.shouldUSeNewPC(branch_shouldUseNewPC),
	.mode(branch_mode),
	.jumpRegisterAddress(jumpRegisterAddress),
	.jumpAddress(jumpAddress),
	.outputZero(branch_outputZero),
	.outputPositive(branch_outputPositive),
	.outputNegative(branch_outputNegative),
	.pcAddress(branch_pcAddress),
	.branchAddressOffset(branchAddressOffset),
	.branchTo(branchTo)
);

// Memory
logic [31:0]memory_address;
logic [31:0]memory_dataIn;
logic [2:0]memory_writeMode;
logic [2:0]memory_readMode;
logic [31:0]memory_dataOut;

logic memory_unsignedLoad;

logic [31:0]memory_pcAddress;
logic [31:0]memory_pcData;
Memory mem(
	.clk(pClk), 
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

	.readMode(control_readMode),
	.writeMode(control_writeMode),
	.unsignedLoad(control_unsignedLoad),

	.branchMode(control_branchMode)
);



// Get the current instruction from memory.
assign memory_pcAddress = pc_pcAddress;
logic [31:0]instructionData;
assign instructionData = memory_pcData;
// Split up the instruction
logic [5:0]instruction_opCode;
logic [4:0]instruction_rsIn;
logic [4:0]instruction_rtIn;
logic [4:0]instruction_rdIn;
logic [4:0]instruction_shamtIn;
logic [5:0]instruction_functIn;
logic [15:0]instruction_immediate;
logic [31:0]instruction_immediateSignExtended;
logic [25:0]instruction_jumpAddress;
always_comb begin
	instruction_opCode = instructionData[31:26];
	instruction_rsIn = instructionData[25:21];
	instruction_rtIn = instructionData[20:16];
	instruction_rdIn = instructionData[15:11];
	instruction_shamtIn = instructionData[10:6];
	instruction_functIn = instructionData[5:0];
	instruction_immediate = instructionData[15:0];
	// Sign extend the immediate to 32 bits
	if (instructionData[15] == 1'b1) begin
		instruction_immediateSignExtended = { {16{1'b1}}, instructionData[15:0]};
	end
	else begin
		instruction_immediateSignExtended = { {16{1'b0}}, instructionData[15:0]};
	end
	instruction_jumpAddress = instructionData[25:0];
end



// Assign control input.
assign control_instructionData = instructionData;



// Assign register file inputs.
assign registerRead = control_registerRead;
assign registerWrite = control_registerWrite;

assign registerFile_rsAddress = instruction_rsIn;
assign registerFile_rtAddress = instruction_rtIn;

// Choose our register write address based on the address mode.
always_comb begin
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
			registerFile_writeData = nextPCAddress;
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
assign funct = control_funct;
assign shamt = control_shamt;

assign alu_dataIn0 = registerFile_readValue0;
always_comb begin
	if (control_useImmediate == 1'b1) begin
		alu_dataIn1 = instruction_immediateSignExtended;
	end 
	else begin
		alu_dataIn1 = registerFile_readValue1;
	end
end

// Assign memory inputs

// External memory reading/writing
always begin
	if (externalMemoryControl == 1'b1) begin
		// Force the memory to be controlled externally.
		// This could be RS232 serial or ModelSim.
		memory_address = externalAddress;
		memory_dataIn = externalData;
		memory_readMode = externalReadMode;
		memory_writeMode = externalWriteMode;
		memory_unsignedLoad = 1'b1;
	end
	else begin	
		memory_address = alu_result;
		memory_dataIn = registerFile_readValue1;
		memory_readMode = control_readMode;
		memory_writeMode = control_writeMode;
		memory_unsignedLoad = control_unsignedLoad;
	end
end
assign externalDataOutput = memory_dataOut;

// Assign branch inputs
assign branch_jumpAddress = instruction_jumpAddress;
assign branch_jumpRegisterAddress = alu_result;

assign branch_pcAddress = pc_pcAddress;
assign branchAddressOffset = instruction_immediate;

assign branch_outputZero = alu_outputZero;
assign branch_outputNegative = alu_outputNegative;
assign branch_outputPositive = alu_outputPositive;

assign branch_mode = control_branchMode;



/*
logic [31:0]g;
Register 
#(.SIZE(32)) 
r(
.clk(clk), 
.rst(rst), 
.in(32'd0), 
.out(g));*/


endmodule
