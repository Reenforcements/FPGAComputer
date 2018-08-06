module LEDDisplayTest(
	input logic clkIn,
	input logic rst,
	
	output logic [4:0]rowDecoder,
	output logic pixelClk,
	output logic [2:0]columnPixels0,
	output logic [2:0]columnPixels1,
	output logic columnLatch,
	output logic blank
);

logic clk;
logic [7:0]clkCounter;
always_ff @ (posedge clkIn or negedge rst) begin
	if (rst == 1'b0) begin
		clk <= 1'b1;
		clkCounter <= 8'd1;
	end
	else begin
		if (clkCounter == 8'd3) begin
			clk <= ~clk;
			clkCounter <= 8'd1;
		end
		else begin
			clkCounter <= clkCounter + 8'd1;
		end
	end
end


	
logic [10:0]pixelAddress0;
logic [7:0]pixel0;
	
logic [10:0]pixelAddress1;
logic [7:0]pixel1;
	
// This will be used to swap buffers outside of this module.
logic done;
	

LEDDisplay ld(
	.*
);

always_comb begin
	// Easiest test data on Earth.
	pixel0 = 8'b00110000;//pixelAddress0[7:0];
	pixel1 = 8'b00110000;//pixelAddress1[7:0];
end

endmodule