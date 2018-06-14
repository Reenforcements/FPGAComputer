module Memory_TB;

logic clk;
logic rst;

logic [31:0]address;
logic [31:0]data;
logic [2:0]writeMode;
logic [2:0]readMode;

logic unsignedLoad;

logic [31:0]pcAddress;

logic [31:0]dataOutput;
logic [31:0]pcDataOutput;

initial begin
	clk = 0;
	ungisnedLoad = 0;
end


Memory m1(.*);

always begin
#5;
clk = 1;
#5;
clk = 0;
end

always begin

// Set things for clock
address = 16'hFFFFABCD;
data = 16'h12345678;
writeMode = WORD;
readMode = NONE;
ungisnedLoad = 0;
#10;

// Set things for clock
address = 16'hFFFFABCD;
data = 16'h12345678;
writeMode = WORD;
readMode = NONE;
ungisnedLoad = 0;
#10;


end


endmodule






