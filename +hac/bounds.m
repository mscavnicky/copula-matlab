function [ l, u ] = bounds( family )
%HAC.BOUNDS Bounds of parameters of Hierarchical Archimedean Copulas
%   Returns maximum and lower bound of the interval for parameter for given
%   Archimedean copula family.
%
%   References:
%       [1] Okhrin. O, (2009) Properties of Hierarchical Archimedean
%       Copulas, page 6

switch family
    case 'clayton'
        l = 0;
        u = Inf;
    case 'gumbel'
        l = 1;
        u = Inf;
    case 'frank'
        l = 0;
        u = Inf;
    otherwise
        error 'Copula family not recognized.'
end
        
end

