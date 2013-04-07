function [ f ] = generator( family, x, p )
%ARCHIM.SYM.GEN Symbolic expression of Archimedean copula generator.
%   Provides symbolic expression of Archimdean copula generator using
%   symbols x and p.

switch family
    case 'clayton'
        f = (1 + x) ^ (-1/p);
    case 'gumbel'
        f = exp(-x ^ (1/p));
    case 'frank'
        f = (-1/p) * log( 1 - ( 1 - exp(-p) ) * exp(-x) );
    case 'joe'
        f = 1 - (1 - exp(-x)) ^ (1 / p);
    otherwise
        error 'Copula family not recognized.'
end

end

