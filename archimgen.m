function [ Y ] = archimgen( family, X, p )
%ARCHIMGEN Archimedean copula function generator.
% Supports Frank, Gumbel and Clayton copulas.

switch family
    case 'frank'
        Y = ( -1 / p ) * log( 1 - ( 1 - exp(-p) ) .* exp(-X) );
    case 'clayton'
        Y = ( 1 + p .* X ) .^ ( -1 / p );
    case 'gumbel'
        Y = exp( -X .^ ( 1 / p ) );
end
        
end

