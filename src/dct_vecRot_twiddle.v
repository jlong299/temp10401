//-----------------------------------------------------------------
// Module Name:        	dct_vecRot_twiddle.v
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
//------------------------------------------------------------------
//  Input : 
//      sink_cos :  
//          65536                               k=1
//          65536*sqrt(2)*(cos(pi*(k-1)/2/N)    k=2:N
//      sink_sin :  
//          0                                   k=1
//          65536*sqrt(2)*(sin(pi*(k-1)/2/N)    k=2:N
//  --------------------------------------------------------------------------------------------------
//  Twiddle :
//                           +    *sink_cos      +           /2/65536/sqrt(N/2)
//  R(F(k))     ---------------- -----------> ------- Real ------------------>
//  sink_real    \          + /                  + /       
//                \          /                    /      
//                 \        /                    /     
//                  \      /                    /    
//                   \    /                    /   
//                    \  /  +     *sink_sin   /        
//  I(F(k))     ---------------- ----------->   
//  sink_imag   \     / \   - /  
//               \   /   \   /  
//                \ /     \ /   
//                 / \     / \  
//                /   \   /   \ -
//               /     \ /   + \  *sink_sin       +          /2/65536/sqrt(N/2)
//  R(F(N+2-k)) ---------------- -----------> ------- Imag ------------------> 
//  sink_real_rev     /  \                       + /            
//                   /    \                       /           
//                  /      \                     /           
//                 /        \                   /          
//                /          \ +               /           
//               /          + \   *sink_cos   /         
//  I(F(N+2-k)) ---------------- ----------->   
//  sink_imag_rev
//  ---------------------------------------------------------------------------- 
//  Note :  (1) N = fftpts_in : The number of FFT points is power of 2


module dct_vecRot_twiddle #(parameter  
		wDataIn =28,
		wDataOut =22,  
		wCoeff =18  
	)
	(
	// left side
	input wire				rst_n_sync,  // clk synchronous reset active low
	input wire				clk,    

	input wire        	sink_valid, // sink.sink_valid
	output reg        	sink_ready, //       .sink_ready
	input wire [1:0]  	sink_error, //       .sink_error
	input wire        	sink_sop,   //       .sink_sop
	input wire        	sink_eop,   //       .sink_eop
	input wire signed [wDataIn-1:0] sink_real,  //       .sink_real
	input wire signed [wDataIn-1:0] sink_imag,  //       .sink_imag
	input wire signed [wDataIn-1:0] sink_real_rev,  //       .sink_real
	input wire signed [wDataIn-1:0] sink_imag_rev,  //       .sink_imag
	input wire [11:0] fftpts_in,    //       .fftpts_in

	// 1 clks delay with sink_valid
	input wire signed [wCoeff-1:0] 	sink_cos,
	input wire signed [wCoeff-1:0] 	sink_sin,

	//right side
	output reg         	source_valid, // source.source_valid
	input  wire        	source_ready, //       .source_ready
	output wire [1:0]  	source_error, //       .source_error
	output reg         	source_sop,   //       .source_sop
	output reg         	source_eop,   //       .source_eop
	output reg [wDataOut-1:0] source_real,  //       .source_real
	output reg [wDataOut-1:0] source_imag,  //       .source_imag
	output wire [11:0] fftpts_out    //       .fftpts_out
	);

assign 	source_error = 2'b00;
assign  fftpts_out = fftpts_in;
assign 	sink_ready = source_ready;

reg signed [wDataIn:0] 	p1 [3:0];
reg signed [wDataIn+wCoeff:0] 	p2 [3:0];
reg signed [wDataIn+wCoeff+1:0] 	p3 [1:0];

reg [2:0] 	valid_r, sop_r, eop_r;

// ---------------- Pipeline 1 -------------------------
always@(posedge clk)
begin
	if (!rst_n_sync)
	begin
		p1[0] <= 0;
		p1[1] <= 0;
		p1[2] <= 0;
		p1[3] <= 0;
	end
	else
	begin
		p1[0] <= sink_real + sink_real_rev;
		p1[1] <= sink_imag - sink_imag_rev;
		p1[2] <= -sink_real + sink_real_rev;
		p1[3] <= sink_imag + sink_imag_rev;
	end
end

// ---------------- Pipeline 2 -------------------------
always@(posedge clk)
begin
	if (!rst_n_sync)
	begin
		p2[0] <= 0;
		p2[1] <= 0;
		p2[2] <= 0;
		p2[3] <= 0;
	end
	else
	begin
		p2[0] <= p1[0]*sink_cos;
		p2[1] <= p1[1]*sink_sin;
		p2[2] <= p1[2]*sink_sin;
		p2[3] <= p1[3]*sink_cos;
	end
end

// ---------------- Pipeline 3 -------------------------
always@(posedge clk)
begin
	if (!rst_n_sync)
	begin
		p3[0] <= 0;
		p3[1] <= 0;
	end
	else
	begin
		p3[0] <= p2[0]+p2[1];
		p3[1] <= p2[2]+p2[3];
	end
end

// ---------------- Pipeline 4 -------------------------
always@(posedge clk)
begin
	if (!rst_n_sync)
	begin
		source_real <= 0;
		source_imag <= 0;
	end
	else
	begin
		case (fftpts_in)
		12'd2048:
		begin
			source_real <= p3[0][wDataIn+wCoeff-3:22]+p3[0][21]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-3:22]+p3[1][21]; //rounding
		end
		12'd1024:
		begin
			source_real <= p3[0][wDataIn+wCoeff-4:21]+p3[0][20]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-4:21]+p3[1][20]; //rounding
		end
		12'd512:
		begin
			source_real <= p3[0][wDataIn+wCoeff-4:21]+p3[0][20]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-4:21]+p3[1][20]; //rounding
		end
		12'd256:
		begin
			source_real <= p3[0][wDataIn+wCoeff-5:20]+p3[0][19]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-5:20]+p3[1][19]; //rounding
		end
		12'd128:
		begin
			source_real <= p3[0][wDataIn+wCoeff-5:20]+p3[0][19]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-5:20]+p3[1][19]; //rounding
		end
		12'd64:
		begin
			source_real <= p3[0][wDataIn+wCoeff-6:19]+p3[0][18]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-6:19]+p3[1][18]; //rounding
		end
		12'd32:
		begin
			source_real <= p3[0][wDataIn+wCoeff-6:19]+p3[0][18]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-6:19]+p3[1][18]; //rounding
		end
		default:
		begin
			source_real <= p3[0][wDataIn+wCoeff-3:22]+p3[0][21]; //rounding
			source_imag <= p3[1][wDataIn+wCoeff-3:22]+p3[1][21]; //rounding
		end
		endcase
	end
end

// -----------------------------------------------
always@(posedge clk)
begin
	valid_r[0] <= sink_valid;
	sop_r[0] <= sink_sop;
	eop_r[0] <= sink_eop;
	valid_r[1] <= valid_r[0];
	sop_r[1] <= sop_r[0];
	eop_r[1] <= eop_r[0];
	valid_r[2] <= valid_r[1];
	sop_r[2] <= sop_r[1];
	eop_r[2] <= eop_r[1];
	source_valid <= valid_r[2];
	source_sop <= sop_r[2];
	source_eop <= eop_r[2];
end

endmodule