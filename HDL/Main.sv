import MemoryModesPackage::ReadWriteModes;

module Main(
input logic clk,
input logic rst,

input logic UART_RXD,
input logic UART_CTS,

output logic UART_RTS,
output logic UART_TXD,

output logic LED1,
output logic LED2
);

// UART
logic [7:0]TX;
logic start_TX;
logic TX_ready;

logic [7:0]RX;
logic hasRX;

logic txError;
logic rxError;

// PROCESSOR
// ----------
// Pauses the processor so we can change data in memory.
logic pause;

// Allows us to write to the memory from an external source
// such as a ModelSim test or RS232 serial connection.
logic externalMemoryControl;
logic [31:0]externalAddress;
logic [31:0]externalData;
logic [2:0]externalReadMode;
logic [2:0]externalWriteMode;
logic [31:0]externalDataOut;
// ----------

// serialCP
logic serialCP_writeToMemory;
logic serialCP_readFromMemory;
logic [31:0]serialCP_memoryAddress;
logic [31:0]serialCP_memoryWordOut;
logic [31:0]serialCP_memoryWordIn;


RS232 #(.BAUD_RATE(250000)) rs(
	.clk(clk),
	.rst(rst),
	
	.UART_RXD(UART_RXD),
	.UART_CTS(UART_CTS),
	
	.UART_RTS(UART_RTS),
	.UART_TXD(UART_TXD),
	
	.TX(TX),
	.start_TX(start_TX),
	.TX_ready(TX_ready),
	
	.RX(RX),
	.hasRX(hasRX),
	
	.rxError(rxError),
	.txError(txError)
);

Processor processor(
	.clk(clk),
	.rst(rst),
	
	.pause(pause),
	
	.externalMemoryControl(externalMemoryControl),
	.externalAddress(externalAddress),
	.externalData(externalData),
	.externalReadMode(externalReadMode),
	.externalWriteMode(externalWriteMode),
	.externalDataOut(externalDataOut)
)/*synthesis keep*/;

// Set up a state machine to allow us to change memory through serial.
SerialCommandProcessor serialCP(
.clk(clk),
.rst(rst),

// RS232
.RX(RX),
.RX_ready(hasRX),

.TX(TX),
.start_TX(start_TX),
.TX_ready(TX_ready),

// Memory control
.writeToMemory(serialCP_writeToMemory),
.readFromMemory(serialCP_readFromMemory),
.memoryAddress(serialCP_memoryAddress),
.memoryWordOut(serialCP_memoryWordOut),
.memoryWordIn(serialCP_memoryWordIn)
);

always_comb begin
	// Set the read/write mode for external control.
	externalAddress = serialCP_memoryAddress;
	externalMemoryControl = serialCP_writeToMemory | serialCP_readFromMemory;
	// Pause if we're controlling the memory externally.
	pause = serialCP_writeToMemory | serialCP_readFromMemory;
	LED1 = serialCP_writeToMemory;
	LED2 = serialCP_readFromMemory;
	if (serialCP_writeToMemory == 1'b1) begin
		externalWriteMode = WORD;
		externalReadMode = ReadWriteMode_NONE;
	end
	else if (serialCP_readFromMemory == 1'b1) begin
		externalWriteMode = ReadWriteMode_NONE;
		externalReadMode = WORD;
	end
	else begin
		externalWriteMode = ReadWriteMode_NONE;
		externalReadMode = ReadWriteMode_NONE;
	end
	
	// Assign other memory lines.
	externalData = serialCP_memoryWordOut;
	serialCP_memoryWordIn = externalDataOut;
end

endmodule











