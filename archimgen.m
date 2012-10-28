function [ Y ] = archimgen( family, X, p )
%ARCHIMGEN Archimedean copula function generator.
%   Supports Frank, Gumbel and Clayton copulas.

switch family
    case 'frank'
        Y = ( -1 / p ) * log( 1 - ( 1 - exp(-p) ) .* exp(-X) );
    case 'clayton'
        Y = max( ( 1 + p .* X ) .^ ( -1 / p ), 0 );
    case 'gumbel'
        Y = exp( -X .^ ( 1 / p ) );
end
        
end

