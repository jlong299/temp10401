% Generate coeffs that used in FFT -> DCT  
close all;
N = 2048;

w = sqrt(2/N)*ones(1,N);
w(1) = 1/sqrt(N);

%     D1(1) = w(1)*F(1);
%     for k = 2:N
%         D1(k) = 1/2*( exp(-1j*pi*(k-1)/(2*N))* F(k) + exp(1j*pi*(k-1)/(2*N))* F(N+2-k));
%         D1(k) = w(k)*D1(k);
%     end

coeff_numerator = zeros(1,N);
coeff_numerator(1) = 1/sqrt(2);
for k = 2 : N
    coeff_numerator(k) = (cos(pi*(k-1)/2/N) + 1j*sin(pi*(k-1)/2/N));
end

% outf = fopen('../src/RAM_FIFO/coeff_dct_fft_hex.dat','w');
% for k = 1 : N
%     fprintf(outf , '%d\n' , round(real(65536*coeff_numerator(k))));
%     fprintf(outf , '%d\n' , round(imag(65536*coeff_numerator(k))));
% end
% fclose(outf);

%% Gen mif file
outf = fopen('../src/RAM_FIFO/coeff_cos_dct_vecRot.mif','w');
width = 18;
depth = 2048;
fprintf(outf,'WIDTH=%d;\nDEPTH=%d;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=DEC;\n\nCONTENT BEGIN\n',width,depth);
for k=1:N
    fprintf(outf,'%d:%d;\n',k-1,round(real(65536*coeff_numerator(k))));
end
fprintf(outf,'END;\n');
fclose(outf);

outf = fopen('../src/RAM_FIFO/coeff_sin_dct_vecRot.mif','w');
fprintf(outf,'WIDTH=%d;\nDEPTH=%d;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=DEC;\n\nCONTENT BEGIN\n',width,depth);
for k=1:N
    fprintf(outf,'%d:%d;\n',k-1,round(imag(65536*coeff_numerator(k))));
end
fprintf(outf,'END;\n');
fclose(outf);


