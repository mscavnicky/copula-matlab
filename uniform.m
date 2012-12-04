function [ U ] = uniform( X )
%UNIFORM Converts matrix to uniform variates by columns.
%   Based on empirical CDF function described in [1]. We use n+1 for
%   division to keep empirical CDF lower than 1. 
%
%   Function ISMEMBC2 returns last position of element in a sorted array.
%   In our case it also gives us number of elements less and equal to
%   input.
%
%   References:
%       [1] Berg, D. Bakken, H. (2006) Copula Goodness-of-fit Tests: A
%       Comparative Study

[m, n] = size(X);
U = zeros(m, n);

for i=1:n
    S = sort(X(:,i));
    for j=1:m
        U(j, i) = ismembc2(X(j,i), S) / (m + 1);
    end
end

end

