function [ Y ] = archimdiff( family, X, p )
%ARCHIMDIFF Derivative of archimedean copula generator.
% Supports Frank, Gumbel and Clayton copulas.
% For analytical derivation see:
%   Clayton http://www.wolframalpha.com/input/?i=%281%2Bp*x%29%5E%28-1%2Fp%29
%   Gumbel http://www.wolframalpha.com/input/?i=exp%28-x%5E%281%2Fp%29%29
%   Frank http://www.wolframalpha.com/input/?i=%28-1%2Fp%29*log%281+-+%281+-+exp%28-p%29%29*exp%28-x%29%29

switch family
    case 'frank'        
        Y = (1 - exp(p)) ./ (p * exp(p + X) - exp(p) * p + p);
    case 'clayton'
        Y = -(p * X + 1) .^ (-1 - 1/p);
    case 'gumbel'
        Y = -(1 / p) * exp( -X .^ (1/p) ) .* (X .^ (1 / p - 1));
end

end

