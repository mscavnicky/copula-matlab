function [ Y ] = frankinv( X, p )
%FRANKINV Inverse of Frank copula generator
    Y = -log( ( exp(-p * X) - 1 ) / ( exp(-p) - 1 ) );
end

