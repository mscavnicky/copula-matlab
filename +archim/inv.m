function [ Y ] = inv( family, X, p )
%ARCHIMINV Inverse of archimedean copula generator.
%   Supports Frank, Gumbel and Clayton copulas.
%   Please note that no parameter checking is done on this level.
%
%   Reference:
%       Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 116

switch family
    case 'frank'
        Y = -log( ( exp(-p * X) - 1 ) / ( exp(-p) - 1 ) );
    case 'clayton'
        Y = ( 1 / p ) * ( X .^ -p - 1 );
    case 'gumbel'
        Y = ( -log(X) ) .^ p;
    otherwise
        error 'Copula family not recognized.'
end

end

