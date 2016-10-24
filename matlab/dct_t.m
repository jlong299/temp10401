function [ y ] = dct_t( x )
%DCT_T Summary of this function goes here
%   Detailed explanation goes here
N = length(x);
y = zeros(1,N);
w = sqrt(2/N)*ones(1,N);
w(1) = 1/sqrt(N);
for k = 1:N
    for i = 1:N
        y(k) = y(k)+x(i)*cos(pi/N*(k-1)*(i-1+0.5));
    end
    y(k) = y(k)*w(k);
end

end

