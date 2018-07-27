`timescale 1 ps / 1 ps

module SerialCommandProcessor_TB;


logic clk;
logic rst;

// RS232
logic [7:0]RX;
logic RX_ready;

logic [7:0]TX;
logic start_TX;
logic TX_ready;

// Memory control
logic writeToMemory;
logic readFromMemory;
logic [31:0]memoryAddress;
logic [31:0]memoryWordOut;
logic [31:0]memoryWordIn;

SerialCommandProcessor scp(.*);

logic [7:0]n;

initial begin
	rst = 0;
	TX_ready = 1;
	n = 8'd0;
end

always begin
	#200;

	// Test info command
	/*
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	

	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h01;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	#200000;
	*/

	// Test upload command
	// length
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	// command
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h02;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	// start address
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h04;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	// end address
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h04;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h20;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	
	// Eight words
	for (n = 0; n < 7; n = n + 1) begin
		// end address
		RX <= 8'h00;
		RX_ready <= 1; #10; RX_ready <= 0;
		#2000;
		RX <= 8'h00;
		RX_ready <= 1; #10; RX_ready <= 0;
		#2000;
		RX <= 8'h00;
		RX_ready <= 1; #10; RX_ready <= 0;
		#2000;
		RX <= n;
		RX_ready <= 1; #10; RX_ready <= 0;
		#2000;
	end
	// Done uploading

	// download command
	// length
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	// command
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h02;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	// start address
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h04;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	// end address
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h00;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h04;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;
	RX <= 8'h20;
	RX_ready <= 1; #10; RX_ready <= 0;
	#2000;

	#(2000 * 9); 
	

	#200000000;
end

always begin
	#20;
	rst = 1;
	#200000000;
end
always begin
	clk = 0;
	#5;
	clk = 1;
	#5;
end
always begin
	if (start_TX) begin
		$display("TX: %c", TX);
		TX_ready = 0;
		#50;
		TX_ready = 1;
		
	end
	#10;
end

endmodule