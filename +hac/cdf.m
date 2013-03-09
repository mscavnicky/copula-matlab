function [ Y ] = cdf( family, U, tree )
%HAC.CDF Cumulative distribution function of hierarchical Archimedean copula.
%   Given structure of HAC computes CDF in given points. 

% Dimensions of top-level copula in hac structure
d = length(tree) - 1;
% Size of the dataset for preallocation purposes
n = size(U, 1);
% Preallocate matrix for inputs of this copula
V = zeros(n, d);
for i=1:d
    % Perform recursion if element of structure is another copula
    if iscell(tree{i})
        V(:, i) = hac.cdf(family, U, tree{i});        
    else
        V(:, i) = U(:, tree{i});
    end    
end
% Retrieve alpha from the hac structure
alpha = tree{end};
% Compute copula function given data and alpha
Y = archim.cdf(family, V, alpha);

end

