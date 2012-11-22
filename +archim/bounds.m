function [ l, u ] = bounds( family, d )
%ARCHIMBOUNDS Bounds of parameters of Archimedean copula.
%   Returns maximum and lower bound of the interval for parameter for given
%   Archimedean copula family in given dimenstion. Please note that function 
%   only returns bounds.
%
%   Bounds for 2 dimensional case can be found in [1].
%   Lower estimate of bounds can be found in [2]. Unfortunately they are
%   defined for n-dimensional case. To make bounds more correct analytical
%   bound for d-dimensional case should be found.
%
%   Reference:
%       [1] Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 117
%       [2] Nelsen. R, (2006) Introduction to Copulas, Second Edition, page 152

switch family
    case 'clayton'
        if d > 2           
            l = 0;
        else
            % Nelsen suggests -1 as the lower bound, but MATLAB uses 0
            l = 0;
        end
        u = Inf;
    case 'gumbel'
        l = 1;
        u = Inf;
    case 'frank'
        if d > 2
            l = 0;
        else
            l = -Inf;
        end
        u = Inf;
    otherwise
        error 'Copula family not recognized.'
end
        
end

