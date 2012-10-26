function [ Y ] = claytoninv( X, p )
%CLAYTONINV Inverse of Clayton copula generator
    Y = ( 1 / p ) * ( X .^ -p - 1 );
end


