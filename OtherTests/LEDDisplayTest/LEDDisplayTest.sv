module LEDDisplayTest(
	input logic clkIn,
	input logic rst,
	
	output logic [4:0]rowDecoder,
	output logic pixelClk,
	output logic [2:0]columnPixels0,
	output logic [2:0]columnPixels1,
	output logic columnLatch,
	output logic blank,
	
	input logic [5:0]colorInputs
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

logic [7:0]pixelColor0;
logic [7:0]pixelColor1;
logic [31:0]changeCounter;
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		pixelColor0 <= 8'b00100000;
		pixelColor1 <= 8'd0;
		changeCounter <= 32'd0;
	end
	else begin
		changeCounter <= changeCounter + 32'd1;
		if (changeCounter == 32'd8333333) begin
			changeCounter <= 32'd0;
			pixelColor0 <= pixelColor0 >> 8'd1;
			if (pixelColor0 == 8'd0) begin
				pixelColor0 <= 8'b00100000;
			end
			
			pixelColor1 <= pixelColor0;
		end
	end
end

always_comb begin
	// Easiest test data on Earth.
	//pixel0 = pixelColor0;//pixelAddress0[7:0];
	//pixel1 = pixelColor1;//pixelAddress1[7:0];

	pixel0 = {2'b0, colorInputs};
	pixel1 = {2'b0, colorInputs};

end

endmodule