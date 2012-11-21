function [ f ] = haccdf( family, hac )
%HACCDF Symbolic representation of HAC of given family and structure.
%   Note that alphas are already part of an expression.

% Dimensions of top-level copula in hac structure
d = length(hac) - 1;
% Cell array where arguments for this level copula are collected
arguments = {};

for i=1:d
    % Perform recursion if element of structure is another copula
    if iscell(hac{i})
        arguments{i} = hacsym(family, hac{i});
    else
        % Introdcue new symbol
        arguments{i} = sym(sprintf('u%d', hac{i}));
    end    
end
% Retrieve alpha from hac structure and convert it to decimal symbol
% Conversion to decimal symbol is necessary otherwise expression will end
% up with humongous fractions.
alpha = sym(hac{end}, 'd');
% Compose copula function from arguments and numerical alpha
f = sym.archimcdf(family, arguments, alpha);

end
