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

initial begin
clk = 0;
rst = 0;
end

Branch b(.*);

always begin
#5;
clk = 1'b1;
#5;
clk = 1'b0;
end

always begin

resultZero = 0;
resultNegative = 0;
resultPositive = 0;
branchAddressOffset = 16'hFFFF;
jumpAddress = 26'hAABBCC;
jumpRegisterAddress = 32'hAABBCCDD;
mode = NONE;
#9;
assert(shouldUseNewPC == 1'b0) else $error("Trying to branch when it shouldn't.");
assert(branchTo == 32'bx) else $error("Branch address isn't x when it should be.");
#1;

end


endmodule





