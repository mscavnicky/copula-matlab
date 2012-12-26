function [ f ] = cdf( family, tree )
%HACCDF Symbolic representation of HAC of given family and structure.
%   Note that alphas are already part of an expression.

% Dimensions of top-level copula in hac structure
d = length(tree) - 1;
% Cell array where arguments for this level copula are collected
arguments = cell(d, 1);

for i=1:d
    % Perform recursion if element of structure is another copula
    if iscell(tree{i})
        arguments{i} = hac.sym.cdf(family, tree{i});
    else
        % Introduce symbol representing u_n
        arguments{i} = sym(sprintf('u%d', tree{i}));
    end    
end
% Retrieve alpha from hac structure and convert it to decimal symbol
% Conversion to decimal symbol is necessary otherwise expression will end
% up with humongous fractions. Decimal representation also seems faster
% than floating-point representation.
alpha = sym(tree{end}, 'd');
% Compose copula function from arguments and numerical alpha
f = archim.sym.cdf(family, arguments, alpha);

end
