function [ Y ] = gumbeldiff( X, p )
%GUMBELDIFF Derivative of Gumbel copula generator
    Y = (1 / p) * exp( -X .^ (1/p) ) * (X .^ (1 / p - 1));
end

