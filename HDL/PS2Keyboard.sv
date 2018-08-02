module PS2Keyboard(
input logic clk,
input logic rst,

input logic PS2_CLK,
input logic PS2_DAT,

output logic [7:0]scanCode,
output logic scanCodeReady
);

parameter CLOCK_SPEED = 8333333;

// Calculated PS2 clock speed is 13,796.909
// How many of our cycles must pass before it's been a full low of the PS2 clock.
parameter COUNT_DURATION_LOW = ((CLOCK_SPEED / 13508) / 2) / 2;
// How many cycles must pass before we know we're just in an idle state.
parameter COUNT_DURATION_IDLE = (CLOCK_SPEED / 13508) * 3 / 2;//((CLOCK_SPEED / (13508/2)) * 5) / 4;

// Metastability prevention
logic PS2_CLK_d0;
logic PS2_CLK_d1;
logic PS2_DAT_d0;
logic PS2_DAT_d1;
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		PS2_CLK_d0 <= 1'b1;
		PS2_CLK_d1 <= 1'b1;
		PS2_DAT_d0 <= 1'b0;
		PS2_DAT_d1 <= 1'b0;
	end
	else begin
		PS2_CLK_d0 <= PS2_CLK;
		PS2_CLK_d1 <= PS2_CLK_d0;
		PS2_DAT_d0 <= PS2_DAT;
		PS2_DAT_d1 <= PS2_DAT_d0;
	end
end

typedef enum logic [4:0] {
START = 5'h1,
BITS = 5'h2,
PARITY = 5'h3,
STOP = 5'h4,
BAD = 5'h8
} PS2KeyboardState;

PS2KeyboardState state;
PS2KeyboardState nextState;

logic saveBit;

logic [7:0]currentBit;
logic [7:0]currentBit_next;

logic PS2_CLK_LAST;
logic [31:0]PS2_CLK_HIGH_COUNT;
logic [31:0]PS2_CLK_LOW_COUNT;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		scanCode <= 8'd0;

		state <= START;

		currentBit <= 8'd0;
		PS2_CLK_LAST <= 1'b1;
		PS2_CLK_HIGH_COUNT <= 32'd1;
		PS2_CLK_LOW_COUNT <= 32'd1;
	end
	else begin
		
		if (PS2_CLK_LAST != PS2_CLK_d1) begin
			// Clock changed. Reset values.
			PS2_CLK_LAST <= PS2_CLK_d1;
			PS2_CLK_HIGH_COUNT <= 32'd0;
			PS2_CLK_LOW_COUNT <= 32'd0;
		end
		else begin
			// Clock stayed the same.
			if (PS2_CLK_LAST == 1'b1) begin
				if (PS2_CLK_HIGH_COUNT < COUNT_DURATION_IDLE) begin
					PS2_CLK_HIGH_COUNT <= PS2_CLK_HIGH_COUNT + 32'd1;
				end
				else if (PS2_CLK_HIGH_COUNT == COUNT_DURATION_IDLE) begin
					PS2_CLK_HIGH_COUNT <= PS2_CLK_HIGH_COUNT + 32'd1;
					// Reset the state machine
					state <= START;
				end
				else begin
					// Do nothing and wait
				end
			end
			else begin
								
				if (PS2_CLK_LOW_COUNT < COUNT_DURATION_LOW) begin
					PS2_CLK_LOW_COUNT <= PS2_CLK_LOW_COUNT + 32'd1;
				end
				else if (PS2_CLK_LOW_COUNT == COUNT_DURATION_LOW) begin
					// We've been in the LOW state of the PS2_CLK for the specified duration.
					state <= nextState;

					scanCode <= scanCode;
		
					if (saveBit == 1'b1) begin
						scanCode[currentBit] <= PS2_DAT_d1;
					end
		
					currentBit <= currentBit_next;

					PS2_CLK_LOW_COUNT <= PS2_CLK_LOW_COUNT + 32'd1;
				end
				else begin
					// Do nothing and wait
				end
			end
		end
	end
end

always_comb begin
currentBit_next = currentBit;
saveBit = 1'b0;

	unique case (state)
		START: begin
			nextState = START;
			if (PS2_DAT_d1 == 1'b0) begin
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








