import MIPSInstructionPackage::*;
import MemoryModesPackage::*;
module Processor_TB;

logic rst;
logic clk;

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
pause = 1;
externalMemoryControl = 1;

// Remember that it will be loaded into tempMemory at 0 instead of 1024
// so compensate when loading into actual memory.
$readmemh("../ModelSimTestData/processorTest1Hex.txt", tempWords);
$readmemh("../ModelSimTestData/processorTest1Results.txt", results);
end

Processor p(.*);


logic [31:0]n;
logic [31:0]curWord;
always begin

#10;
rst = 1;

// Load the memory.
// Make sure to take the offset into account.
// Should take ~164000 * 3 = 500000
$display("Starting memory load...");
pause = 1;
externalReadMode = NONE;
externalWriteMode = WORD;
externalMemoryControl = 1;
curWord = 0;
for (n = 0; n < 32'hFFFF; n = n + 4) begin
	externalAddress = n + 32'd1024;
	externalData = tempWords[curWord];
	curWord = curWord + 1;
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
externalWriteMode = NONE;
externalMemoryControl = 1;
curWord = 0;
#10;
for (n = 32'd20000; n < 32'd20300; n = n + 4) begin
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

// Original, small test
/*
always begin

#10;
rst = 1;

// Load instructions into memory.
pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd1024;
// Branch to 65520
externalData = {J, 26'd16379};
externalReadMode = NONE;
externalWriteMode = WORD;
#10;
// Read back the branch just to be safe.
pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd1024;
// Branch to 65520
externalData = {J, 26'd16379};
externalReadMode = WORD;
externalWriteMode = NONE;
#9;
assert(externalDataOut == externalData) $display("branch successfully wrote: %b", externalDataOut); else $error("Branch didn't read back correctly: %h", externalDataOut);
#1;


pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd65520;
// NOP
externalData = 32'd0;
externalReadMode = NONE;
externalWriteMode = WORD;
#10;
pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd65524;
// ADDI $0, $t0, 128
externalData = {ADDI, 5'd0, 5'd8, 16'd123};
externalReadMode = NONE;
externalWriteMode = WORD;
#10;
pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd65528;
// SW $0, $t0, 128
externalData = {SW, 5'd0, 5'd8, 16'd65532};
externalReadMode = NONE;
externalWriteMode = WORD;
#10;
pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd65532;
// NOP
externalData = 32'd0;
externalReadMode = NONE;
externalWriteMode = WORD;
#10;

// Let instructions run
pause = 0;
externalMemoryControl = 0;
#40;

// Read back the result.
pause = 1;
externalMemoryControl = 1;
externalAddress = 32'd65532;
externalData = 32'd0;
externalReadMode = WORD;
externalWriteMode = NONE;
#9;
assert(externalDataOut == 32'd123) $display(">>>Correct result: %d", externalDataOut); else $error("Result should be 32, was %d", externalDataOut);
#1;


#100000;
end
*/

always begin
clk = 0;
#5;
clk = 1;
#5;
end


endmodule