function [ Y ] = cdf( family, U, alpha )
%ARCHIM.CDF Computes cdf of multivariate Archimedean copulas.
%   Checks for parameter bounds using archim.bounds function.

% Copula dimension is necessary for parameter validation
d = size(U, 2);

% Get bounds for family and dimension
[ lowerBound, upperBound ] = archim.bounds(family, d);
% Verify parameter against bounds
assert(alpha > lowerBound && alpha < upperBound, 'Copula parameter out of range.');
assert(alpha ~= 0, 'Copula parameter cannot be zero.');

% Compute CDF according to definition
I = archim.generatorInverse(family, U, alpha);
Y = archim.generator(family, sum(I, 2), alpha);

end