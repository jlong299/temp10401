//-----------------------------------------------------------------
// Module Name:        	dct_top.v
// Project:             CE RTL
// Description:         DCT top level.
// Author:				Long Jiang
//------------------------------------------------------------------
//  Version 0.1
//  Description :  First version 
//  2016-10-31
//  ----------------------------------------------------------------
//  Detail :  (Matlab Code)
//
//  %% Calc dct from fft
//  x_reod = zeros(1,N);
//  x_reod(1:N/2) = x(1:2:N-1);
//  x_reod(N/2+1:N) = x(N:-2:2);
// 
//      F = fft(x_reod);
//      %disp(F);
// 
//  w = sqrt(2/N)*ones(1,N);
//  w(1) = 1/sqrt(N);
// 
//  if complex_sig == 0
//      for k = 1:N
//          D1(k) = exp(-1j*pi*(k-1)/(2*N))* F(k);
//      end
//      % disp(real(D1));
//  else
//      D1(1) = w(1)*F(1);
//      for k = 2:N
//          D1(k) = 1/2*( exp(-1j*pi*(k-1)/(2*N))* F(k) + exp(1j*pi*(k-1)/(2*N))* F(N+2-k));
//          D1(k) = w(k)*D1(k);
//      end
//     % disp(D1);
//  end
//  --------------------------------------------------------------------------------------------------
//  Top structure :
//
//    --> dct_preFFT_reod --> FFT --> dct_vecRot -->
//
//  ---------------------------------------------------------------------------- 
//  Note :  (1) fftpts_in : The number of FFT points is power of 2
// 


module dct_top #(parameter  
		wDataIn = 16,  
		wDataOut = 16  
	)
	(
	// left side
	input wire				rst_n_sync,  // clk synchronous reset active low
	input wire				clk,    

	input wire        sink_valid, // sink.sink_valid
	output wire       sink_ready, //       .sink_ready
	input wire [1:0]  sink_error, //       .sink_error
	input wire        sink_sop,   //       .sink_sop
	input wire        sink_eop,   //       .sink_eop
	input wire [wDataIn-1:0] sink_real,  //       .sink_real
	input wire [wDataIn-1:0] sink_imag,  //       .sink_imag

	input wire [11:0] fftpts_in,    //       .fftpts_in

	//right side
	output wire        source_valid, // source.source_valid
	input  wire        source_ready, //       .source_ready
	output wire [1:0]  source_error, //       .source_error
	output wire        source_sop,   //       .source_sop
	output wire        source_eop,   //       .source_eop
	output wire [wDataOut-1:0] source_real,  //       .source_real
	output wire [wDataOut-1:0] source_imag,  //       .source_imag
	output wire [11:0] fftpts_out    //       .fftpts_out
	);

localparam 	wData_t1 = 28;
wire        source_valid_t0; // source.source_valid
wire        source_ready_t0; //       .source_ready
wire [1:0]  source_error_t0; //       .source_error
wire        source_sop_t0;   //       .source_sop
wire        source_eop_t0;   //       .source_eop
wire [wDataIn-1:0] source_real_t0;  //       .source_real
wire [wDataIn-1:0] source_imag_t0;  //       .source_imag

wire        source_valid_t1; // source.source_valid
wire        source_ready_t1; //       .source_ready
wire [1:0]  source_error_t1; //       .source_error
wire        source_sop_t1;   //       .source_sop
wire        source_eop_t1;   //       .source_eop
wire [wData_t1-1:0] source_real_t1;  //       .source_real
wire [wData_t1-1:0] source_imag_t1;  //       .source_imag


dct_preFFT_reod #(
	.wDataInOut (wDataIn) 
	)
dct_preFFT_reod_inst (
	// left side
	.rst_n_sync 	(rst_n_sync),
	.clk 			(clk),

	.sink_valid 	(sink_valid), 
	.sink_ready 	(sink_ready), 
	.sink_error 	(sink_error), 
	.sink_sop 		(sink_sop 	),   
	.sink_eop 		(sink_eop 	),   
	.sink_real 		(sink_real ),  
	.sink_imag 		(sink_imag ),  

	.fftpts_in 		(fftpts_in),

	// right side
	.source_valid 	(source_valid_t0), 
	.source_ready 	(source_ready_t0), 
	.source_error 	(source_error_t0), 
	.source_sop 	(source_sop_t0 ),   
	.source_eop 	(source_eop_t0 ),   
	.source_real 	(source_real_t0 ),  
	.source_imag 	(source_imag_t0 ),
	.fftpts_out 	( )   

	);

dct_fft u0 (
	.clk          (clk),          //    clk.clk
	.reset_n      (rst_n_sync),      //    rst.reset_n
	// .sink_valid   (sink_valid),   //   sink.sink_valid
	// .sink_ready   (sink_ready),   //       .sink_ready
	// .sink_error   (sink_error),   //       .sink_error
	// .sink_sop     (sink_sop),     //       .sink_sop
	// .sink_eop     (sink_eop),     //       .sink_eop
	// .sink_real    (sink_real),    //       .sink_real
	// .sink_imag    (sink_imag),    //       .sink_imag
	.sink_valid   (source_valid_t0),   //   sink.sink_valid
	.sink_ready   (source_ready_t0),   //       .sink_ready
	.sink_error   (source_error_t0),   //       .sink_error
	.sink_sop     (source_sop_t0),     //       .sink_sop
	.sink_eop     (source_eop_t0),     //       .sink_eop
	.sink_real    (source_real_t0),    //       .sink_real
	.sink_imag    (source_imag_t0),    //       .sink_imag
	.fftpts_in    (fftpts_in),    //       .fftpts_in
	.inverse      (1'b0),      //       .inverse
	.source_valid (source_valid_t1), // source.source_valid
	.source_ready (source_ready_t1), //       .source_ready
	.source_error (source_error_t1), //       .source_error
	.source_sop   (source_sop_t1),   //       .source_sop
	.source_eop   (source_eop_t1),   //       .source_eop
	.source_real  (source_real_t1),  //       .source_real
	.source_imag  (source_imag_t1),  //       .source_imag
	.fftpts_out   ()    //       .fftpts_out
);

dct_vecRot #(  
	.wDataIn (wData_t1),  
	.wDataOut (wDataOut)  
)
dct_vecRot_inst
(
	// left side
	.rst_n_sync (rst_n_sync),  // clk synchronous reset active low
	.clk (clk),    
	
	.sink_valid (source_valid_t1), 
	.sink_ready (source_ready_t1), 
	.sink_error (source_error_t1), 
	.sink_sop 	(source_sop_t1  ),   
	.sink_eop 	(source_eop_t1  ),   
	.sink_real 	(source_real_t1 ),  
	.sink_imag 	(source_imag_t1 ),  
	
	.fftpts_in (fftpts_in),    
	
	//right side
	.source_valid	(source_valid), 
	.source_ready	(source_ready), 
	.source_error	(source_error), 
	.source_sop		(source_sop),   
	.source_eop		(source_eop),   
	.source_real	(source_real),  
	.source_imag	(source_imag),  
	.fftpts_out()
);



endmodule