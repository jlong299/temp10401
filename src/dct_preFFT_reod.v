//-----------------------------------------------------------------
// Module Name:        	dct_preFFT_reod.v
// Project:             CE RTL
// Description:         Signal reorder serves as the first part of DCT which is right before FFT.
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
//                      |          |
//  x0,x1,...,x2047 --> |  reoder  | --> x0,x2,...,x2046,x2047,x2045,...,x3,x1
//                      |          |
//  ---------------------------------------------------------------------------- 
//  Note :  (1) fftpts_in : The number of FFT points is power of 2
// 


module dct_preFFT_reod #(parameter  
		wDataInOut = 16
	)
	(
	// left side
	input 		rst_n_sync,  // clk synchronous reset active low
	input		clk,
	input		sink_valid,
	output	reg	sink_ready,
	input	[1:0]	sink_error,
	input		sink_sop,
	input		sink_eop,
	input	[wDataInOut-1:0]	sink_real,
	input	[wDataInOut-1:0]	sink_imag,
	input	[11:0]	fftpts_in,

	// right side
	output reg		source_valid,
	input			source_ready,
	output	[1:0]	source_error,
	output reg		source_sop,
	output reg		source_eop,
	output 	[wDataInOut-1:0]	source_real,
	output 	[wDataInOut-1:0]	source_imag,
	output	[11:0]	fftpts_out
	);

reg [1:0] fsm;
reg [10:0] 	wraddress, rdaddress;
wire wren;
//reg [10:0] cnt_wren;
wire [2*wDataInOut-1:0] 	data, q;
reg  read_latter_half;

assign fftpts_out = fftpts_in;
assign source_error = 2'b00;
assign data = {sink_real, sink_imag};
assign source_real = q[2*wDataInOut-1:wDataInOut];
assign source_imag = q[wDataInOut-1:0];
assign wren = sink_valid;

//--------------  RAM ----------------- 
// depth: 2048  datawidth: 2*wDataInOut  
RAM_dct_preFFT_reod u0 (
	.data      (data),      //  ram_input.datain
	.wraddress (wraddress), //           .wraddress
	.rdaddress (rdaddress), //           .rdaddress
	.wren      (wren),      //           .wren
	.clock     (clk),     //           .clock
	.q         (q)          // ram_output.dataout
); //constant width

//-------------- FSM -----------------
always@(posedge clk)
begin
	if (!rst_n_sync)
		fsm <= 0;
	else
	begin
		case(fsm)
		2'd0:
			fsm <= (sink_sop)? 2'd1 : 2'd0;
		2'd1: //write half data (ready to read)
			fsm <= (wraddress == fftpts_out[11:1])? 2'd2 : 2'd1;
		2'd2:
			fsm <= (source_ready) ? 2'd3 : 2'd2;
		2'd3: // begin to read
			fsm <= (source_eop) ? 2'd0 : 2'd3;
		default:
			fsm <= 0;
		endcase
	end
end

always@(posedge clk)
begin
	if (!rst_n_sync)
		sink_ready <= 0;
	else
	begin
		if (fsm==2'd0)
			sink_ready <= 1'b1;
		else if (sink_eop)
			sink_ready <= 1'b0;
		else if (source_eop)
			sink_ready <= 1'b1;
		else
			sink_ready <= sink_ready;
	end
end
//------------ Write logic ------------
always@(posedge clk)
begin
	if(!rst_n_sync)
		wraddress <= 0;
	else
	begin
		wraddress <= (wren)? wraddress + 1'd1 : 0;
	end
end

//---------- Read logic -----------
always@(posedge clk)
begin
	if(!rst_n_sync)
		rdaddress <= 0;
	else
	begin
		if(fsm==2'd3)
			read_latter_half <= (rdaddress== (fftpts_in-2'd2))? 1'b1 : read_latter_half;
		else
			read_latter_half <= 0;

		if(fsm==2'd3)
		begin
			if(rdaddress== (fftpts_in-2'd2))
				rdaddress <= fftpts_in-1'd1;
			else if (read_latter_half == 1'b0)
				rdaddress <= rdaddress + 2'd2;
			else
				rdaddress <= rdaddress - 2'd2;
		end
		else
			rdaddress <= 0;
	end
end

//---------- Output --------------
always@(posedge clk)
begin
	if(!rst_n_sync)
	begin
		source_valid <= 0;
		source_sop <= 0;
		source_eop <= 0;
	end
	else
	begin
		source_sop <= (fsm==2'd3 && rdaddress==1'd0 && source_eop==1'b0)? 1'b1 : 1'b0;

		source_eop <= (fsm==2'd3 && rdaddress==2'd1)? 1'b1 : 1'b0;

		if(fsm==2'd3 && rdaddress==1'd0 && source_eop==1'b0)
			source_valid <= 1'b1;
		else if (source_eop)
			source_valid <= 1'b0;
		else
			source_valid <= source_valid;

	end
end


endmodule