function [ f ] = inv( family, x, p )
%ARCHIMINVSYM Symbolic represenatation of inverse of archimedean copula 
%generator.

switch family
    case 'frank'
        f = -log( ( exp(-p * x) - 1 ) / ( exp(-p) - 1 ) );
    case 'clayton'
        f = ( 1 / p ) * ( x .^ -p - 1 );
    case 'gumbel'
        f = ( -log(x) ) .^ p;
    otherwise
        error 'Copula family not recognized.'
end

end

