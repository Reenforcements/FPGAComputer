module PS2Keyboard_TB;

 logic clk;
 logic rst;

 logic PS2_CLK;
 logic PS2_DAT;

 logic [7:0]scanCode;
 logic scanCodeReady;

PS2Keyboard #(.COUNT_DURATION_LOW(7), .COUNT_DURATION_IDLE(12)) ps2kb(.*);

initial begin
	clk = 0;
	rst = 0;
	PS2_CLK = 1;
	PS2_DAT = 1;
end
always begin
	#20;
	rst = 1;
end
always begin
	clk = 0;
	#5;
	clk = 1;
	#5;
end

always begin
	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 0;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 0;
	#100;

	// 0-3
	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;

	// 4-7
	PS2_CLK = 1;
	PS2_DAT = 0;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 0;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 0;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 0;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;

	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;

	// parity/stop
	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 1;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 0;
	PS2_DAT = 1;
	#100;
	PS2_CLK = 1;
	$display("Done");
	#2000000;
end

always begin
	
	if (scanCodeReady) begin
		$display("Scan code ready: %h", scanCode);
	end
	#10;
end

endmodule