function [ lowerBound, upperBound ] = bounds( family, d )
%ARCHIMB.OUNDS Bounds of parameters of Archimedean copula of d-dimensions.
%   Returns maximum and lower bound of the interval for parameter for given
%   Archimedean copula family in given dimenstion. Please note that
%   function only returns bounds.
%
%   Bounds for 2 dimensional case can be found in [1]. Lower estimate of
%   bounds can be found in [2]. Unfortunately they are defined for
%   n-dimensional case. To make bounds more correct analytical bound for
%   d-dimensional case should be found.
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
        % copula. In general n-dimensional case valid parameter has to be
        % positive. If the 2D copula is used within HAC parameter has to be
        % positive too. See [3].
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

