complex_sig = 1;

x_real=round((2*rand(1,2048)-1)*8192);
x_imag=round((2*rand(1,2048)-1)*8192);
if complex_sig == 1
x = x_real + 1j*x_imag;
end
%disp(x); 

N=length(x);
D0 = dct_t(x);

srcf = fopen('../sim/mentor/dct_src.dat','w');
for k = 1 :N
    fprintf(srcf , '%d %d\n' , real(x(k)), imag(x(k)));
end
fclose(srcf);

%disp(D0);
%disp(idct_t(D0));

%% Calc dct from fft
x_reod = zeros(1,N);
x_reod(1:N/2) = x(1:2:N-1);
x_reod(N/2+1:N) = x(N:-2:2);


    F = fft(x_reod);
    %disp(F);

w = sqrt(2/N)*ones(1,N);
w(1) = 1/sqrt(N);

if complex_sig == 0
    for k = 1:N
        D1(k) = exp(-1j*pi*(k-1)/(2*N))* F(k);
    end
    % disp(real(D1));
else
    D1(1) = w(1)*F(1);
    for k = 2:N
        D1(k) = 1/2*( exp(-1j*pi*(k-1)/(2*N))* F(k) + exp(1j*pi*(k-1)/(2*N))* F(N+2-k));
        D1(k) = w(k)*D1(k);
    end
   % disp(D1);
end

%% Calc idct from dct result and ifft

F1 = zeros(1,N);
F1(1) = 1/w(1) * D1(1);
for k=2:N
    F1(k) = 1/w(k) * (D1(k)-1j*D1(N+2-k))/exp(-1j*pi*(k-1)/2/N);
end
%disp(F1);

x1_reod = ifft(F1);

x1 = zeros(1,N);
x1(1:2:N-1) = x1_reod(1:N/2);
x1(2:2:N) = x1_reod(N:-1:N/2+1);
%disp(x1);

%% Compare with FPGA simulation result
outf = fopen('../sim/mentor/dct_result.dat','r');
    FPGA_out = fscanf(outf , '%d %d', [2 Inf]);
fclose(outf);

max(abs(FPGA_out(1,:) - real(D1)))   