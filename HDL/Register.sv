// This module is a generic register for pipelining
//  the processor.
parameter SIZE = 1;
module Register
(
input logic clk,
input logic rst,

input logic [SIZE-1:0]in,
output logic [SIZE-1:0]out
);

logic [SIZE-1:0]register;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		register = 0;
	end
	else begin
		register <= in;
	end
end

always_comb begin
	out = register;
end


endmodule
