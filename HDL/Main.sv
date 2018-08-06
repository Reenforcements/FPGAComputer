//import MemoryModesPackage::ReadWriteModes;
import MemoryModesPackage::*;

`timescale 1ps / 1ps

module Main(
input logic clkIn,
input logic rstIn,

// UART
input logic UART_RXD,
input logic UART_CTS,

output logic UART_RTS,
output logic UART_TXD,

//	PS/2 Keyboard
input logic PS2_CLK,
input logic PS2_DAT,

// Outputs
output logic [6:0]seg7,
output logic [6:0]seg6,
output logic [6:0]seg5,
output logic [6:0]seg4,
output logic [6:0]seg3,
output logic [6:0]seg2,
output logic [6:0]seg1,
output logic [6:0]seg0,

output logic LED1,
output logic LED2,
output logic LED3
);
parameter BAUD_RATE = 250000;


// Synchronous reset
// (Commented out because it doesn't work.)
/*
logic rstIn_d0;
logic rstIn_d1;
logic rstIn_d2;
logic rstIn;
always_ff @ (posedge clk or negedge rstIn) begin
	if (rstIn == 1'b0) begin
		rstIn_d0 <= 1'b0;
		rstIn_d1 <= 1'b0;
		rstIn_d2 <= 1'b0;
		rstIn <= 1'b0;
	end
	else begin
		rstIn_d0 <= rstIn;
		rstIn_d1 <= rstIn_d0;
		rstIn_d2 <= rstIn_d1;
		rstIn <= rstIn_d2;
	end
end
*/

logic clk;
logic [7:0]clkCounter;
always_ff @ (posedge clkIn or negedge rstIn) begin
	if (rstIn == 1'b0) begin
		clk <= 1'b1;
		clkCounter <= 8'd1;
	end
	else begin
		if (clkCounter == 8'd3) begin
			clk <= ~clk;
			clkCounter <= 8'd1;
		end
		else begin
			clkCounter <= clkCounter + 8'd1;
		end
	end
end

// Gate the clock so we can "pause" the processor.
// Please see https://www.altera.com.cn/zh_CN/pdfs/literature/hb/qts/qts_qii51006.pdf
// section "Synchronous Clock Enables" for more info.
logic pause;
logic gatedClk;


ProcessorClockEnabler pce(
		.inclk(clk),  //  altclkctrl_input.inclk
		.ena(~pause),    //                  .ena
		.outclk(gatedClk) // altclkctrl_output.outclk
	);
/*
always_comb begin
	gatedClk = clk;
end
*/

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

logic force_rst;
logic rst;

always_comb begin
	// The reset for most components is controlled by the reset switch or
	//  the force_rst line which is controlled by serial commands.
	rst = rstIn & force_rst;
end


RS232 #(.BAUD_RATE(BAUD_RATE), .CLOCK_SPEED(8333333)) rs(
	.clk(clk),
	.rst(rstIn),
	
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

logic [31:0]sevenSegmentDisplayOutput;

Processor #(.CLOCK_SPEED(8333333)) processor(
	.clk(gatedClk),
	.memory_clk(clk),
	.rst(rst),
	.memory_rst(rstIn),
	
	.PS2_CLK(PS2_CLK),
	.PS2_DAT(PS2_DAT),
	
	.externalMemoryControl(externalMemoryControl),
	.externalAddress(externalAddress),
	.externalData(externalData),
	.externalReadMode(externalReadMode),
	.externalWriteMode(externalWriteMode),
	.externalDataOut(externalDataOut),
	
	.sevenSegmentDisplayOutput(sevenSegmentDisplayOutput)
);

// 7 Segment Displays
Output7Seg display_seg7(.inp(sevenSegmentDisplayOutput[31:28]), .display(seg7));
Output7Seg display_seg6(.inp(sevenSegmentDisplayOutput[27:24]), .display(seg6));
Output7Seg display_seg5(.inp(sevenSegmentDisplayOutput[23:20]), .display(seg5));
Output7Seg display_seg4(.inp(sevenSegmentDisplayOutput[19:16]), .display(seg4));
Output7Seg display_seg3(.inp(sevenSegmentDisplayOutput[15:12]), .display(seg3));
Output7Seg display_seg2(.inp(sevenSegmentDisplayOutput[11:8]), .display(seg2));
Output7Seg display_seg1(.inp(sevenSegmentDisplayOutput[7:4]), .display(seg1));
Output7Seg display_seg0(.inp(sevenSegmentDisplayOutput[3:0]), .display(seg0));


// Set up a state machine to allow us to change memory through serial.
SerialCommandProcessor serialCP(
.clk(clk),
.rst(rstIn),

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
.memoryWordIn(serialCP_memoryWordIn),

.force_rst(force_rst)
);

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		// Pause must be changed on clk or it will be considered its own clock.
		pause <= 1'b0;
	end
	else begin
		pause <= 1'b0;//serialCP_writeToMemory | serialCP_readFromMemory;
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
	LED1 = rstIn;
	LED2 = force_rst;
	LED3 = rst;
	serialCP_memoryWordIn = externalDataOut;
end

endmodule











