function [ lowerBound, upperBound ] = bounds( family, d )
%ARCHIMB.BOUNDS Bounds of parameters of Archimedean copula of d-dimensions.
%   Returns lower and upper bound of the interval of the parameter for
%   given Archimedean copula family in given dimenstion.
%
%   Bounds for 2 dimensional case can be found in [1]. Estimate of bounds
%   for n-dimensional case can be found in [2].
%
%   Reference:
%       [1] Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 117 
%       [2] Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 152

switch family
    case 'clayton'
        lowerBound = 0;
        upperBound = Inf;
    case 'gumbel'
        lowerBound = 1;
        upperBound = Inf;
    case 'frank'
        % In 2D case Frank copula is able to represent countermonotonicity
        % copula. In general d-dimensional case valid parameter has to be
        % positive.
        if d > 2
            lowerBound = 0;
        else
            lowerBound = -Inf;
        end
        upperBound = Inf;
    otherwise
        error('Copula family %s not recognized.', family);
end
        
end

