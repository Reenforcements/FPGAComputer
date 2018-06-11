
// This module implements the register file
//  of the processor.

module RegisterFile(
input logic clk,
input logic rst,
input logic [4:0]rsAddress,
input logic [4:0]rtAddress,
input logic [4:0]writeAddress,

input logic registerRead,
input logic registerWrite,

input logic [31:0]writeData,

output logic [31:0]readValue0,
output logic [31:0]readValue1
);

endmodule