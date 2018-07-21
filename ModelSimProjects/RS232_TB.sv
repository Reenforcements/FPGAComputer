`timescale 1 ps / 1 ps

module RS232_TB;

logic clk;
logic rst;

logic UART_RXD;
logic UART_CTS;

logic UART_RTS;
logic UART_TXD;

logic [7:0]TX;
logic en_TX;
logic TX_ready;

logic [7:0]RX;
logic hasRX;

parameter logic [31:0]CYCLES_PER_BIT = 32'd50000000 / 32'd9600;
parameter logic [31:0]TIME_BIT = CYCLES_PER_BIT * 32'd10;
RS232 #( .BAUD_RATE(9600) ) rs(.*);

initial begin
clk = 0;
rst = 0;
UART_RXD = 1'b1;
end

always begin
$display("CYCLES_PER_BIT: %d, TIME_BIT: %d", CYCLES_PER_BIT, TIME_BIT);
#10;
rst = 1;
#10;


// Start sending
TX = 8'b11001010;
en_TX = 1'b1;
assert(TX_ready == 1'b1) else $error("TX not ready!");
// Start receiving
UART_RXD = 1'b0;
#TIME_BIT;
en_TX = 1'b0;


UART_RXD = 1'b1;
#TIME_BIT;
UART_RXD = 1'b0;
#TIME_BIT;
UART_RXD = 1'b1;
#TIME_BIT;
UART_RXD = 1'b0;
#TIME_BIT;
UART_RXD = 1'b0;
#TIME_BIT;
UART_RXD = 1'b0;
#TIME_BIT;
UART_RXD = 1'b0;
#TIME_BIT;
UART_RXD = 1'b0;
#TIME_BIT;

UART_RXD = 1'b1;
#TIME_BIT;

//#20;
//TX = 8'b11001010;
//en_TX = 1'b1;
//assert(TX_ready == 1'b1) else $error("TX not ready!");
//#10;
//en_TX = 1'b0;
//#((TIME_BIT * 10) - 10);
//assert(TX_ready == 1'b1) else $error("TX not ready!");

$display("Done");
#100000000;
end

always begin
	if (hasRX == 1'b1) begin
		assert(hasRX == 1'b1 && RX == 8'b00000101)
			$display(" (%d) Successfully received: %b", $time, RX);
		else
			$error("Didn't successfully receive: %b, %b", RX, hasRX);
	end
	#10;
end

always begin
clk = 0;
#5;
clk = 1;
#5;
end

endmodule