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

logic [7:0]TX;
logic en_TX;
logic TX_ready;

logic [7:0]RX;
logic hasRX;

logic txError;
logic rxError;

RS232 #(.BAUD_RATE(250000)) rs(
	.clk(clk),
	.rst(rst),
	
	.UART_RXD(UART_RXD),
	.UART_CTS(UART_CTS),
	
	.UART_RTS(UART_RTS),
	.UART_TXD(UART_TXD),
	
	.TX(TX),
	.en_TX(en_TX),
	.TX_ready(TX_ready),
	
	.RX(RX),
	.hasRX(hasRX),
	
	.rxError(rxError),
	.txError(txError)
);

logic [7:0]rxTemp;
logic didUseRX;
always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		en_TX <= 1'b0;
		didUseRX <= 1'b1;
	end
	else begin
		if (hasRX == 1'b1) begin
			rxTemp <= RX;
			didUseRX <= 1'b0;
		end
		
		if (TX_ready == 1'b1 && didUseRX == 1'b0) begin
			en_TX <= 1'b1;
			TX <= rxTemp;
			didUseRX <= 1'b1;
		end
		else begin
			en_TX <= 1'b0;
		end
	end
	
	// The red LEDs are not inverted.
	//LED1 <= rst;
end

always_comb begin
	LED1 = rxError;
	LED2 = txError;
end

endmodule











