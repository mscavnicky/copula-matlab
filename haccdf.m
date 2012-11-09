function [ Y ] = haccdf( family, U, hac )
%HACCDF Cumulative distribution function of hierarchical Archimedean copula.
%   Given structure of HAC computes CDF in given points. 
%
%   { 1, 2, { 3, 4, [5.2] } [1.2] }

% Dimensions of top-level copula in hac structure
d = length(hac) - 1;
% Size of the dataset for preallocation purposes
n = size(U, 1);
% Preallocate matrix for inputs of this copula
V = zeros(n, d);
for i=1:d
    % Perform recursion if element of structure is another copula
    if iscell(hac{i})
        V(:, i) = haccdf(family, U, hac{i});        
    else
        V(:, i) = U(:, hac{i});
    end    
end
% Retrieve alpha from the hac structure
alpha = hac{end};
% Compute copula function given data and alpha
Y = archimcdf(family, V, alpha);

end

