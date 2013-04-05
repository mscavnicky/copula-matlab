function [ Y ] = empiricalCdf( F, X )
%EMPIRICALCDF Empirical cdf function for input X given the empirical values
%F. Returned values are in the interval (0,1).
%
%   References:
%       [1] Berg, D. Bakken, H. (2006) Copula Goodness-of-fit Tests: A
%       Comparative Study

n = size(F, 1);
Y = zeros(size(X));
for i=1:size(X, 1)
    Y(i, :) = sum(F <= repmat(X(i, :), n, 1), 1) / (n + 1);
end

% Values must be strictly between 0 and 1
Y(Y <= 0) = 1e-6;
Y(Y >= 1) = 1 - 1e-6;

end

