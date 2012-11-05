function [ Y ] = archimpdf( family, U, alpha )
%ARCHIMPDF Probability density function for multivariate archimedean copula.
%   PDF is computed as described in paper by McNeil & Neslehova.
%   Extremal values where at least one margin is set to zero are also computed
%   according to the equation. MATLAB in this case returns 0, R returns NaN.

% Acquire copula dimension for the derivative
d = size(U, 2);
% Evaluate equation
N = archimndiff( family, d, sum(archiminv( family, U, alpha ), 2), alpha );
D = prod( archimdiff( family, archiminv( family, U, alpha ), alpha ), 2 );
Y = N ./ D;

end
