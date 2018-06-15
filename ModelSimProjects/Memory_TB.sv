import MemoryModes::*;

module Memory_TB;

logic clk;
logic rst;

logic [31:0]address;
logic [31:0]data;
logic [2:0]writeMode;
logic [2:0]readMode;

logic unsignedLoad;

logic [31:0]pcAddress;

logic [31:0]dataOutput;
logic [31:0]pcDataOutput;

initial begin
	clk = 0;
	unsignedLoad = 0;
end


Memory m1(.*);

always begin
#5;
clk = 1;
#5;
clk = 0;
end

always begin

// Reading/writing WORD(s)
address = 32'd65532;
data = 32'h22345678;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65528;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65532;
data = 32'h12222;
writeMode = NONE;
readMode = NONE;
unsignedLoad = 0;
#10;


address = 32'd65532;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h22345678) else $error("Reading the previously written value didn't work.");
#9;

address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h0) else $error("Reading the previously written value didn't work.");
#9;

// Reading/writing HALFWORD(s)
//Write all 3's
address = 32'd65528;
data = 32'h33333333;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
//Write F's for lower half
// but exclude the MSB because we want a positive number
address = 32'd65528;
data = 32'h00001FFF;
writeMode = HALFWORD;
readMode = NONE;
unsignedLoad = 0;
#10;

//Read the entire word to make sure it only
// wrote on the lower half of the word.
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h33331FFF) else $error("Reading the previously written value didn't work: %h", dataOutput);
#9;

//Read the halfword (sign extension)
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = HALFWORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h00001FFF) else $error("Reading the previously written value didn't work.");
#9;

//Read the halfword (no sign extension)
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = HALFWORD;
unsignedLoad = 1;
#1;
assert(dataOutput == 32'h00001FFF) else $error("Reading the previously written value didn't work.");
#9;

//Write a negative half word
address = 32'd65528;
data = 32'h0000FFFF;
writeMode = HALFWORD;
readMode = NONE;
unsignedLoad = 0;
#10;

//Read the halfword (no sign extension)
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = HALFWORD;
unsignedLoad = 1;
#1;
assert(dataOutput == 32'h0000FFFF) else $error("Reading the previously written value didn't work.");
#9;

//Read the halfword (sign extension)
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = HALFWORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'hFFFFFFFF) else $error("Reading the previously written value didn't work.");
#9;

//Write a whole word using halfwords
// Clear all around 65528
address = 32'd65532;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65528;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65524;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
//Write the whole word using halfwords
address = 32'd65528;
data = 32'hABCD;
writeMode = HALFWORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65530;
data = 32'h9845;
writeMode = HALFWORD;
readMode = NONE;
unsignedLoad = 0;
#10;
//Read the word back
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h9845ABCD) else $error("Reading the previously written value didn't work.");
#9;
//This one should still be zero though.
address = 32'd65532;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h0) else $error("Reading the previously written value didn't work.");
#9;
//This one should be zero too
address = 32'd65524;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h0) else $error("Reading the previously written value didn't work.");
#9;


//Reading/writing bytes
// Clear all around 65528
address = 32'd65532;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65528;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65524;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;

//Write A1B2C3D4
address = 32'd65530;
data = 32'hB2;
writeMode = BYTE;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65528;
data = 32'hD4;
writeMode = BYTE;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65531;
data = 32'hA1;
writeMode = BYTE;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65529;
data = 32'hC3;
writeMode = BYTE;
readMode = NONE;
unsignedLoad = 0;
#10;
//Read and check word
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'hA1B2C3D4) else $error("Reading the previously written value didn't work.");
#9;
//Read and check each byte
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = BYTE;
unsignedLoad = 1;
#1;
assert(dataOutput == 32'hD4) else $error("Reading the previously written value didn't work.");
#9;
address = 32'd65529;
data = 32'h123;
writeMode = NONE;
readMode = BYTE;
unsignedLoad = 1;
#1;
assert(dataOutput == 32'hC3) else $error("Reading the previously written value didn't work.");
#9;
address = 32'd65530;
data = 32'h0;
writeMode = NONE;
readMode = BYTE;
unsignedLoad = 1;
#1;
assert(dataOutput == 32'hB2) else $error("Reading the previously written value didn't work.");
#9;
address = 32'd65531;
data = 32'h0;
writeMode = NONE;
readMode = BYTE;
unsignedLoad = 1;
#1;
assert(dataOutput == 32'hA1) else $error("Reading the previously written value didn't work.");
#9;
//Try making one a signed load.
address = 32'd65531;
data = 32'h0;
writeMode = NONE;
readMode = BYTE;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'hFFFFFFA1) else $error("Reading the previously written value didn't work.");
#9;
//This one should still be zero though.
address = 32'd65532;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h0) else $error("Reading the previously written value didn't work.");
#9;
//This one should be zero too
address = 32'd65524;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h0) else $error("Reading the previously written value didn't work.");
#9;

//==================
//Test swl, lwl
// Clear all around 65528
address = 32'd65532;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65528;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65524;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;

// Start saving successively to the right
address = 32'd65528;
data = 32'h12345678;
writeMode = WORDLEFT;
readMode = NONE;
unsignedLoad = 0;
#10;
// Reading using lwl and lw
// Write 1 byte
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORDLEFT;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h12000000) else $error("Reading the previously written value didn't work: %h", dataOutput);
#9;
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h12) else $error("Reading the previously written value didn't work: %h", dataOutput);
#9;


// REMOVE THIS
// REMOVE THIS
// REMOVE THIS
//***********
address = 32'd65528;
data = 32'h0;
writeMode = WORD;
readMode = NONE;
unsignedLoad = 0;
#10;
//************
// Write 2 bytes
address = 32'd65529;
data = 32'h12345678;
writeMode = WORDLEFT;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65529;
data = 32'h0;
writeMode = NONE;
readMode = WORDLEFT;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h12340000) else $error("Reading the previously written value didn't work: %h", dataOutput);
#9;
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h1234) else $error("Reading the previously written value didn't work.");
#9;

// Write 3 bytes
address = 32'd65530;
data = 32'h12345678;
writeMode = WORDLEFT;
readMode = NONE;
unsignedLoad = 0;
#10;
address = 32'd65530;
data = 32'h0;
writeMode = NONE;
readMode = WORDLEFT;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h12345600) else $error("Reading the previously written value didn't work: %h", dataOutput);
#9;
address = 32'd65528;
data = 32'h0;
writeMode = NONE;
readMode = WORD;
unsignedLoad = 0;
#1;
assert(dataOutput == 32'h123456) else $error("Reading the previously written value didn't work.");
#9;



#10000;
end


endmodule






