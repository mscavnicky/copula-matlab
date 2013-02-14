function [ Y ] = pdf( family, U, alpha )
%ARCHIMPDF Probability density function for multivariate archimedean copula.
%   PDF is computed as described in [1]. Extremal values where at least one
%   margin is set to 1 are also computed according to the equation. MATLAB
%   in this case returns 0, R returns NaN.
%
%   References:
%       [1] McNeil, Neslehova - (2009) Multivariate Archimedean Copulas


% Copula dimension is necessary for parameter validation and derivative
d = size(U, 2);
% Get bounds for family and dimension
[ lowerBound, upperBound ] = archim.bounds(family, d);
% Verify parameter against bounds
assert(alpha > lowerBound && alpha < upperBound, 'Copula parameter out of range.');
assert(alpha ~= 0, 'Copula parameter cannot be zero.');

% Evaluate PDF
N = archim.gendiff( family, d, sum(archim.inv( family, U, alpha ), 2), alpha );
D = prod( archim.diff( family, archim.inv( family, U, alpha ), alpha ), 2 );
Y = N ./ D;

end
