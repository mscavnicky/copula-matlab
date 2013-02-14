function [ Y ] = npolylog( n, X )
%NPOLYLOG Negative polylogarithm function

W = X ./ (1 - X);

Y = zeros(size(X));
for i=0:n
    Y = Y + factorial(i) * (W .^ (i+1)) * archim.stirling2(n+1, i+1);
end

end

