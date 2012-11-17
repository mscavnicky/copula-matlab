function [ Y ] = hacpdf( family, U, hac )
%HACPDF Probability distribution function of family of HAC.
%   Derives and evalutes symbolic expression of density function for given
%   HAC.

% Express analytical version of hierarchical copula function
f = sym.hacpdf(family, hac);
% Get all arguments that we will use to differentiate copula function
% Even though not documented symvar sorts retrieved variables
args = symvar(f);

for j=1:length(args)
    f = diff(f, args(j));
end

% Convert to Matlab function and evaluate
fn = matlabFunction(f, 'vars', {args});
Y = fn(U);

end