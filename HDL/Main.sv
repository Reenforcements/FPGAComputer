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

Processor p(.*);

// Set up a state machine to allow us to change memory through serial.


/*
logic [7:0]rxTemp;
logic didUseRX;
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		start_TX <= 1'b0;
		didUseRX <= 1'b1;
	end
	else begin
		if (hasRX == 1'b1) begin
			rxTemp <= RX;
			didUseRX <= 1'b0;
		end
		
		if (TX_ready == 1'b1 && didUseRX == 1'b0) begin
			start_TX <= 1'b1;
			TX <= rxTemp;
			didUseRX <= 1'b1;
		end
		else begin
			start_TX <= 1'b0;
		end
	end
end
*/



always_comb begin
	LED1 = 1'b0;
	LED2 = 1'b0;
end

endmodule











