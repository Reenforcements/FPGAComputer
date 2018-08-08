module LEDDisplay(
	input logic clk,
	input logic rst,
	
	output logic [10:0]pixelAddress0,
	input logic [7:0]pixel0,
	
	output logic [10:0]pixelAddress1,
	input logic [7:0]pixel1,
	
	// This line is used to select what row of the matrix is enabled.
	// It controls a 5 to 32 decoder.
	//   and selects from rows 0-31 but also rows 32-63
	output logic [4:0]rowDecoder,
	// Shift out pixel data on these lines using clk.
	output logic pixelClk,
	output logic [2:0]columnPixels0,
	output logic [2:0]columnPixels1,

	output logic columnLatch,
	// This line will blank the entire display
	output logic blank,
	
	// This will be used to swap buffers outside of this module.
	output logic done
);

parameter RED = 2;
parameter GREEN = 1;
parameter BLUE = 0;

typedef enum logic [7:0] {
	START,

	// Wait the needed time for our previous display cycle.
	// This is because different digits in the pixel have different
	//   values, so we need to wait longer for some versus others. 
	// We choose to wait here because we did a bunch of state machine
	//  steps up until this point so the wait time is more predictable
	//  and efficient.
	RESET_COLUMN,
	GET_PIXEL_0,
	// Set the columnPixel lines
	GET_PIXEL_1,
	// Set the pixel clock high
	// If this wasn't the 32 column, go back to SET_COLUMN_LINES
	CLOCK_COLUMN,
	// Set the pixel clock low
	// Set the output enable low
	// Set the latch high
	// Go back to RETREIVE_COLUMN and increment column if we're not done
	// If we did 32 columns, go on to switch the row.
	CHECK_COLUMN_DONE,
	SHOW_COLUMN,
	WAIT_FOR_COLUMN,
	// Set the output enable high
	// Increment our current row and go back to RETREIVE_COLUMN
	// If we did all the rows (16), change our binary digit
	NEXT_ROW,
	// Change from 2^0 to 2^1 (or back to 2^0 if we already did 2^1)
	NEXT_BINARY_DIGIT,
	
	// :(
	BAD
} DisplayState;

DisplayState state;
DisplayState nextState;

logic [4:0]row;
logic [4:0]row_next;
// The actual column we're operating on comes 2 cycles later because
//  of how the RAM works.
logic [5:0]column;
logic [5:0]column_next;

// Are we using 2^0 or 2^1?
// (There would be more if we had more than two bits per color.)
logic binaryDigit;
logic binaryDigit_next;
// How long as the current row been displayed?
logic [15:0]rowTimeCount;
logic [15:0]rowTimeCount_next;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		state <= START;
		row <= 5'd0;
		column <= 6'd0;
		rowTimeCount <= 15'd0;
		binaryDigit <= 1'b0;
	end
	else begin
		state <= nextState;
		row <= row_next;
		column <= column_next;
		rowTimeCount <= rowTimeCount_next;
		binaryDigit <= binaryDigit_next;
		
	end
end

logic [10:0]pixelAddress_next;

// The buffers invert our outputs, so we need to account for
//  this by inverting all our outputs too.
//  Use the same output names but prefix the non inverted signals
//  with n_
logic [4:0]n_rowDecoder;
logic n_pixelClk;
logic [2:0]n_columnPixels0;
logic [2:0]n_columnPixels1;
logic n_columnLatch;
logic n_blank;

always_comb begin
	nextState = state;
	row_next = row;
	column_next = column;
	rowTimeCount_next = rowTimeCount + 16'd1;
	binaryDigit_next = binaryDigit;
	
	// Always set these lines.
	// Whether or not anything actually happens is controlled by the clock.
	pixelAddress0 = (11'(row) * 11'd64) + 11'(column);
	pixelAddress1 = (11'(row) * 11'd64) + 11'(column);
	
	// Each color has two bits
	// Its not a lot, but it will still give us a whole 64 different colors.
	// That's plenty!
	// {X,X, R,R, G,G, B,B} = 8 bits
	n_columnPixels0[RED] = (pixel0 & (8'b00010000 << binaryDigit)) > 0;
	n_columnPixels0[GREEN] = (pixel0 & (8'b00000100 << binaryDigit)) > 0;
	n_columnPixels0[BLUE] = (pixel0 & (8'b00000001 << binaryDigit)) > 0;

	n_columnPixels1[RED] = (pixel1 & (8'b00010000 << binaryDigit)) > 0;
	n_columnPixels1[GREEN] = (pixel1 & (8'b00000100 << binaryDigit)) > 0;
	n_columnPixels1[BLUE] = (pixel1 & (8'b00000001 << binaryDigit)) > 0;
	
	n_pixelClk = 1'd0;
	n_columnLatch = 1'b0;
	n_blank = 1'b0;
	n_rowDecoder = row;
	
	done = 1'b0;
	
	unique case (state)
		START: begin
			nextState = RESET_COLUMN;
			
		end
		RESET_COLUMN: begin
			// This should already be zero from the last cycle.
			column_next = 5'd0;
			nextState = GET_PIXEL_0;
		end
		GET_PIXEL_0: begin
			// Clock the address into RAM.
			nextState = GET_PIXEL_1;
		end
		GET_PIXEL_1: begin
			// Clock the data out of RAM.
			nextState = CLOCK_COLUMN;
		end
		CLOCK_COLUMN: begin
			// Set the clock high
			// The values for the column shift register lines are set
			//  higher up outside the case statement.
			n_pixelClk = 1'd1;
			// Assign the different lines.
			nextState = CHECK_COLUMN_DONE;
		end
		CHECK_COLUMN_DONE: begin
		
			// Put the clock back to zero.
			n_pixelClk = 1'd0;
			
			// Increment the column
			column_next = column + 6'd1;
			// If we just did the 63rd column, then column_next will be
			//   zero and we're done shifting in this column
			if (column_next == 6'd0) begin
				// Done shifting in this column
				nextState = SHOW_COLUMN;
			end
			else begin
				// Do the next column pixel.
				nextState = GET_PIXEL_0;
			end
		end
		SHOW_COLUMN: begin
			// Reset the row time counter.
			rowTimeCount_next = 16'd0;
			// Latch the new data in.
			n_columnLatch = 1'b1;
			// n_blank the display while latching.
			n_blank = 1'b1;
			// Wait for the column to display long enough.
			nextState = WAIT_FOR_COLUMN;
			// Increment our row
			row_next = row + 5'd1;
		end
		WAIT_FOR_COLUMN: begin
			
			n_blank = (binaryDigit == 1'b0) ? (rowTimeCount >= 16'd1) : (rowTimeCount >= 16'd300);
			if (binaryDigit == 1'b0) begin
				if (rowTimeCount >= 16'd300) begin
					rowTimeCount_next = 16'd0;
					nextState = NEXT_ROW;
				end
			end
			else begin
				if (rowTimeCount >= 16'd300) begin
					rowTimeCount_next = 16'd0;
					nextState = NEXT_ROW;
				end
			end
		end
		NEXT_ROW: begin
			
			// If row_next is zero, it means we did all 16 rows
			//  and the row variable overflowed. Change our binary digit.
			if (row_next == 5'd0) begin
				nextState = NEXT_BINARY_DIGIT;
			end
			else begin
				nextState = RESET_COLUMN;
			end
		end
		NEXT_BINARY_DIGIT: begin
			// Switch which binary digit we're lookin at.
			// The 2^1 digit should run twice as long as 2^0
			binaryDigit_next = ~binaryDigit;
			
			if (binaryDigit == 1'b1) begin
				// We rendered the entire buffer
				done = 1'b1;
			end
			nextState = RESET_COLUMN;
		end
		default: begin
			nextState = BAD;
		end
	endcase
	
	rowDecoder = ~(n_rowDecoder - 5'd1);
   pixelClk = ~n_pixelClk;
	columnPixels0 = ~n_columnPixels0;
	columnPixels1 = ~n_columnPixels1;
	columnLatch = ~n_columnLatch;
	blank = ~n_blank;
end

endmodule








