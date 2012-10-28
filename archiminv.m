function [ Y ] = archiminv( family, X, p )
%ARCHIMINV Inverse of archimedean copula generator.
%   Supports Frank, Gumbel and Clayton copulas.

switch family
    case 'frank'
        Y = -log( ( exp(-p * X) - 1 ) / ( exp(-p) - 1 ) );
    case 'clayton'
        Y = ( 1 / p ) * ( X .^ -p - 1 );
    case 'gumbel'
        Y = ( -log(X) ) .^ p;
end

end

