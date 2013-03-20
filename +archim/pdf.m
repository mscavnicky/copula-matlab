function [ Y ] = pdf( family, U, alpha )
%ARCHIM.PDF Probability density function for multivariate archimedean
%copula.
%   PDF is computed as described in [1]. Extremal values where at least one
%   margin is set to 1 are also computed according to the equation. MATLAB
%   in this case returns 0, R returns NaN.
%
%   References:
%       [1] McNeil, Neslehova - (2009) Multivariate Archimedean Copulas


% Copula dimension is necessary for parameter validation and derivative
d = size(U, 2);

% For 2-dimensional case use existing MATLAB implementation
if d == 2
   Y = copulapdf(family, U, alpha);
   return;
end

% Get bounds for family and dimension
[ lowerBound, upperBound ] = archim.bounds(family, d);
% Verify parameter against bounds
assert(alpha > lowerBound && alpha < upperBound, 'Copula parameter out of range.');
assert(alpha ~= 0, 'Copula parameter cannot be zero.');

% Evaluate PDF
N = archim.gdiff( family, sum(archim.inv( family, U, alpha ), 2), alpha, d );
D = prod( gdiff1( family, archim.inv( family, U, alpha ), alpha ), 2 );
Y = N ./ D;

end

function [ Y ] = gdiff1( family, X, p )
%ARCHIM.DIFF First derivative of the archimedean copula generator.
%   For analytical derivation see:
%       Clayton http://www.wolframalpha.com/input/?i=%281%2Bx%29%5E%28-1%2Fp%29
%       Gumbel http://www.wolframalpha.com/input/?i=exp%28-x%5E%281%2Fp%29%29
%       Frank http://www.wolframalpha.com/input/?i=%28-1%2Fp%29*log%281+-+%281+-+exp%28-p%29%29*exp%28-x%29%29

switch family
    case 'clayton'
        Y = -(X + 1) .^ (-1 - 1/p) / p;
    case 'gumbel'
        Y = -(1 / p) * exp( -X .^ (1/p) ) .* (X .^ (1 / p - 1));
    case 'frank'        
        Y = (1 - exp(p)) ./ (p * exp(p + X) - exp(p) * p + p);
    otherwise
        error('Copula family %s not recognized.', family);
end

end
