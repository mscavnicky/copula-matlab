function [ Y ] = archimcdf( family, U, alpha )
%ARCHIMCDF CDF of multivariate Archimedean copulas.
%   Checks for parameter bounds using archimbounds function.
%   In Nelsen Clayton copula is defined using max function. We assume it is
%   needed only when negative alpha is allowed.
%   Supports Clayton, Gumbel and Frank copulas.

% Copula dimension is necessary for parameter validation
d = size(U, 2);
% Get bounds for family and dimension
[ lowerBound, upperBound ] = archimbounds(family, d);
% Verify parameter against bounds
assert(alpha > lowerBound && alpha < upperBound, 'Copula parameter out of range.');

% Compute CDF according to definition
Y = archimgen(family, sum(archiminv(family, U, alpha), 2), alpha);

end




