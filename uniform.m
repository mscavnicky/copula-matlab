function [ f ] = uniform( x )
%UNIFORM Converts sample vector into uniform variates.
%
% Works with both row and column vectors. Does not work with matrices.
% Based on empirical CDF function described in Berg, Bakken (2006).

[m, n] = size(x);

if (m == 1)
    f = zeros(1, n);
    for i=1:n
        f(1, i) = sum(x(:) <= x(i)) / (n + 1);
    end
elseif (n == 1)
    f = zeros(m, 1);
    for i=1:m
        f(i, 1) = sum(x(:) <= x(i)) / (m + 1);
    end    
else
    error 'Not a vector.'
end
   
end

