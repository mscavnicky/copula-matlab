function [ Y ] = claytondiff( X, p )
%CLAYTONDIFF Derivative of Clayton copula generator
% http://www.wolframalpha.com/input/?i=%281%2Bp*x%29%5E%28-1%2Fp%29
    Y = -(p * X + 1) .^ (-1 - 1/p);
end

