module ALU_TB;

logic clk;
logic rst;

logic [31:0]dataIn0;
logic [31:0]dataIn1;
logic [4:0]shamt;
logic [5:0]funct;

logic [31:0]result;
logic outputZero;
logic outputNegative;
logic outputPositive;

logic [31:0]testResult_result;
logic testResult_outputZero;
logic testResult_outputNegative;
logic testResult_outputPositive;

logic [109:0]memOut[300];
logic [31:0]currentTest;

initial begin
clk = 0;
rst = 0;
currentTest = 0;
$readmemb("../ModelSimTestData/ALU.txt", memOut);
end

// Gotta love that shorthand wiring notation
ALU alu(.*);

// Testing
always @ (negedge clk) begin
// Read the ALU.txt test data file
//  one line at a time.

{
dataIn0, 
dataIn1, 
shamt, 
funct,
testResult_result,
testResult_outputZero,
testResult_outputNegative,
testResult_outputPositive
} <= memOut[currentTest];

#1;

if (memOut[currentTest] != 110'b0) begin
	// Don't wait on the result here because it doesn't always change.
	assert(signed'(result) == signed'(testResult_result)) else $error("Didn't match result: (%h vs %h) at index: %d", 
								signed'(result), signed'(testResult_result), currentTest);
	assert(testResult_outputZero == outputZero) else $error("Didn't match output zero");
	assert(testResult_outputNegative == outputNegative) else $error("Didn't match output negative");
	assert(testResult_outputPositive == outputPositive) else $error("Didn't match output positive");

	currentTest <= currentTest + 1;
end

end

// Clock
always begin
clk <= 0;
#5;
clk <=1;
#5;
end

// Reset
always begin
#8;
rst <= 1;
#100000;
end

endmodule