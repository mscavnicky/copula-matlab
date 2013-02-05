function [ T ] = snc( E )
% SNC Goodness-of-fit statistics
%
%   References:
%       [1] Genest (2009)
T = sum((copula.emp(E) - prod(E, 2)) .^ 2);
end
