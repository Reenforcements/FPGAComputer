module LEDDisplayTest(
	input logic clk,
	input logic rst,
	
	output logic [3:0]rowDecoder,
	output logic pixelClk,
	output logic [2:0]columnPixelsUpper,
	output logic [2:0]columnPixelsLower,
	output logic columnLatch,
	output logic blank
);

logic [10:0]pixelAddress;
logic [7:0]pixel;
	

LEDDisplay ld(
	.*
);


endmodule