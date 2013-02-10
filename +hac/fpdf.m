function [ Y ] = fpdf( family, U, tree, cacheLevel )
%HACPDF Probability distribution function of family of HAC.
%   Derives and evalutes symbolic expression of density function for given
%   HAC.

%#ok<*AGROW>

d = size(U, 2);

if nargin < 4
   cacheLevel = min(d-1, 7); 
end

% Compose high level symbolic functions
[expr, params] = hac.fpdf.expr(tree);

% Perform its derivations in all variables
fexpr = sym(expr);
vars = symvar(fexpr);
for i=1:numel(vars)
    fexpr = diff(fexpr, vars(i));
end

Y = hac.fpdf.evalinfix( family, U, char(fexpr), params, cacheLevel );

% Replace terms inside it with variables
%[inexpr, terms] = hac.fpdf.substitute(char(fexpr));
% Convert infix expression into its postfix form
%postexpr = hac.fpdf.in2post(inexpr);
% Evaluate substituted expression in a postfix form
%Y = hac.fpdf.evalpostfix(family, U, postexpr, terms, params);

end