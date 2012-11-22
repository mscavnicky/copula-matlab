function [ Y ] = pdf( family, U, tree )
%HACPDF Probability distribution function of family of HAC.
%   Derives and evalutes symbolic expression of density function for given
%   HAC.

% Express analytical version of hierarchical copula function
f = hac.sym.cdf(family, tree);
% Get all arguments that we will use to differentiate copula function
% Even though not documented symvar sorts retrieved variables
args = symvar(f);
% Differentiate the CDF in all variables to acquire PDF
for j=1:length(args)
    f = diff(f, args(j));
end

% Convert to Matlab function and evaluate
fn = matlabFunction(f, 'vars', {args});
Y = fn(U);

end