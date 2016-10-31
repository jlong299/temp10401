//-----------------------------------------------------------------
// Module Name:        	dct_vecRot.v
// Project:             CE RTL
// Description:         The last part of DCT, vector rotation and twiddle after FFT.
// Author:				Long Jiang
//------------------------------------------------------------------
//  Version 0.1
//  Description :  First version 
//  2016-10-24
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
//  ST_sink --> |                 |     | dct_vecRot_coeff |-->  |                    | --> ST_source_t1
//              | dct_vecRot_ram  |     -------------------      | dct_vecRot_twiddle |
//              |                 |                              |                    |
//              |                 | ---------ST_source_t0----->  |                    |
//  --------------------------------------------------------------------------------------------------
//
//  --->  | dct_vecRot_scaling | --> ST_source
//
//  ---------------------------------------------------------------------------- 
//  Note :  (1) fftpts_in : The number of FFT points is power of 2
// 


module dct_vecRot #(parameter  
		wDataIn = 28,  
		wDataOut =16  
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



localparam 	wDataOut_t0 = 28;
localparam 	wDataOut_t1 = 22;
localparam 	wCoeff = 18;

wire        source_valid_t0; // source.source_valid
wire        source_ready_t0; //       .source_ready
wire [1:0]  source_error_t0; //       .source_error
wire        source_sop_t0;   //       .source_sop
wire        source_eop_t0;   //       .source_eop
wire [wDataOut_t0-1:0] source_real_t0;  //       .source_real
wire [wDataOut_t0-1:0] source_imag_t0;  //       .source_imag
wire [wDataOut_t0-1:0] source_real_rev_t0;  //       .source_real
wire [wDataOut_t0-1:0] source_imag_rev_t0;  //       .source_imag

wire        source_valid_t1; // source.source_valid
wire        source_ready_t1; //       .source_ready
wire [1:0]  source_error_t1; //       .source_error
wire        source_sop_t1;   //       .source_sop
wire        source_eop_t1;   //       .source_eop
wire [wDataOut_t1-1:0] source_real_t1;  //       .source_real
wire [wDataOut_t1-1:0] source_imag_t1;  //       .source_imag

wire [wCoeff-1:0] 	coeff_cos, coeff_sin;
wire 				coeff_valid;


assign fftpts_out = fftpts_in;
assign source_error = 2'b00;

dct_vecRot_ram #(
	.wDataIn (wDataIn),  
	.wDataOutbla (28)  
	)
dct_vecRot_ram_inst (
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
	.source_real_rev 	(source_real_rev_t0 ),  
	.source_imag_rev 	(source_imag_rev_t0 ),   
	.fftpts_out 	( )   

	);

dct_vecRot_twiddle #(
	.wDataIn (wDataOut_t0),  
	.wDataOut (wDataOut_t1),
	.wCoeff (wCoeff)  
	)
dct_vecRot_twiddle_inst (
	// left side
	.rst_n_sync 	(rst_n_sync),
	.clk 			(clk),

	.sink_valid 	(source_valid_t0),
	.sink_ready 	(source_ready_t0),
	.sink_error 	(source_error_t0),
	.sink_sop 		(source_sop_t0 ),    
	.sink_eop 		(source_eop_t0 ),    
	.sink_real 		(source_real_t0 ), 
	.sink_imag 		(source_imag_t0 ),
	.sink_real_rev 	(source_real_rev_t0 ),  
	.sink_imag_rev 	(source_imag_rev_t0 ),  

	.fftpts_in 		(fftpts_in),

	// 1 clks delay with sink_valid
	.sink_cos 		(coeff_cos ),  
	.sink_sin 		(coeff_sin ), 

	// right side
	.source_valid 	(source_valid_t1), 
	.source_ready 	(source_ready_t1), 
	.source_error 	(source_error_t1), 
	.source_sop 	(source_sop_t1 ),   
	.source_eop 	(source_eop_t1 ),   
	.source_real 	(source_real_t1 ),  
	.source_imag 	(source_imag_t1 ),  
	.fftpts_out 	( )   

	);

dct_vecRot_coeff #(
	.wDataOut (wCoeff)  
	)
dct_vecRot_coeff_inst (
	// left side
	.rst_n_sync 	(rst_n_sync),
	.clk 			(clk),

	.sink_valid 	(source_valid_t0),

	.fftpts_in 		(fftpts_in),

	// right side
	// 1 clks delay with sink_valid
	.source_cos 	(coeff_cos ),  
	.source_sin 	(coeff_sin )
	);


dct_vecRot_scaling #(
	.wDataIn (wDataOut_t1),  
	.wDataOut (wDataOut)  
	)
dct_vecRot_scaling_inst (
	// left side
	.rst_n_sync 	(rst_n_sync),
	.clk 			(clk),

	.sink_valid 	(source_valid_t1),
	.sink_ready 	(source_ready_t1),
	.sink_error 	(source_error_t1),
	.sink_sop 		(source_sop_t1 ),    
	.sink_eop 		(source_eop_t1 ),    
	.sink_real 		(source_real_t1 ), 
	.sink_imag 		(source_imag_t1 ), 

	.fftpts_in 		(fftpts_in),

	// right side
	.source_valid 	(source_valid), 
	.source_ready 	(source_ready), 
	.source_error 	(source_error), 
	.source_sop 	(source_sop ),   
	.source_eop 	(source_eop ),   
	.source_real 	(source_real ),  
	.source_imag 	(source_imag ),  
	.fftpts_out 	( )   

	);



endmodule