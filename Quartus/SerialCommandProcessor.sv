module SerialCommandProcessor(
input logic clk,
input logic rst,

// RS232
input logic [7:0]RX,
input logic RX_ready,

output logic [7:0]TX,
output logic start_TX,
input logic TX_ready,

// Memory control
output logic writeToMemory,
output logic readFromMemory,
output logic [31:0]memoryAddress,
output logic [31:0]memoryWordOut,
input logic [31:0]memoryWordIn

);

// This is the string sent to the computer with the INFO command.
logic [31:0]INFO_STRING[0:27] = '{
32'h0a5a4950, 32'h53202d20, 32'h41204d49, 32'h50532049, 
32'h20636f6d, 32'h70757465, 32'h72200a56, 32'h65727369, 
32'h6f6e2031, 32'h2e300a41, 32'h75737479, 32'h6e204c61, 
32'h726b696e, 32'h0a466f72, 32'h20556e69, 32'h74656420, 
32'h53756d6d, 32'h65722053, 32'h63686f6c, 32'h61727320, 
32'h70726f67, 32'h72616d20, 32'h6174204d, 32'h69616d69, 
32'h20556e69, 32'h76657273, 32'h6974792e, 32'h00000000
};


// This is a little utility to send 32 bit words through 8 bit serial.
logic [31:0]RX_word;
logic RX_word_ready;
logic [1:0]RX_current_byte;

logic [31:0]TX_word;
logic start_TX_word;
logic TX_word_ready;
logic [1:0]TX_current_byte;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		RX_word <= 32'd0;
		RX_current_byte <= 2'd0;
		RX_word_ready <= 1'b0;
		
		TX_word <= 32'd0;
		start_TX_word <= 1'b0;
		TX_current_byte <= 2'd0;
		TX_word_ready <= 1'b1;
	end
	else begin
		RX_word <= RX_word;
		RX_current_byte <= RX_current_byte;
		RX_word_ready <= RX_word_ready;
		
		TX_word <= TX_word;
	
		RX_current_byte <= RX_current_byte;
		if (RX_ready == 1'b1) begin
			RX_word[ (5'(2'd3 - RX_current_byte) * 5'd8)+:8] <= RX;
			RX_current_byte <= 1'd1;
		end
		if (RX_current_byte == 2'd3) begin
			RX_word_ready <= 1'b1;
		end
		
		TX_current_byte <= TX_current_byte;
		// Keep sending until we're done.
		if (start_TX_word == 1'b1 || TX_current_byte != 2'd0) begin
			start_TX_word <= 1'b0;
			
			TX <= TX_word[ (5'(2'd3 - TX_current_byte) * 5'd8)+:8 ];
			TX_current_byte <= TX_current_byte + 2'd1;
		end
		
	end
end
always_comb begin
	TX_word_ready = (start_TX_word == 1'b0 && TX_current_byte == 2'd0);
end


// The protocol is always as follows:
// { [31:0]NUMBER_OF_WORDS, [31:0]COMMAND, [31:0]WORDS[0:N] }
typedef enum logic [31:0] {
	SerialCommand_NOP = 32'd0,
	
	// Returns info about the processor that we're uploading to.
	SerialCommand_INFO = 32'd1,
	
	// Allows us to directly change the memory of the processor.
	// { 1 word start address, N-1 bytes of data }
	SerialCommand_UPLOAD = 32'd2,
	
	// Dump the memory of the processor.
	SerialCommand_DOWNLOAD = 32'd3
} SerialCommand;

logic [31:0]commandLength;
SerialCommand command;

logic [31:0]currentStep;
logic [31:0]lastStep;
logic [31:0]wordsReceived;
logic [31:0]wordsSent;

typedef enum logic [3:0] {
	READ_COMMAND_LENGTH,
	READ_COMMAND,
	PROCESS_COMMAND,
	BAD
} SerialCommandProcessorState;

SerialCommandProcessorState state;
SerialCommandProcessorState nextState;

always @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
	
		commandLength <= 32'd0;
		command <= SerialCommand_NOP;
		
		currentStep <= 32'd0;
		lastStep <= 32'd0;
		wordsReceived <= 32'd0;
		wordsSent <= 32'd0;
		
		state <= READ_COMMAND_LENGTH;
	end
	else begin
		// Assign the next state
		state <= nextState;
		
		// Reset variables if we're changing state
		if (nextState != state) begin
			wordsReceived <= 32'd0;
			wordsSent <= 32'd0;
			currentStep <= 32'd0;
		end
		
		// Read the command length.
		if (state == READ_COMMAND_LENGTH && RX_word_ready == 1'b1) begin
			commandLength <= RX_word;
		end
		// Read the command.
		if (state == READ_COMMAND && RX_word_ready == 1'b1) begin
			command <= SerialCommand'(RX_word);
		end
		if (nextState == PROCESS_COMMAND) begin
			unique case (command)
				SerialCommand_INFO: begin
					// The length of the command string minus 1.
					lastStep <= 32'd27;
				end
				default: begin
					lastStep <= 32'd0;
				end
			endcase
		end
		// Process the command.
		if (state == PROCESS_COMMAND) begin
			unique case (command)
				SerialCommand_NOP: begin end
				SerialCommand_INFO: begin
					if (TX_word_ready == 1'b1) begin
						if (wordsSent < 32'd111) begin
							// Send the next part of the info string.
							TX_word <= INFO_STRING[wordsSent];
							start_TX_word <= 1'b1;
							
							currentStep <= currentStep + 32'd1;
							wordsSent <= wordsSent + 32'd1;
						end
					end
				end
				SerialCommand_UPLOAD: begin
					
				end
				SerialCommand_DOWNLOAD: begin
				
				end
				default: begin end
			
			endcase
		end
	end
end

always_comb begin
	memoryAddress = 32'd0;
	memoryWordOut = 32'd0;
	writeToMemory = 1'b0;
	readFromMemory = 1'b0;

	unique case (state)
		READ_COMMAND_LENGTH: begin
			nextState = READ_COMMAND_LENGTH;
			if (wordsReceived == 32'd1) begin
				nextState = READ_COMMAND;
			end
		end
		READ_COMMAND: begin
			nextState = READ_COMMAND;
			if (wordsReceived == 32'd1) begin
				nextState = PROCESS_COMMAND;
			end
		end
		PROCESS_COMMAND: begin
			nextState = PROCESS_COMMAND;
			if (currentStep == lastStep) begin
				// We're done processing this command.
				nextState = READ_COMMAND_LENGTH;
			end
			
			unique case (command)
				SerialCommand_NOP,
				SerialCommand_INFO: begin
				
				end
				SerialCommand_UPLOAD: begin
					memoryAddress = currentStep;
					memoryWordOut = 32'd0;
					writeToMemory = 1'b1;
					readFromMemory = 1'b0;
				end
				default: begin

				end
			endcase
		end
		default: begin
			nextState = BAD;
		end
	endcase
end



endmodule