
// Assume 50,000,000 Hz clock
// Baud rate is bits/second

module RS232 (
input logic clk,
input logic rst,

input logic UART_RXD,
// CTS is pulled low when the computer is ready to RX_RECEIVE data.
input logic UART_CTS,

output logic UART_RTS,
output logic UART_TXD,

input logic [7:0]TX,
input logic start_TX,
output logic TX_ready,

output logic [7:0]RX,
output logic hasRX,

output logic txError,
output logic rxError
);

// Buffer the inputs
logic UART_RXD_d0;
logic UART_RXD_d1;
always @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		UART_RXD_d0 <= 1'b1;
		UART_RXD_d1 <= 1'b1;
	end
	else begin
		UART_RXD_d0 <= UART_RXD;
		UART_RXD_d1 <= UART_RXD_d0;
	end
end



// The baud rate can be changed when instantiating the module.
parameter BAUD_RATE = 9600;
parameter logic [31:0]TIME_ONE_BIT = 32'd50000000 / BAUD_RATE;
typedef enum logic [3:0] {
	RX_WAITING,
	RX_POSSIBLE_START_BIT,
	RX_RECEIVE,
	RX_POSSIBLE_STOP_BIT,
	RX_BAD
} RS232RX_state;

// Receiving
logic [31:0]RX_counter;
logic [15:0]RX_countOnes;
logic [15:0]RX_countZeroes;
logic [3:0]RX_currentBit;
RS232RX_state RX_state;
RS232RX_state RX_nextState;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		RX <= 8'd0;
		hasRX <= 1'b0;
		RX_counter <= 32'd0;
		RX_countOnes <= 16'd0;
		RX_countZeroes <= 16'd0;
		RX_currentBit <= 4'd0;
		RX_state <= RX_WAITING;
		// Keep zero so we can keep receiving data.
		UART_RTS <= 1'b0;
		rxError <= 1'b0;
	end
	else begin
		UART_RTS <= 1'b0;
		rxError <= 1'b0;
	
		// Clear hasRX by default. It will be set to 1 further down if we have data.
		hasRX <= 1'b0;
	
		RX_state <= RX_nextState;
		RX_counter <= RX_counter + 32'd1; 
		RX_countOnes <= (UART_RXD_d1 == 1'b1) ? RX_countOnes + 16'd1 : RX_countOnes;
		RX_countZeroes <= (UART_RXD_d1 == 1'b0) ? RX_countZeroes + 16'd1 : RX_countZeroes;

		if (RX_state != RX_nextState) begin
			RX_currentBit <= 4'd0;
			RX_counter <= 32'd0;
			RX_countOnes <= 16'd0;
			RX_countZeroes <= 16'd0;
		end
		
		// Have we finished receiving one bit?
		if (RX_counter == TIME_ONE_BIT) begin
			if (RX_state == RX_RECEIVE) begin
				// Save the bit
				$display("Save bit: %d vs %d to last RX: %b", RX_countOnes, RX_countZeroes, RX);
				RX <= (RX >> 8'd1) | ((RX_countOnes > RX_countZeroes) ? 8'b10000000 : 8'b0);

				// Increment the current bit.
				RX_currentBit <= RX_currentBit + 1'b1;
				// Reset the RX_counters
				RX_counter <= 32'd0;
				RX_countOnes <= 16'd0;
				RX_countZeroes <= 16'd0;
			end
		end
		
		if (RX_state == RX_POSSIBLE_STOP_BIT) begin
			if (RX_nextState == RX_POSSIBLE_START_BIT || RX_nextState == RX_WAITING) begin
				// Successful stop condition
				hasRX <= 1'b1;
				$display("Successful stop");
			end
		end
	end
end

always_comb begin
	unique case (RX_state)
		RX_WAITING: begin
			if (UART_RXD_d1 == 1'b1)
				RX_nextState = RX_WAITING;
			else
				RX_nextState = RX_POSSIBLE_START_BIT;
		end
		RX_POSSIBLE_START_BIT: begin
			if (RX_counter == TIME_ONE_BIT) begin
				if (RX_countZeroes > RX_countOnes) begin
					RX_nextState = RX_RECEIVE;
				end
				else begin
					RX_nextState = RX_WAITING;
				end
			end
			else begin
				RX_nextState = RX_POSSIBLE_START_BIT;
			end
		end
		RX_RECEIVE: begin
			// Have we received all 8 bits
			RX_nextState = RX_RECEIVE;
			
			if (RX_counter == TIME_ONE_BIT) begin
				if (RX_currentBit == 4'd7) begin
					RX_nextState = RX_POSSIBLE_STOP_BIT;
				end
			end
	
		end
		RX_POSSIBLE_STOP_BIT: begin
		
			if (RX_counter == TIME_ONE_BIT)
				RX_nextState = RX_WAITING;
			else
				RX_nextState = RX_POSSIBLE_STOP_BIT;
				
			if (UART_RXD_d1 == 1'b0) begin
				RX_nextState = RX_POSSIBLE_START_BIT;
			end
		end
		default: begin
			RX_nextState = RX_BAD;
		end
	endcase
end

// Transmitting
logic [7:0]currentTX;
logic [7:0]TX_currentBit;
logic [31:0]TX_counter;
typedef enum logic [3:0] {
	TX_IDLE,
	TX_START_BIT,
	TX_TRANSMIT,
	TX_STOP_BIT,
	TX_BAD
} RS232TX_state;

RS232TX_state TX_state;
RS232TX_state TX_nextState;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		currentTX <= 8'd0;
		TX_currentBit <= 8'd0;
		TX_counter <= 32'd0;
		TX_state <= TX_IDLE;
		TX_ready <= 1'b1;
	end
	else begin
		TX_state <= TX_nextState;
		TX_counter <= TX_counter + 32'd1;
		
		if (TX_ready == 1'b1 && start_TX == 1'b1) begin
			// Copy current TX and reset things.
			currentTX <= TX;
			TX_ready <= 1'b0;
			TX_currentBit <= 8'd0;
			TX_counter <= 32'd0;
		end

		if (TX_state != TX_nextState) begin
			TX_counter <= 32'd0; 
		end

		if (TX_counter == TIME_ONE_BIT) begin
			if (TX_state == TX_TRANSMIT) begin
				TX_currentBit <= TX_currentBit + 8'd1;
				TX_counter <= 32'd0; 
			end
		end

		if (TX_counter == TIME_ONE_BIT) begin
			if (TX_state == TX_STOP_BIT) begin
				TX_ready <= 1'b1;
			end
		end

	end	
end

always_comb begin
	txError = TX_counter > 32'd300000000; //6 seconds
	unique case (TX_state)
		TX_IDLE: begin
			if (start_TX == 1'b0) begin
				TX_nextState = TX_IDLE;
			end
			else begin
				TX_nextState = TX_START_BIT;
			end
			UART_TXD = 1'b1;
		end
		TX_START_BIT: begin
			TX_nextState = TX_START_BIT;
			UART_TXD = 1'b0;
			if(TX_counter == TIME_ONE_BIT) begin
				TX_nextState = TX_TRANSMIT;
			end
		end
		TX_TRANSMIT: begin
			TX_nextState = TX_TRANSMIT;
			UART_TXD = ( (currentTX & (8'd1 << TX_currentBit)) > 8'd0 ) ;
			if((TX_counter == TIME_ONE_BIT) && (TX_currentBit == 8'd7)) begin
				TX_nextState = TX_STOP_BIT;
			end
		end
		TX_STOP_BIT: begin
			UART_TXD = 1'b1;
			TX_nextState = TX_STOP_BIT;
			if(TX_counter == TIME_ONE_BIT) begin
				TX_nextState = TX_IDLE;
			end
		end
		default: begin
			TX_nextState = TX_BAD;
			UART_TXD = 1'b1;
		end
	endcase
end

endmodule
