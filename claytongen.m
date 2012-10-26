function [ Y ] = claytongen( X, p )
%CLAYTONGEN Clayton copula generator
    Y = ( 1 + p .* X ) .^ ( -1 / p );
end

