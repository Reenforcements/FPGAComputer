`timescale 1 ps / 1 ps

import MIPSInstructionPackage::*;
import MemoryModesPackage::*;
module Processor_TB;

logic rst;
logic clk;

logic memory_clk;
logic memory_rst;

// Pauses the processor so we can change data in memory.
logic pause;

// Allows us to write to the memory from an external source
// such as a ModelSim test or RS232 serial connection.
logic externalMemoryControl;
logic [31:0]externalAddress;
logic [31:0]externalData;
logic [2:0]externalReadMode;
logic [2:0]externalWriteMode;
logic [31:0]externalDataOut;

// Load the program from disk into here.
logic [31:0]tempWords[16384:0];
logic [31:0]results[2000:0];

initial begin
rst = 0;
clk = 0;
memory_clk = 0;
memory_rst = 0;
pause = 1;
externalMemoryControl = 1;

// Remember that it will be loaded into tempMemory at 0 instead of 1024
// so compensate when loading into actual memory.
$readmemh("../ModelSimTestData/processorTest1Hex.txt", tempWords);
$readmemh("../ModelSimTestData/processorTest1Results.txt", results);
end

Processor p(.*);

always @ (*) begin
rst = ~pause;
end

logic [31:0]n;
logic [31:0]curWord;
always begin

#10;
memory_rst = 1;

// Load the memory.
// Make sure to take the offset into account.
// Should take ~164000 * 3 = 500000
$display("Starting memory load...");
pause = 1;
externalReadMode = ReadWriteMode_NONE;
externalWriteMode = WORD;
externalMemoryControl = 1;
curWord = 0;
for (n = 0; n < 32'hFFFF; n = n + 4) begin
	externalAddress = n + 32'd1024;
	externalData = tempWords[curWord];
	curWord = curWord + 1;
	//$display("(%h) Loading %h", externalAddress, externalData);
	#10;
end
$display("Done loading memory.");


$display("Running code...");
pause = 0;
externalMemoryControl = 0;
#3500;
$display("Done.");

$display("Comparing/Printing memory...");
pause = 1;
externalReadMode = WORD;
externalWriteMode = ReadWriteMode_NONE;
externalMemoryControl = 1;
curWord = 0;
#3500;
for (n = 32'd20000; n < 32'd20256; n = n + 4) begin
	externalAddress = n;
	#6;
	assert(externalDataOut == results[curWord])
		$display("Pass (%d): %h", externalAddress, externalDataOut);
	else 
		$error("Results at word %d are not equal: %h != %h", curWord, externalDataOut, results[curWord]);
	#4;
	curWord = curWord + 1;
end
$display("Done.");

#1000000000;

end

always begin
clk = 0;
memory_clk = 0;
#5;
clk = 1;
memory_clk = 1;
#5;
end


endmodule