function [ X ] = logrnd( alpha, n )
%LOGRND Generate random vector from log distribution.
%   
%   References:
%       [1] Kemp, Efficient generation of logarithimic pseudo-random
%       distribution, 1981

h = log(1 - alpha);
u1 = rand(n, 1);
u2 = rand(n, 1);
X = floor( 1 + log(u2) ./ log(1 - exp(u1*h)) );

end

