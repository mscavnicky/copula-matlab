function [ f ] = inv( family, x, p )
%ARCHIMINVSYM Symbolic represenatation of inverse of archimedean copula 
%generator.

switch family
    case 'clayton'
        f = ( x .^ -p - 1 );
    case 'gumbel'
        f = ( -log(x) ) .^ p;
    case 'frank'
        f = -log( ( exp(-p * x) - 1 ) / ( exp(-p) - 1 ) );
    case 'joe'
        f = -log( 1 - (1 - x) .^ p );
    otherwise
        error 'Copula family not recognized.'
end

end

