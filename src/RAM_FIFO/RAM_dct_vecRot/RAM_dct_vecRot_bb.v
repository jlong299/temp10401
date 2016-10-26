
module RAM_dct_vecRot (
	data,
	wraddress,
	rdaddress,
	wren,
	clock,
	q);	

	input	[55:0]	data;
	input	[9:0]	wraddress;
	input	[9:0]	rdaddress;
	input		wren;
	input		clock;
	output	[55:0]	q;
endmodule
