function [ Y ] = frankdiff( X, p )
%FRANKDIFF Derivative of Frank copula generator
% http://www.wolframalpha.com/input/?i=%28-1%2Fp%29*log%281+-+%281+-+exp%28-p%29%29*exp%28-x%29%29
    Y = (1 - exp(p)) / (p * exp(p + X) - exp(p) * p + p);
end

