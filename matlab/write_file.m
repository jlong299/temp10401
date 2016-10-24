close all;
N = 2048;
y =(1:N)+ 1j*(1:N);
x = ifft(y);

xr = round(x);

scal_factor = 8;
xr_scal = xr*scal_factor;
max(abs(real(xr)))
max(abs(imag(xr)))

yr = fft(xr);
yrr = round(yr);
plot(real(yrr));
max(abs(real(yrr)))
max(abs(imag(yrr)))

outf = fopen('../sim/mentor/fft_src.dat','w');
for k = 1 : length(xr)
    fprintf(outf , '%d %d\n' , real(xr_scal(k)), imag(xr_scal(k)));
end
fclose(outf);

y_rslt_R = zeros(1,N);
y_rslt_I = zeros(1,N);
rd_f = fopen('../sim/mentor/fft_result.dat','r');
ytest = fscanf(rd_f , '%d %d', [2 Inf]);

M = N/128;
for k=1:M
    dat0 = yrr((k-1)*128+1 : k*128);
    dat1 = ytest(:,(k-1)*128+1 : k*128)/scal_factor;
    max_diff = 0;
    for m=1:128
        max_diff = max(abs( dat1(1,m)-real(dat0(m)) ) , max_diff);
        max_diff = max(abs( dat1(2,m)-imag(dat0(m)) ) , max_diff);
    end
    max_diff
end
    
    
fclose(rd_f);


