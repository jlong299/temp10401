//-----------------------------------------------------------------
// Module Name:        	dct_vecRot_scaling.v
// Project:             CE RTL
// Description:         
// Author:				Long Jiang
//------------------------------------------------------------------
//  Version 0.1
//  Description :  First version 
//  2016-10-24
//  ----------------------------------------------------------------


module dct_vecRot_scaling #(parameter  
		wDataIn = 22,  
		wDataOut =16  
	)
	(
	// left side
	input 					rst_n_sync,  // clk synchronous reset active low
	input 					clk,    

	input wire        	sink_valid, // sink.sink_valid
	output wire        	sink_ready, //       .sink_ready
	input wire [1:0]  	sink_error, //       .sink_error
	input wire        	sink_sop,   //       .sink_sop
	input wire        	sink_eop,   //       .sink_eop
	input wire [wDataIn-1:0] sink_real,  //       .sink_real
	input wire [wDataIn-1:0] sink_imag,  //       .sink_imag

	input wire [11:0] fftpts_in,    //       .fftpts_in

	//right side
	output wire         source_valid, // source.source_valid
	input  wire        	source_ready, //       .source_ready
	output wire [1:0]  	source_error, //       .source_error
	output wire        	source_sop,   //       .source_sop
	output wire        	source_eop,   //       .source_eop
	output reg [wDataOut-1:0] source_real,  //       .source_real
	output reg [wDataOut-1:0] source_imag,  //       .source_imag
	output wire [11:0] fftpts_out    //       .fftpts_out
	);

assign 	source_error = 2'b00;
assign  fftpts_out = fftpts_in;
assign 	sink_ready = source_ready;
assign 	source_valid = sink_valid;
assign 	source_sop = sink_sop;
assign 	source_eop = sink_eop;

always@(*)
begin
	if ( (sink_real[wDataIn-1:wDataOut-1]) == {(wDataIn - wDataOut + 1){1'b0}} ||
		 (sink_real[wDataIn-1:wDataOut-1]) == {(wDataIn - wDataOut + 1){1'b1}} )
		source_real = sink_real[wDataOut-1:0];
	else if ( sink_real[wDataIn-1]==1'b0 )
		source_real = {1'b0, {(wDataOut-1){1'b1}} };
	else
		source_real = {1'b1, {(wDataOut-1){1'b0}} };

	if ( (sink_imag[wDataIn-1:wDataOut-1]) == {(wDataIn - wDataOut + 1){1'b0}} ||
		 (sink_imag[wDataIn-1:wDataOut-1]) == {(wDataIn - wDataOut + 1){1'b1}} )
		source_imag = sink_imag[wDataOut-1:0];
	else if ( sink_imag[wDataIn-1]==1'b0 )
		source_imag = {1'b0, {(wDataOut-1){1'b1}} };
	else
		source_imag = {1'b1, {(wDataOut-1){1'b0}} };
end

endmodule