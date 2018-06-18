module PC_TB;

logic clk;
logic rst;

logic count;
logic shouldUseNewPC;
logic [31:0]newPC;

logic [31:0]pcAddress;
logic [31:0]nextPCAddress;

PC pc(.*);

initial begin
	clk = 0;
	rst = 0;
end

// Reset
always begin
#6;
rst = 1;
#100000;
end

// Clock
always begin
#5;
clk = 1;
#5;
clk = 0;
end

// Test logic
always begin
#3;
count = 1;
shouldUseNewPC = 0;
newPC = {32{1'bx}};
#3;
assert(pcAddress == 32'h00400000) else $error("PC is incorrect: %h", pcAddress);
assert((nextPCAddress) == (pcAddress + 32'd4)) else $error("PC is incorrect: %h", nextPCAddress);
#4;

#3;
count = 1;
shouldUseNewPC = 0;
newPC = {32{1'bx}};
#3;
assert(pcAddress == 32'h00400004) else $error("PC is incorrect: %h", pcAddress);
assert((nextPCAddress) == (pcAddress + 32'd4)) else $error("PC is incorrect: %h", nextPCAddress);
#4;


#3;
count = 1;
shouldUseNewPC = 0;
newPC = {32{1'bx}};
#3;
assert(pcAddress == 32'h00400008) else $error("PC is incorrect: %h", pcAddress);
assert((nextPCAddress) == (pcAddress + 32'd4)) else $error("PC is incorrect: %h", nextPCAddress);
#4;


#3;
count = 0;
shouldUseNewPC = 0;
newPC = {32{1'bx}};
#3;
assert(pcAddress == 32'h00400008) else $error("PC is incorrect: %h", pcAddress);
assert((nextPCAddress) == (pcAddress + 32'd4)) else $error("PC is incorrect: %h", nextPCAddress);
#4;

#3;
count = 1;
shouldUseNewPC = 0;
newPC = {32{1'bx}};
#3;
assert(pcAddress == 32'h0040000C) else $error("PC is incorrect: %h", pcAddress);
assert((nextPCAddress) == (pcAddress + 32'd4)) else $error("PC is incorrect: %h", nextPCAddress);
#4;


#10000;
end

endmodule
