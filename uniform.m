function [ U ] = uniform( X, dim )
%UNIFORM Converts matrix to uniform variates in specified dimension.
%   Based on empirical CDF function described in Berg, Bakken (2006).
%   Function ISMEMBC2 is uncomented an returns last position of element
%   array.

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

