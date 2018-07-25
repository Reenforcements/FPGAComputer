import MemoryModesPackage::ReadWriteModes;

module Main(
input logic clk,
input logic rst,

input logic UART_RXD,
input logic UART_CTS,

output logic UART_RTS,
output logic UART_TXD,

output logic LED1,
output logic LED2,
output logic LED3
);

// Gate the clock so we can "pause" the processor.
// Please see https://www.altera.com.cn/zh_CN/pdfs/literature/hb/qts/qts_qii51006.pdf
// section "Synchronous Clock Enables" for more info.
logic pause;
//logic gatedClkEnable;
logic gatedClk;
/*
always_ff @ (negedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		gatedClkEnable <= 1'b0;
	end
	else begin
		gatedClkEnable <= ~pause;
	end
end
always_comb begin
	gatedClk = gatedClkEnable & clk;
end*/
ProcessorClockEnabler pce(
		.inclk(clk),  //  altclkctrl_input.inclk
		.ena(pause),    //                  .ena
		.outclk(gatedClk) // altclkctrl_output.outclk
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
// Allows us to write to the memory from an external source
// such as a ModelSim test or RS232 serial connection.
logic externalMemoryControl;
logic [31:0]externalAddress;
logic [31:0]externalData;
logic [2:0]externalReadMode;
logic [2:0]externalWriteMode;
logic [31:0]externalDataOut;

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

/*
Processor processor(
	.clk(gatedClk),
	.memory_clk(clk),
	.rst(rst),
	
	.externalMemoryControl(externalMemoryControl),
	.externalAddress(externalAddress),
	.externalData(externalData),
	.externalReadMode(externalReadMode),
	.externalWriteMode(externalWriteMode),
	.externalDataOut(externalDataOut)
);
*/

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

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		// Pause must be changed on clk or it will be considered its own clock.
		pause <= 1'b1;
	end
	else begin
		pause <= serialCP_writeToMemory | serialCP_readFromMemory;
	end
end
always_comb begin
	// Set the read/write mode for external control.
	externalAddress = serialCP_memoryAddress;
	externalMemoryControl = serialCP_writeToMemory | serialCP_readFromMemory;
	// Pause if we're controlling the memory externally.
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
	LED1 = 1'b1;
	LED2 = 1'b1;
	LED3 = rst;
	serialCP_memoryWordIn = externalDataOut;
end

endmodule











