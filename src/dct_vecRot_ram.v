//-----------------------------------------------------------------
// Module Name:        	dct_vecRot_ram.v
// Project:             CE RTL
// Description:         
// Author:				Long Jiang
//------------------------------------------------------------------
//  Version 0.1
//  Description :  First version 
//  2016-10-24
//  ----------------------------------------------------------------
//  Detail :  (Matlab Code)
//
//  w = sqrt(2/N)*ones(1,N);
//  w(1) = 1/sqrt(N);
//  D1(1) = w(1)*F(1);
//    for k = 2:N
//        D1(k) = 1/2*( exp(-1j*pi*(k-1)/(2*N))* F(k) + exp(1j*pi*(k-1)/(2*N))* F(N+2-k));
//        D1(k) = w(k)*D1(k);
//    end
//  --------------------------------------------------------------------------------------------------
//  ST ---> | RAM0: 1 ~ N/2 | --> F(k)   : source_real+j*source_imag
//      |
//      --> | RAM1: N/2 ~ N | --> F(N+2-k) : source_real_rev+j*source_imag_rev
//  ---------------------------------------------------------------------------- 
//  Note :  (1) N = fftpts_in : The number of FFT points is power of 2
//          (2) Source_valid length is ( N/2 + 1 ) 
//                Expected output : 
//                F(1),  F(2), ...  F(N/2),   F(N/2+1)
//                F(1),  F(N), ...  F(N/2+2), F(N/2+1)
//                Actual output :
//                F(1),        F(2), ...  F(N/2),   Don't_care
//                Don't_care,  F(N), ...  F(N/2+2), F(N/2+1)
// 


module dct_vecRot_ram #(parameter  
		wDataIn = 16,  
		wDataOut =16  
	)
	(
	// left side
	input 					rst_n_sync,  // clk synchronous reset active low
	input 					clk,    

	input wire        sink_valid, // sink.sink_valid
	output reg       sink_ready, //       .sink_ready
	input wire [1:0]  sink_error, //       .sink_error
	input wire        sink_sop,   //       .sink_sop
	input wire        sink_eop,   //       .sink_eop
	input wire [wDataIn-1:0] sink_real,  //       .sink_real
	input wire [wDataIn-1:0] sink_imag,  //       .sink_imag

	input wire [11:0] fftpts_in,    //       .fftpts_in

	//right side
	output reg         source_valid, // source.source_valid
	input  wire        source_ready, //       .source_ready
	output wire [1:0]  source_error, //       .source_error
	output reg        source_sop,   //       .source_sop
	output reg        source_eop,   //       .source_eop
	output reg [wDataOut-1:0] source_real,  //       .source_real
	output reg [wDataOut-1:0] source_imag,  //       .source_imag
	output reg [wDataOut-1:0] source_real_rev,  //       .source_real
	output reg [wDataOut-1:0] source_imag_rev,  //       .source_imag
	output wire [11:0] fftpts_out    //       .fftpts_out
	);

wire [11:0] 	fftpts_divd2;
reg 	wren0, wren1;
reg	 [9:0]	wraddress0, rdaddress0, wraddress1, rdaddress1;	//constant width
wire [2*wDataOut-1:0]  	q0, q1;
reg [1:0] 	fsm;
wire [2*wDataIn-1:0] 	data;
reg [11:0] 		cnt_sink_valid;
reg 	source_eop_pre;

assign 	source_error = 2'b00;
assign 	fftpts_divd2 = {1'b0,fftpts_in[11:1]};
assign 	data = {sink_real,sink_imag};


//--------------  2 RAMs -----------------
RAM_dct_vecRot u0 (
	.data      (data),      //  ram_input.datain
	.wraddress (wraddress0), //           .wraddress
	.rdaddress (rdaddress0), //           .rdaddress
	.wren      (wren0),      //           .wren
	.clock     (clk),     //           .clock
	.q         (q0)          // ram_output.dataout
); //constant width

RAM_dct_vecRot u1 (
	.data      (data),      //  ram_input.datain
	.wraddress (wraddress1), //           .wraddress
	.rdaddress (rdaddress1), //           .rdaddress
	.wren      (wren1),      //           .wren
	.clock     (clk),     //           .clock
	.q         (q1)          // ram_output.dataout
); //constant width

// ----------------  FSM -------------------------
always@(posedge clk)
begin
if (!rst_n_sync)
begin
	fsm <= 0;
	sink_ready <= 1'b0;
end
else
begin
	case (fsm)
	2'd0: // s0, s_wait
	begin
		if (sink_sop)
			fsm <= 2'd1;
		else
			fsm <= 2'd0;
		sink_ready <= 1'b1;
	end
	2'd1: // s1, s_writeRAM
	begin
		if (sink_eop)
			fsm <= 2'd2;
		else
			fsm <= 2'd1;
		sink_ready <= 1'b1;
	end
	2'd2: // s2, wait for source_ready
	begin
		if (source_ready)
			fsm <= 2'd3;
		else
			fsm <= 2'd2;
		sink_ready <= 1'b0;
	end
	2'd3: //s3, s_readRAM
	begin
		if (source_eop_pre) 
			fsm <= 2'd0;
		else
			fsm <= 2'd3;
		sink_ready <= 1'b0;
	end
	default:
	begin
		fsm <= 0;
		sink_ready <= 1'b0;
	end
	endcase
end
end

//-----------------   Write RAM ----------------------
always@(posedge clk)
begin
if (!rst_n_sync)
	cnt_sink_valid <= 0;
else
	if (fsm==2'd0 || fsm==2'd1)
		cnt_sink_valid <= (sink_valid) ? cnt_sink_valid+1'd1 : cnt_sink_valid;
	else
		cnt_sink_valid <= 0;
end

always@(*)
begin
	wren0 = (cnt_sink_valid < fftpts_divd2) ? sink_valid : 1'b0;
	wren1 = (cnt_sink_valid >= fftpts_divd2) ? sink_valid : 1'b0;
end

always@(*)
begin
	wraddress0 = (cnt_sink_valid < fftpts_divd2) ? cnt_sink_valid : 0;
	wraddress1 = (cnt_sink_valid >= fftpts_divd2) ? (cnt_sink_valid - fftpts_divd2) : 0;
end

//-----------------  Read RAM ------------------------
//  Expected output : 
//  F(1),  F(2), ...  F(N/2),   F(N/2+1)
//  F(1),  F(N), ...  F(N/2+2), F(N/2+1)
//  Actual output :
//  F(1),        F(2), ...  F(N/2),   Don't_care
//  Don't_care,  F(N), ...  F(N/2+2), F(N/2+1)
//----------------------------------------------------

always@(posedge clk)
begin
	if (!rst_n_sync)
	begin
		rdaddress0 <= 0;
		rdaddress1 <= 0;
		source_sop <= 0;
		source_eop <= 0;
		source_valid <= 0;
		source_eop_pre <= 0;
	end
	else
	begin
		if (fsm==2'd3)
		begin
			rdaddress0 <= rdaddress0 + 1'd1; 
			rdaddress1 <= rdaddress1 - 1'd1;
		end
		else
		begin
			rdaddress0 <= 0;
			rdaddress1 <= fftpts_divd2;
		end

		if (fsm==2'd3)
		begin
			source_eop_pre <= (rdaddress0==(fftpts_divd2-1'd1))? 1'b1 : 1'b0;
			source_sop <= (rdaddress0==1'd0)? 1'b1 : 1'b0;
		end
		else 
		begin
			source_sop <= 0;
			source_eop_pre <= 0;
		end
		source_eop <= source_eop_pre;
		source_valid <= (fsm==2'd3);
	end
end

always@(*)
begin
	source_real = q0[2*wDataOut-1:wDataOut];
	source_imag = q0[wDataOut-1:0];
	source_real_rev = q1[2*wDataOut-1:wDataOut];
	source_imag_rev = q1[wDataOut-1:0];
end

endmodule