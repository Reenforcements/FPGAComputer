import BranchModesPackage::*;

module Branch_TB;

logic clk;
logic rst;
logic [3:0]mode;

logic [31:0]pcAddress;
logic [15:0]branchAddressOffset;
logic [25:0]jumpAddress;
logic [31:0]jumpRegisterAddress;

logic resultZero;
logic resultNegative;
logic resultPositive;

logic shouldUseNewPC;
logic [31:0]branchTo;

Branch b(.*);

initial begin
clk = 0;
rst = 0;
end

always begin
#5;
clk = 1'b1;
#5;
clk = 1'b0;
end

logic [5:0]n;

always begin
// Test NONE
for (n = 0; n < 16; n = n + 1) begin
	resultZero = n[0];
	resultNegative = n[1];
	resultPositive = n[2];
	branchAddressOffset = 16'hFFFF;
	pcAddress = 32'hAABBCCDD;
	jumpAddress = 26'hAABBCC;
	jumpRegisterAddress = 32'hAABBCCDD;
	mode = NONE;
	#9;
	assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
	// The "===" allows x's to be compared
	assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
	#1;
end
//#160;

// Test BEQ
resultZero = 1;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BEQ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 0;
resultNegative = 0;
resultPositive = 1;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BEQ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

// Test BGEZ
resultZero = 1;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BGEZ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't correct.");
#1;

resultZero = 0;
resultNegative = 0;
resultPositive = 1;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BGEZ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be: %h", branchTo);
#1;

resultZero = 0;
resultNegative = 1;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BGEZ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

// Test BGTZ
resultZero = 0;
resultNegative = 0;
resultPositive = 1;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BGTZ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 1;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BGTZ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 0;
resultNegative = 1;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BGTZ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

// Test BLEZ
resultZero = 1;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BLEZ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 0;
resultNegative = 1;
resultPositive = 0;
branchAddressOffset = 16'h0FFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BLEZ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABC0CD9)) else $error("Branch address isn't correct: %h", branchTo);
#1;

resultZero = 0;
resultNegative = 0;
resultPositive = 1;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BLEZ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

// Test BLTZ
resultZero = 0;
resultNegative = 1;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BLTZ;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 1;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BLTZ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 0;
resultNegative = 0;
resultPositive = 1;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BLTZ;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

// Test BNE
resultZero = 0;
resultNegative = 0;
resultPositive = 1;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BNE;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 0;
resultNegative = 1;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BNE;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == (32'hAABBCCD9)) else $error("Branch address isn't x when it should be.");
#1;

resultZero = 1;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = BNE;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo === {8{4'hx}}) else $error("Branch address isn't x when it should be.");
#1;

// BC1T and BC1F not implemented

// Jump (J)
resultZero = 0;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'hAABBCCDD;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = J;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == 32'hA2AAEF30) else $error("Branch address isn't x when it should be.");
#1;

// Jump Register (JR)
resultZero = 0;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
pcAddress = 32'h11223344;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hABCDABCD;
mode = JR;
#9;
assert(shouldUseNewPC == 1'b1) else $error("Trying to branch when it shouldn't.");
assert(branchTo == 32'hABCDABCD) else $error("Branch address is incorrect.");
#1;

$display("Done.");
#20000;
end


endmodule





