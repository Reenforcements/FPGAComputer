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

Testing test1(.*);

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

endmodule
