`timescale 1ps / 1ps

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
input logic [31:0]memoryWordIn,

// Processor control
output logic force_rst

);

// This is the string sent to the computer with the INFO command.
// It was encoded using stringToVerilog.py in the Communication directory.
logic [31:0]INFO_STRING[0:27] = '{
32'h0a5a4950, 32'h53202d20, 32'h41204d49, 32'h50532049, 
32'h20636f6d, 32'h70757465, 32'h72200a56, 32'h65727369, 
32'h6f6e2031, 32'h2e300a41, 32'h75737479, 32'h6e204c61, 
32'h726b696e, 32'h0a466f72, 32'h20556e69, 32'h74656420, 
32'h53756d6d, 32'h65722053, 32'h63686f6c, 32'h61727320, 
32'h70726f67, 32'h72616d20, 32'h6174204d, 32'h69616d69, 
32'h20556e69, 32'h76657273, 32'h6974792e, 32'h00000000
};

// Sending words through serial one byte at a time
// ____________________________________________________

typedef enum logic [4:0] {
	WORDTXSTATE_WAITING,
	WORDTXSTATE_SENDING,
	WORDTXSTATE_DONE,
	WORDTXSTATE_BAD
} WordTXState;

// Comb
logic [31:0]WordTX_word;
logic [31:0]WordTX_word_next;
logic WordTX_start;

WordTXState WordTX_nextState;
logic WordTX_ready;
logic WordTX_done;
logic [2:0]WordTX_currentByte_next;

// Reg
WordTXState WordTX_state;
logic [31:0]WordTX_word_reg;
logic [2:0]WordTX_currentByte_reg;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		WordTX_state <= WORDTXSTATE_WAITING;
		WordTX_word_reg <= 32'd0;
		WordTX_currentByte_reg <= 3'd0;
	end
	else begin
		WordTX_state <= WordTX_nextState;
		WordTX_word_reg <= WordTX_word_next;
		WordTX_currentByte_reg <= WordTX_currentByte_next;
	end
end

always_comb begin
	WordTX_ready = 1'b0;
	WordTX_word_next = WordTX_word_reg;
	start_TX = 1'b0;
	TX = 8'd0;
	WordTX_currentByte_next = WordTX_currentByte_reg;
	WordTX_done = 1'b0;
	
	unique case (WordTX_state)
		WORDTXSTATE_WAITING: begin
			WordTX_ready = 1'b1;
			WordTX_nextState = WORDTXSTATE_WAITING;
			if (WordTX_start == 1'b1) begin
				WordTX_word_next = WordTX_word;
				WordTX_nextState = WORDTXSTATE_SENDING;
				WordTX_currentByte_next = 3'd0;
			end
		end
		WORDTXSTATE_SENDING: begin
			WordTX_nextState = WORDTXSTATE_SENDING;
			
			if (TX_ready == 1'b1) begin
				if (WordTX_currentByte_next <= 3'd3) begin
					start_TX = 1'b1;
					TX = WordTX_word_reg[ (5'(2'd3 - WordTX_currentByte_reg) * 5'd8)+:8 ];
					WordTX_currentByte_next = WordTX_currentByte_reg + 3'd1;
				end
				else begin
					WordTX_nextState = WORDTXSTATE_DONE;
				end
			end
		end
		WORDTXSTATE_DONE: begin
			WordTX_nextState = WORDTXSTATE_WAITING;
			WordTX_done = 1'b1;
		end
		default: begin
			WordTX_nextState = WORDTXSTATE_BAD;
		end
	endcase
end

// Receiving words through serial one byte at a time
// ____________________________________________________
typedef enum logic [2:0] {
	WORDRXSTATE_RECEIVING,
	WORDRXSTATE_DONE,
	WORDRXSTATE_BAD
} WordRXState;

// Comb
WordRXState WordRX_nextState;
logic [1:0]WordRX_currentByte_next;
logic WordRX_ready;
logic [7:0]WordRX_byte_next;

//Reg
WordRXState WordRX_state;
logic [1:0]WordRX_currentByte_reg;
logic [31:0]WordRX_word;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		WordRX_state <= WORDRXSTATE_RECEIVING;
		WordRX_currentByte_reg <= 2'd0;
		WordRX_word <= 32'd0;
	end
	else begin
		WordRX_state <= WordRX_nextState;
		WordRX_currentByte_reg <= WordRX_currentByte_next;
		WordRX_word[ (5'(2'd3 - WordRX_currentByte_reg) * 5'd8)+:8] <= WordRX_byte_next;
	end
end

always_comb begin
	WordRX_byte_next = WordRX_word[ (5'(2'd3 - WordRX_currentByte_reg) * 5'd8)+:8];
	WordRX_currentByte_next = WordRX_currentByte_reg;
	WordRX_ready = 1'b0;
	
	unique case (WordRX_state)
		WORDRXSTATE_RECEIVING: begin
			WordRX_nextState = WORDRXSTATE_RECEIVING;
			
			if (RX_ready == 1'b1) begin
				WordRX_byte_next = RX;
				WordRX_currentByte_next = WordRX_currentByte_reg + 2'd1;
				if (WordRX_currentByte_reg == 2'd3) begin
					WordRX_nextState = WORDRXSTATE_DONE;
				end
			end
		end
		WORDRXSTATE_DONE: begin
			WordRX_nextState = WORDRXSTATE_RECEIVING;
			WordRX_ready = 1'b1;
		end
		default: begin
			WordRX_nextState = WORDRXSTATE_BAD;
		end
	endcase
end

// The protocol is always as follows:
typedef enum logic [3:0] {
	SCP_READ_COMMAND_LENGTH,
	SCP_READ_COMMAND,
	SCP_PROCESS_COMMAND,
	SCP_BAD
} SerialCommandProcessorState;

// { [31:0]NUMBER_OF_WORDS, [31:0]COMMAND, [31:0]WORDS[0:N] }
typedef enum logic [31:0] {
	SerialCommand_NOP = 32'd0,
	// Returns info about the processor that we're uploading to.
	SerialCommand_INFO = 32'd1,
	// Allows us to directly change the memory of the processor.
	// { 1 word start address, N-1 bytes of data }
	SerialCommand_UPLOAD = 32'd2,
	// Dump the memory of the processor.
	SerialCommand_DOWNLOAD = 32'd3,
	// Put force_rst high so the processor runs.
	SerialCommand_FORCE_RST_HIGH = 32'd4,
	// Put force_rst low so the processor DOESN'T run.
	SerialCommand_FORCE_RST_LOW = 32'd5
} SerialCommand;

typedef enum logic [7:0] {
	RX_DESTINATION_NONE,
	RX_DESTINATION_COMMAND_LENGTH,
	RX_DESTINATION_COMMAND,
	RX_DESTINATION_START_ADDRESS,
	RX_DESTINATION_END_ADDRESS,
	RX_DESTINATION_MEMORY
} RX_Destination;

logic [31:0]commandLength;
SerialCommand command;
logic [31:0]memory_startAddress;
logic [31:0]memory_endAddress;

SerialCommandProcessorState SCP_state;
SerialCommandProcessorState SCP_nextState;
logic [31:0]currentStep;
logic [31:0]currentStep_next;
logic [31:0]wordsSent;
logic [31:0]wordsSent_next;
logic [31:0]wordsReceived;
logic [31:0]wordsReceived_next;


RX_Destination RXDestination;
logic RXComplete;

logic waitForTX;
logic [31:0]TXSource;
logic TXComplete;

logic force_rst_next;


always @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		SCP_state <= SCP_READ_COMMAND_LENGTH;
		
		commandLength <= 32'd0;
		command <= SerialCommand_NOP;
		
		memory_startAddress <= 32'd0;
		memory_endAddress <= 32'd0;
		
		currentStep <= 32'd0;
		wordsSent <= 32'd0;		
		wordsReceived <= 32'd0;
		
		force_rst <= 1'b0;
	end
	else begin
		
		if (WordRX_ready == 1'b1) begin
			unique case (RXDestination)
				RX_DESTINATION_COMMAND_LENGTH: begin
					commandLength <= WordRX_word;
				end
				RX_DESTINATION_COMMAND: begin
					command <= SerialCommand'(WordRX_word);
					$display("Command is: %d", WordRX_word);
				end
				RX_DESTINATION_START_ADDRESS: begin
					memory_startAddress <= WordRX_word;
				end
				RX_DESTINATION_END_ADDRESS: begin
					memory_endAddress <= WordRX_word;
				end	
				RX_DESTINATION_MEMORY: begin
					
				end
				default: begin
					// Don't do anything.
				end
			endcase
		end
		
		currentStep <= currentStep_next;
		wordsSent <= wordsSent_next;
		wordsReceived <= wordsReceived_next;

		SCP_state <= SCP_nextState;
		if (SCP_state != SCP_nextState) begin
			currentStep <= 32'd0;
			wordsSent <= 32'd0;
		end
		
		force_rst <= force_rst_next;
	end
end

always_comb begin
	memoryAddress = 32'd0;
	memoryWordOut = 32'd0;
	writeToMemory = 1'b0;
	readFromMemory = 1'b0;
	
	RXDestination = RX_DESTINATION_NONE;
	RXComplete = WordRX_ready;
	
	WordTX_word = TXSource;
	// Only start if we're waiting for TX to send and WordTX is ready.
	WordTX_start = waitForTX & WordTX_ready;
	TXComplete = WordTX_done;
	TXSource = 32'd0;
	waitForTX = 1'b0;
	
	currentStep_next = currentStep;
	if (RXComplete == 1'b1 || TXComplete == 1'b1) begin
		currentStep_next = currentStep + 32'd1;
	end
	
	wordsSent_next = wordsSent;
	if (TXComplete == 1'b1) begin
		wordsSent_next = wordsSent + 32'd1;
	end
	
	wordsReceived_next = wordsReceived;
	if (RXComplete == 1'b1) begin
		wordsReceived_next = wordsReceived + 32'd1;
	end
	
	force_rst_next = force_rst;
	
	unique case (SCP_state)
		SCP_READ_COMMAND_LENGTH: begin
			SCP_nextState = SCP_READ_COMMAND_LENGTH;
			RXDestination = RX_DESTINATION_COMMAND_LENGTH;
			if (RXComplete == 1'b1) begin
				SCP_nextState = SCP_READ_COMMAND;
			end
		end
		SCP_READ_COMMAND: begin
			SCP_nextState = SCP_READ_COMMAND;
			RXDestination = RX_DESTINATION_COMMAND;
			if (RXComplete == 1'b1) begin
				SCP_nextState = SCP_PROCESS_COMMAND;
			end
		end
		SCP_PROCESS_COMMAND: begin
			SCP_nextState = SCP_PROCESS_COMMAND;
			
			// Command-specific logic
			unique case (command)
				SerialCommand_NOP: begin
					SCP_nextState = SCP_READ_COMMAND_LENGTH;
				end
				SerialCommand_INFO: begin
					if (currentStep == 32'd0) begin
						// Send the length of the info string.
						TXSource = 32'd28;
						waitForTX = 1'b1;
						wordsSent_next = 32'd0;
						//$error("Hit send info string size: %b, %b, %h", waitForTX, WordTX_start, TXSource);
					end
					else begin
						if (wordsSent > 32'd27) begin
							// Done sending info string
							SCP_nextState = SCP_READ_COMMAND_LENGTH;
						end 
						else begin
							// Send the info string word by word.
							TXSource = INFO_STRING[wordsSent];
							waitForTX = 1'b1;
						end
					end
				end
				SerialCommand_UPLOAD: begin
					if (currentStep == 32'd0) begin
						// Get the start address
						RXDestination = RX_DESTINATION_START_ADDRESS;
					end
					else if (currentStep == 32'd1) begin
						RXDestination = RX_DESTINATION_END_ADDRESS;
						// Reset the number of words received so we can keep track of how many
						//  words we've written to memory.
						wordsReceived_next = 32'd0;
					end
					else if (currentStep == 32'd2) begin
						// Read a word
						RXDestination = RX_DESTINATION_MEMORY;
					end
					else if (currentStep == 32'd3) begin
						// Save a word
						memoryAddress = memory_startAddress + ((wordsReceived - 32'd1) << 32'd2);
						memoryWordOut = WordRX_word;
						writeToMemory = 1'b1;
						//$display("Writing: %h to memory.", WordRX_word);
						
						// Repeat if necessary
						if ((wordsReceived << 32'd2) == (memory_endAddress - memory_startAddress)) begin
							// We're done.
							SCP_nextState = SCP_READ_COMMAND_LENGTH;
							//$display("Done uploading: %d == %d", wordsReceived << 32'd2, (memory_endAddress - memory_startAddress));
						end
						else begin
							// Keep going
							currentStep_next = 32'd2;
						end
					end
				end
				SerialCommand_DOWNLOAD: begin
					if (currentStep == 32'd0) begin
						// Get the start address
						RXDestination = RX_DESTINATION_START_ADDRESS;
					end
					else if (currentStep == 32'd1) begin
						RXDestination = RX_DESTINATION_END_ADDRESS;
					end
					else if (currentStep == 32'd2) begin
						// Read from memory
						memoryAddress = memory_startAddress + (wordsSent << 32'd2);
						readFromMemory = 1'b1;
						currentStep_next = 32'd3;
					end
					else if (currentStep == 32'd3) begin
						// Send the word we read
						TXSource = memoryWordIn;
						waitForTX = 1'b1;
					end
					else if (currentStep == 32'd4) begin
						// Repeat if necessary
						if ((wordsSent << 32'd2) == (memory_endAddress - memory_startAddress)) begin
							// We're done.
							SCP_nextState = SCP_READ_COMMAND_LENGTH;
						end
						else begin
							// Keep going
							currentStep_next = 32'd2;
						end
					end
				end
				SerialCommand_FORCE_RST_HIGH: begin
					SCP_nextState = SCP_READ_COMMAND_LENGTH;
					force_rst_next = 1'b1;
				end
				SerialCommand_FORCE_RST_LOW: begin
					SCP_nextState = SCP_READ_COMMAND_LENGTH;
					force_rst_next = 1'b0;
				end
				default: begin
					// We received a bad command.
					SCP_nextState = SCP_READ_COMMAND_LENGTH;
				end
			endcase
		end
		default: begin
			SCP_nextState = SCP_BAD;
		end
	endcase
end



endmodule