function [ lowerBound, upperBound ] = bounds( family )
%HAC.BOUNDS Bounds of parameters of Hierarchical Archimedean Copulas
%   Returns maximum and lower bound of the interval for parameter for given
%   Archimedean copula family.
%
%   References:
%       [1] Okhrin. O, (2009) Properties of Hierarchical Archimedean
%       Copulas, page 6

switch family
    case 'clayton'
        lowerBound = 0;
        upperBound = Inf;
    case 'gumbel'
        lowerBound = 1;
        upperBound = Inf;
    case 'frank'
        lowerBound = 0;
        upperBound = Inf;      
    otherwise
        error 'Copula family not recognized.'
end
        
end

