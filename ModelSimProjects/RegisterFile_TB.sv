module RegisterFile_TB;

logic clk;
logic rst;
logic [4:0]rsAddress;
logic [4:0]rtAddress;
logic [4:0]writeAddress;

logic registerRead;
logic registerWrite;

logic signed [31:0]writeData;

logic [31:0]readValue0;
logic [31:0]readValue1;


initial begin
	registerWrite = 0;
	registerRead = 0;
	rst = 1;
end

RegisterFile rf(.*);

always begin
	#2;

	// Write 1234 to 12
	registerWrite <= 1;
	writeAddress <= 5'd12;
	writeData <= (32'd1234);
	#10;

	// Write 1234 to 0
	registerWrite <= 1;
	writeAddress <= 5'd0;
	writeData <= 32'd1234;
	#10;

	// Read 12 and 0, should be 1234 and 0
	registerWrite <= 0;
	registerRead <= 1;
	rsAddress <= 5'd12;
	rtAddress <= 5'd0;
	#1
	assert(readValue0 == ((32'd1234)) ) else $error("Reg 12 should be 1234");
	assert(readValue1 == 0) else $error("Reg 0 should ALWAYS be 0.");
	#9;

	// Write -555555 to 5
	registerWrite <= 1;
	registerRead <= 0;
	writeAddress <= 5'd5;
	writeData <= -(32'd555555);
	#10;

	// Read from 5 and 12, should be -555555 and 1234
	registerWrite <= 0;
	registerRead <= 1;
	rsAddress <= 5'd5;
	rtAddress <= 5'd12;
	//#1
	wait (readValue0);
	wait (readValue1);
	assert(readValue0 == (-(32'd555555)) ) else $error("Reg 5 should be -555555");
	assert(readValue1 == 32'd1234) else $error("Reg 12 should be 1234.");
	#10;

	// readValue0/readValue1 should be 0 if readEnabled = 0
	registerWrite <= 0;
	registerRead <= 0;
	rsAddress <= 5'd5;
	rtAddress <= 5'd4;
	#1
	assert(readValue0 == 32'd0) else $error("Reg 5 should be 0 when readEnabled=0");
	assert(readValue1 == 32'd0) else $error("Reg 4 should be 0 when readEnabled=0");
	#9;

	$error("DONE!");

	#1000;
end

// Clock period of 10
always begin
	clk <= 1;
	#5;
	clk <= 0;
	#5;
end

always begin
// Enable after 10
#10;
rst = 0;
end

endmodule
