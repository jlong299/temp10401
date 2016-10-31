
module RAM_dct_preFFT_reod (
	data,
	wraddress,
	rdaddress,
	wren,
	clock,
	q);	

	input	[31:0]	data;
	input	[10:0]	wraddress;
	input	[10:0]	rdaddress;
	input		wren;
	input		clock;
	output	[31:0]	q;
endmodule
