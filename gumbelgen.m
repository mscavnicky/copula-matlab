function [ Y ] = gumbelgen( X, p )
%GUMBELGEN Gumbel copula generator
    Y = exp( -X .^ ( 1 / p ) );
end


