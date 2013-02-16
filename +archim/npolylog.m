function [ Y ] = npolylog( n, X )
%NPOLYLOG Polylogratihm function for n < 0.
%
%   References:
%       [1] http://en.wikipedia.org/wiki/Polylogarithm#Particular_values

assert(n < 0, 'Polylogarithm only implemented for negative numbers.');

n = abs(n);
W = X ./ (1 - X);

Y = zeros(size(X));
for i=0:n
    Y = Y + factorial(i) * (W .^ (i+1)) * archim.stirling2(n+1, i+1);
end

end

