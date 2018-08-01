`timescale 1 ps / 1 ps

import PS2KeyboardMemoryCodes::*;
module PS2KeyboardMemory_TB;


logic clk;
logic rst;

logic [7:0]scanCode;
logic scanCodeReady;

logic [8:0]asciiKeyAddress;
logic [31:0]keyValue;

PS2KeyboardMemory sp2kbm(
.*
);

initial begin
rst = 0;
scanCodeReady = 0;
end

always begin
#20;
rst = 1;
#20000000;
end

always begin
clk = 0;
#5;
clk = 1;
#5;
end

always begin

#40;

// lowercase a down
scanCodeReady = 1;
scanCode = sc_a_A;
#10;
scanCodeReady = 0;

#10;

asciiKeyAddress = ascii_a;
#10;
assert(keyValue == 8'd1) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);

// lowercase a up
scanCodeReady = 1;
scanCode = 8'hF0;
#10;
scanCodeReady = 1;
scanCode = sc_a_A;
#10;
scanCodeReady = 0;

asciiKeyAddress = ascii_a;
#10;
assert(keyValue == 8'd0) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);



// left shift down
scanCodeReady = 1;
scanCode = sc_leftshift;
#10;
scanCodeReady = 0;
// right shift down
scanCodeReady = 1;
scanCode = sc_rightshift;
#10;
scanCodeReady = 0;
// left shift up
scanCodeReady = 1;
scanCode = 8'hF0;
#10;
scanCodeReady = 1;
scanCode = sc_leftshift;
#10;
scanCodeReady = 0;

// a key down (should make a capital A because one shift is held.)
scanCodeReady = 1;
scanCode = sc_a_A;
#10;
scanCodeReady = 0;
// check we have capital A
asciiKeyAddress = ascii_A;
#10;
assert(keyValue == 8'd1) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);

asciiKeyAddress = ascii_shift;
#10;
assert(keyValue == 8'd1) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);

// right shift up
scanCodeReady = 1;
scanCode = 8'hF0;
#10;
scanCodeReady = 1;
scanCode = sc_rightshift;
#10;
scanCodeReady = 0;

asciiKeyAddress = ascii_shift;
#10;
assert(keyValue == 8'd0) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);




// up arrow down
scanCodeReady = 1;
scanCode = 8'hE0;
#10;
scanCodeReady = 1;
scanCode = sce_up;
#10;
scanCodeReady = 0;


asciiKeyAddress = ascii_up;
#10;
assert(keyValue == 8'd1) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);

// up arrow up
scanCodeReady = 1;
scanCode = 8'hF0;
#10;
scanCodeReady = 1;
scanCode = 8'hE0;
#10;
scanCodeReady = 1;
scanCode = sce_up;
#10;
scanCodeReady = 0;

asciiKeyAddress = ascii_up;
#10;
assert(keyValue == 8'd0) 
	$display("Successful key value for %h", asciiKeyAddress);
else 
	$error("Key value for %h incorrect: %d", asciiKeyAddress, keyValue);


#20000000;
end


endmodule






