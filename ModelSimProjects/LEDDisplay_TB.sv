`timescale 1 ps / 1 ps
module LEDDisplay_TB;

logic clk;
logic rst;
	
logic [10:0]pixelAddress0;
logic [7:0]pixel0;
	
logic [10:0]pixelAddress1;
logic [7:0]pixel1;
	
logic [4:0]rowDecoder;

logic pixelClk;
logic [2:0]columnPixels0;
logic [2:0]columnPixels1;
logic columnLatch;
logic blank;

logic done;

LEDDisplay ld(.*);

initial begin
rst = 0;
clk = 0;
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



$display("Done.");
#200000000;
end

always begin
	pixel0 = pixelAddress0[7:0];
	pixel1 = pixelAddress1[7:0];
	#10;
end


endmodule