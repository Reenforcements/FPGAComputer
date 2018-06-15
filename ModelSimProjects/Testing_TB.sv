module Testing_TB;

logic [15:0]counter;

logic clk;
logic rst;
logic inp1;
logic [1:0]out1;

initial begin
rst = 0;
clk = 0;
inp1 = 0;
counter = 0;
end

//Testing test1(.*);

always begin
	case(counter)
		16'b0:		
			begin	
				rst = 0;
				#10;
			end
		16'b1:
			begin
				rst = 1;
				#10;
			end
		default:
			break;
	endcase
end

always begin	
	#10;
	counter = counter + 1;
	clk = !clk;
end

logic [31:0]h1;
logic [7:0]memory[7:0];
logic [7:0]index;
initial begin
	index = 0;
	memory[0] = 8'h12;
	memory[1] = 8'h34;
	memory[2] = 8'h56;
	memory[3] = 8'h78;
	memory[4] = 8'h9A;
	memory[5] = 8'hBC;
	memory[6] = 8'hDE;
	memory[7] = 8'hF0;
end

always begin	
	#5;
	index = 3;
	h1 = 32'(memory[index+:4]);
	$display("%h", h1);
end

endmodule




