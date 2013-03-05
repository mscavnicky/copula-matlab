function [ Y ] = emppdf( F, X )
%EMPCDF Empirical pdf according to Wintermann

n = size(F, 1);

lambda = n ^ (-1/5);
Y = (empcdf(F, X + lambda) - empcdf(F, X - lambda)) / (2 * lambda);

end

