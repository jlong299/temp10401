//-----------------------------------------------------------------
// Module Name:        	dct_vecRot_coeff.v
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
//  Output : 
//      source_cos :  
//          65536                               k=1
//          65536*sqrt(2)*(cos(pi*(k-1)/2/N)    k=2:N
//      source_sin :  
//          0                                   k=1
//          65536*sqrt(2)*(sin(pi*(k-1)/2/N)    k=2:N


module dct_vecRot_coeff #(parameter  
		wDataOut =18  
	)
	(
	// left side
	input wire		rst_n_sync,  // clk synchronous reset active low
	input wire		clk,    

	output wire		sink_valid, 	
	input wire [11:0] 		fftpts_in, 		
	// right side
	// 1 clks delay with sink_valid
	output wire [wDataOut-1:0] 	source_cos,
	output wire [wDataOut-1:0] 	source_sin
	);


	reg [10:0] address_cos, address_sin;
	reg [9:0]  step;

	ROM_cos_dct_vecRot ROM_cos_dct_vecRot_inst (
		.address (address_cos), //  rom_input.address
		.clock   (clk),   //           .clk
		.q       (source_cos)        // rom_output.dataout
	);
	ROM_sin_dct_vecRot ROM_sin_dct_vecRot_inst (
		.address (address_sin), //  rom_input.address
		.clock   (clk),   //           .clk
		.q       (source_sin)        // rom_output.dataout
	);

	always@(posedge clk)
	begin
		if (!rst_n_sync)
		begin
			address_cos <= 0;
			address_sin <= 0;
			step <= 0;
		end
		else
		begin
			if (sink_valid)
			begin
				address_cos <= address_cos + step;
				address_sin <= address_sin + step;
			end
			else
			begin
				address_cos <= 0;
				address_sin <= 0;
			end

			case (fftpts_in)
			12'd2048:
			begin
				step <= 10'd1;
			end
			12'd1024:
			begin
				step <= 10'd2;
			end
			12'd512:
			begin
				step <= 10'd4;
			end
			12'd256:
			begin
				step <= 10'd8;
			end
			12'd128:
			begin
				step <= 10'd16;
			end
			12'd64:
			begin
				step <= 10'd32;
			end
			12'd32:
			begin
				step <= 10'd64;
			end
			default:
			begin
				step <= 10'd1;
			end
			endcase
		end
	end


endmodule