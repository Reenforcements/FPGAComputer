module PS2Keyboard(
input logic clk,
input logic rst,

input logic PS2_CLK,
input logic PS2_DAT,

output logic [7:0]scanCode,
output logic scanCodeReady
);

typedef enum logic [4:0] {
START,
BITS,
PARITY,
STOP,
BAD

} PS2KeyboardState;

// Debounce
logic [9:0]debounceCounter;
logic lastPS2_CLK;
logic DEBOUNCED_PS2_CLK;
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		lastPS2_CLK <= PS2_CLK;
		debounceCounter <= 10'd0;
		DEBOUNCED_PS2_CLK <= 1'b1;
	end
	else begin
		if (lastPS2_CLK != PS2_CLK) begin
			debounceCounter <= 10'd0;
			lastPS2_CLK <= PS2_CLK;
		end
		else begin
			debounceCounter <= debounceCounter + 10'd1;
		end
		
		if (debounceCounter == 10'd800) begin
			DEBOUNCED_PS2_CLK <= lastPS2_CLK;
		end
	end
end

PS2KeyboardState state;
PS2KeyboardState nextState;

logic saveBit;

logic [7:0]currentBit;
logic [7:0]currentBit_next;

always_ff @ (negedge DEBOUNCED_PS2_CLK or negedge rst) begin
	if (rst == 1'b0) begin
		scanCode <= 8'd0;

		state <= START;

		currentBit <= 8'd0;
	end
	else begin
		state <= nextState;
		scanCode <= scanCode;
		
		if (saveBit == 1'b1) begin
			scanCode[currentBit] <= PS2_DAT;
		end
		
		currentBit <= currentBit_next;
	end
end

always_comb begin
currentBit_next = currentBit;
saveBit = 1'b0;

	unique case (state)
		START: begin
			nextState = START;
			if (PS2_DAT == 1'b0) begin
				nextState = BITS;
				currentBit_next = 8'd0;
			end
		end
		BITS: begin
			nextState = BITS;
			saveBit = 1'b1;
			
			currentBit_next = currentBit + 8'd1;
			if (currentBit == 8'd7) begin
				nextState = PARITY;
			end
		end
		PARITY: begin
			// Ignore
			nextState = STOP;
		end
		STOP: begin
			nextState = START;
		end
		default: begin 
			nextState = BAD;
		end
	endcase
end

logic didSetScanCodeReady;
always @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		didSetScanCodeReady <= 1'b0;
	end
	else begin
		scanCodeReady <= 1'b0;
		
		if (state == STOP) begin
			if (didSetScanCodeReady == 1'b0) begin
				didSetScanCodeReady <= 1'b1;
				scanCodeReady <= 1'b1;
			end
		end
		else begin
			didSetScanCodeReady <= 1'b0;
		end
	end
end

endmodule








