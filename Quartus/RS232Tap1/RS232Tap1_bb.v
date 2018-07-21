
module RS232Tap1 (
	acq_data_in,
	acq_trigger_in,
	acq_clk,
	trigger_in);	

	input	[5:0]	acq_data_in;
	input	[0:0]	acq_trigger_in;
	input		acq_clk;
	input		trigger_in;
endmodule
