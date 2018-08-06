module PS2KeyboardTest(
input logic clk,
input logic rst,

input logic PS2_CLK,
input logic PS2_DAT,

input logic PS2_CLK2,
input logic PS2_DAT2,

output logic led1,
output logic led2,

output logic [6:0]segMSB,
output logic [6:0]segLSB
);

logic clk2;

logic [7:0]clkCounter;
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		clk2 <= 1'b1;
		clkCounter <= 8'd1;
	end
	else begin
		if (clkCounter == 8'd3) begin
			clk2 <= ~clk2;
			clkCounter <= 8'd1;
		end
		else begin
			clkCounter <= clkCounter + 8'd1;
		end
	end
end
/*
always_comb begin
	clk2 = clk;
end
*/


logic [7:0]scanCode;
logic scanCodeReady;

PS2Keyboard ps2kb(
	.clk(clk2),
	.rst(rst),
	
	.PS2_CLK(PS2_CLK),
	.PS2_DAT(PS2_DAT),
	
	.scanCode(scanCode),
	.scanCodeReady(scanCodeReady)
);

logic [7:0]currentScanCode;
always_ff @ (posedge clk2 or negedge rst) begin
	if (rst == 1'b0) begin
		currentScanCode <= 8'd0;
	end
	else begin
		currentScanCode <= currentScanCode;
		if (scanCodeReady == 1'b1) begin
			currentScanCode <= scanCode;
		end
	end
end

Output7Seg seg0(
	.inp(currentScanCode[7:4]),
	.display(segMSB)
);
Output7Seg seg1(
	.inp(currentScanCode[3:0]),
	.display(segLSB)
);

always_comb begin
	led1 = PS2_CLK2;
	led2 = PS2_DAT2;
end


endmodule