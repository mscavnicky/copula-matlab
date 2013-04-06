function [ Y ] = generatorInverse( family, X, p )
%ARCHIM.GENERATORINVERSE Inverse of archimedean copula generator.
%   Please note that no parameter checking is done on this level.
%
%   Reference:
%       [1] Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 116

switch family
    case 'clayton'
        Y = ( X .^ -p ) - 1;
    case 'gumbel'
        Y = ( -log(X) ) .^ p;
    case 'frank'
        Y = -log( ( exp(-p * X) - 1 ) / ( exp(-p) - 1 ) );
    otherwise
        error('Copula family %s not recognized.', family);
end

end

