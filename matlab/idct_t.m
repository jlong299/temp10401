function [ x ] = idct_t( y )
%DCT_T Summary of this function goes here
%   Detailed explanation goes here
N = length(y);
x = zeros(1,N);
w = sqrt(2/N)*ones(1,N);
w(1) = 1/sqrt(N);
for n = 1:N
    for i = 1:N
        x(n) = x(n)+w(i)*y(i)*cos(pi/(2*N)*(2*n-1)*(i-1));
    end
end

end

