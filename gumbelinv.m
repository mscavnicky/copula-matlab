function [ Y ] = gumbelinv( X, p )
%GUMBELINV Inverse of Gumbel copula generator
    Y = ( -log(X) ) .^ p;
end 


