function [ Y ] = haccdf( family, U, hac )
%HACCDF Cumulative distribution function of hierarchical Archimedean copula.
%   Given structure of HAC produced by hacfit, computes CDF in given
%   points. 
%
%   HAC structure is a map containing key-value pairs where:
%       * key is identifier of the a copula
%       * value is a 2-element cell array consisting of copula parameter
%       and references to other variables of copulas used       

keys = hac.keys;
for i=1:hac.Count
    key = keys(i);
    value = hac.values(key);
    
    alpha = value{1}{1};
    vars = value{1}{2};
    
    U = [U archimcdf(family, U(:, vars), alpha)];    
end

Y = U(:, end);

end

