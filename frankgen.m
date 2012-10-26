function [ Y ] = frankgen( X, p )
%FRANKGEN Frank copula generator
    Y = ( -1 / p ) * log( 1 - ( 1 - exp(-p) ) .* exp(-X) );
end