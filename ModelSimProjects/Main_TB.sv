
`timescale 1 ps / 1 ps


module Main_TB;

logic RS232_UART_RXD;
// CTS is pulled low when the computer is ready to RX_RECEIVE data.
logic RS232_UART_CTS;

logic RS232_UART_RTS;
logic RS232_UART_TXD;

logic [7:0]RS232_TX;
logic RS232_start_TX;
logic RS232_TX_ready;

logic [7:0]RS232_RX;
logic RS232_hasRX;

logic RS232_txError;
logic RS232_rxError;


logic clkIn;
logic rstIn;

logic Main_UART_RXD;
logic Main_UART_CTS;

logic Main_UART_RTS;
logic Main_UART_TXD;

logic Main_LED1;
logic Main_LED2;
logic Main_LED3;

initial begin
rstIn = 0;
end

always begin
	#20;
	rstIn = 1;
	#2094967295;
end

// Read and write using another instance of RS232 so
//  we don't have to generate the signals ourselves.
RS232 #(.BAUD_RATE(250000), .CLOCK_SPEED(50000000)) fakeRS232Cable(
 .clk(clkIn),
 .rst(rstIn),

 .UART_RXD(RS232_UART_RXD),
// CTS is pulled low when the computer is ready to RX_RECEIVE data.
 .UART_CTS(RS232_UART_CTS),

 .UART_RTS(RS232_UART_RTS),
 .UART_TXD(RS232_UART_TXD),

 .TX(RS232_TX),
 .start_TX(RS232_start_TX),
 .TX_ready(RS232_TX_ready),

 .RX(RS232_RX),
 .hasRX(RS232_hasRX),

 .txError(RS232_txError),
 .rxError(RS232_rxError)
);

Main #(.BAUD_RATE(250000)) main(
 .clkIn(clkIn),
 .rstIn(rstIn),

 .UART_RXD(Main_UART_RXD),
 .UART_CTS(Main_UART_CTS),

 .UART_RTS(Main_UART_RTS),
 .UART_TXD(Main_UART_TXD),

 .LED1(Main_LED1),
 .LED2(Main_LED2),
 .LED3(Main_LED3)
);

always_comb begin
Main_UART_RXD = RS232_UART_TXD;
RS232_UART_RXD = Main_UART_TXD;
end

always begin
	clkIn = 0;
	#5;
	clkIn = 1;
	#5;
end

// Send data
logic [31:0]WORDS_TO_SEND[28] = {
// FORCE_RST LOW
32'h00000000,
32'h00000005,

// UPLOAD
32'h00000000,
32'h00000002,

32'h00000400,
32'h00000420,

32'h12345678,
32'hAABBAABB,
32'hCCCCCCCC,
32'h11112222,
32'h12345678,
32'hAABBAABB,
32'hCCCCCCCC,
32'h11112222,

// DOWNLOAD
32'h00000000,
32'h00000003,

32'h00000400,
32'h00000420,

// A couple NOPs
32'h00000000,
32'h00000000,
32'h00000000,
32'h00000000,
32'h00000000,
32'h00000000,
32'h00000000,
32'h00000000,


32'h00000000,
32'h00000004

};
logic [31:0]n;
logic [3:0]g;
always begin
	#20;
	for (n = 0; n < 28; n = n + 1) begin
		for (g = 0; g < 4; g = (RS232_TX_ready == 1) ? g + 1 : g) begin
			RS232_TX = WORDS_TO_SEND[n][ (5'(2'd3 - g) * 5'd8)+:8 ];
			RS232_start_TX = RS232_TX_ready;
			#10;
			//g = (RS232_TX_ready == 1) ? g + 1 : g;
		end
		/*
		RS232_TX = WORDS_TO_SEND[n][31:24];
		RS232_start_TX = 1'b1;
		#(10 * 8 * 10);
		RS232_TX = WORDS_TO_SEND[n][23:16];
		RS232_start_TX = 1'b1;
		#(10 * 8 * 10);
		RS232_TX = WORDS_TO_SEND[n][15:8];
		RS232_start_TX = 1'b1;
		#(10 * 8 * 10);
		RS232_TX = WORDS_TO_SEND[n][7:0];
		RS232_start_TX = 1'b1;
		#(10 * 8 * 10);*/
		//$display("(%d)Sent word: %h", n, WORDS_TO_SEND[n]);
	end
	$display("Done");
	#200000000;
end
always begin
	if(RS232_hasRX) begin
		$display("RX data: hex:%h string:%s", RS232_RX, RS232_RX);
		#5; 
	end
	#5;
end

endmodule










