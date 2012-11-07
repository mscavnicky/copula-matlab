function [ Y ] = hacpdf( family, U, hac )
%HACPDF Probability distribution function of family of HAC.
%   Derives and evalutes symbolic expression of density function for given
%   HAC.

% Express analytical version of hierarchical copula function
f = hacsym(family, hac);
% Get all arguments that we will use to differentiate copula function
% Even though not documented symvar sorts retrieved variables
args = symvar(f);

for j=1:length(args)
    f = diff(f, args(j));
end

fn = matlabFunction(f, 'vars', {args});
Y = fn(U);

end

function [ f ] = hacsym( family, hac )
%HACSYM Finds symbolic representation of HAC of given family.

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
% Retrieve alpha from hac structure
alpha = hac{end};
% Compose copula function from arguments and numerical alpha
f = archimsym(family, arguments, alpha(1));

end