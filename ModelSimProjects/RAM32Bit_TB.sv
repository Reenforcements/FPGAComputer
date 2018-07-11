
`timescale 1 ps / 1 ps

module RAM32Bit_TB;

logic	[3:0]  byteena_a;
logic clk;
logic	  clock;
logic	[31:0]  data;
logic	[15:0]  rdaddress;
logic	  rden;
logic	[15:0]  wraddress;
logic	  wren;
logic	[31:0]  q;

initial begin
clk = 0;
clock = 0;
end


RAM32Bit ram(
	byteena_a,
	clock,
	data,
	rdaddress,
	rden,
	wraddress,
	wren,
	q);

always begin
clk = 1;
#5;
clk = 0;
#5;
end

always begin
clock = ~clk;
#5;
clock = ~clk;
#5;
end

always begin
#5;
byteena_a = 4'b1111;
data = 32'hABCDFFFF;
rdaddress = 32'hx;
rden = 0;
wraddress = 32'd45000;
wren = 1;
#9;
$display("Output: %h", q);
#1;

byteena_a = 4'b1111;
data = 32'h0;
rdaddress = 32'd45000;
rden = 1;
wraddress = 32'd0;
wren = 0;
#9;
$display("Output: %h", q);
#1;

end



endmodule