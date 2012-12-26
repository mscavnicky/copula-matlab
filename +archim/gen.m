function [ Y ] = gen( family, X, p )
%ARCHIMGEN Archimedean copula function generator.
%   Supports Frank, Gumbel and Clayton copulas.
%   Please not that no parameter checking is done in this function.
%
%   Reference:
%       Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 116

switch family
    case 'clayton'
        Y = ( 1 + X ) .^ ( -1 / p );
    case 'gumbel'
        Y = exp( -X .^ ( 1 / p ) );
    case 'frank'
        Y = ( -1 / p ) * log( 1 - ( 1 - exp(-p) ) .* exp(-X) );
    case 'joe'
        Y = 1 - ( 1 - exp(-X) ) .^ (1 / p);       
    otherwise
        error 'Copula family not recognized.'
end
        
end

