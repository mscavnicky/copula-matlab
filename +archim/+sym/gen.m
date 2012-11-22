function [ f ] = gen( family, x, p )
%ARCHIMGENSYM Symbolic expression of Archimedean copula generator.
%   Provides symbolic expression of Archimdean copula generator using
%   symbols x and p.

switch family
    case 'frank'
        f = (-1/p) * log( 1 - ( 1 - exp(-p) ) * exp(-x) );        
    case 'clayton'
        f = (1 + p*x) ^ (-1/p);
    case 'gumbel'
        f = exp(-x ^ (1/p));
    otherwise
        error 'Copula family not recognized.'
end

end

