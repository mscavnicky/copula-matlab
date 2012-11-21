function [ U ] = uniform( X, dim )
%UNIFORM Converts matrix to uniform variates in a specified dimension.
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

if nargin < 2
    dim = 1;
end

[m, n] = size(X);
U = zeros(m, n);

if dim == 1 % uniform cols
    for i=1:n % for each column
        S = sort(X(:,i));
        for j=1:m
            U(j, i) = ismembc2(X(j,i), S) / (m + 1);
        end
    end     
elseif dim == 2 % uniform rows
    for i=1:m % for each row
        S = sort(X(i,:));
        for j=1:n
            U(i, j) = ismembc2(X(i,j), S) / (n + 1);
        end
    end    
else
    error 'Incorrect dimension.'
end

end

