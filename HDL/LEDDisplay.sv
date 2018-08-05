module LEDDisplay(
	input logic clk,
	input logic rst,
	
	// Set to 1 to use the secondary buffer.
	// This will be set up in the processor with a register so you can
	//   "swap" buffers in your programs to avoid tearing in rendering.
	input logic useSecondaryBuffer,
	
	// This line is used to select what row of the matrix is enabled.
	// It controls a 4 to 16 decoder.
	//   and selects from rows 0-15 but also rows 16-31
	output logic [3:0]matrix_rowDecoder,
	// Shift out pixel data on these lines using matrix_clk.
	output logic matrix_pixelClk,
	output logic [2:0]matrix_columnPixelsUpper,
	output logic [2:0]matrix_columnPixelsLower,
	// This line controls when the new data that was shifted in goes into effect.
	output logic matrix_columnLatch,
	// This line will blank the entire display
	output logic matrix_blank
);

typedef enum logic [7:0] {
	START,

	RETREIVE_COLUMN,
	// Wait the needed time for our previous display cycle.
	// This is because different digits in the pixel have different
	//   values, so we need to wait longer for some versus others. 
	// We choose to wait here because we did a bunch of state machine
	//  steps up until this point so the wait time is more predictable
	//  and efficient.
	// We're also going to be in this step at minimum one cycle
	//   so take this opportunity to read from VRAM.
	WAIT_COLUMN,
	// Set the columnPixel lines
	SET_COLUMN,
	// Set the pixel clock high
	CLOCK_COLUMN,
	// Set the pixel clock low
	// Set the output enable low
	// Set the latch high
	// Go back to RETREIVE_COLUMN and increment column if we're not done
	// If we did 32 columns, go on to switch the row.
	CHECK_COLUMN_DONE,
	// Set the output enable high
	// Increment our current row and go back to RETREIVE_COLUMN
	// If we did all the rows (16), change our binary digit
	NEXT_ROW,
	// Change from 2^0 to 2^1 (or back to 2^0 if we already did 2^1)
	NEXT_BINARY_DIGIT,
	
	// :(
	BAD
} DisplayState;

logic	[31:0]  vram_inputData;
logic	[10:0]  vram_readAddress;
logic	[10:0]  wraddress;
input	  wren;
logic	[31:0]  q;

VRAM vram1(
	.aclr(rst),
	.clock(clk),
	.data(vram_inputData),
	.rdaddress(vram_readAddress),
	.wraddress,
	.wren,
	.q(q)
);

DisplayState state;
DisplayState nextState;

logic [3:0]row;
logic [3:0]row_next;
logic [4:0]column;
logic [4:0]column_next;
// Are we using 2^0 or 2^1?
// (There would be more if we had more than two bits per color.)
logic binaryDigit;
// How long as the current row been displayed?
logic [31:0]rowTimeCount;
logic [31:0]rowTimeCount_next;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		state <= START;
		row <= 4'd0;
		column <= 5'd0;
	end
	else begin
		state <= nextState;
	end
end

always_comb begin
	nextState = state;
	row = row_next;
	column = column_next;
	
	unique case (state)
		
		default: begin
		
		end
	endcase
end

endmodule








