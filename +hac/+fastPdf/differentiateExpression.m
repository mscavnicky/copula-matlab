function [ diffExpr ] = differentiateExpression( expr, m )
%HAC.FASTPDF.DIFFERENTIATEEXPRESSIOn Differentiate copula expression string.
%   Given a copula expression string differentiate it with respect to the
%   first m variables using Symbolic Toolbox and returns string of the
%   differentiated expression.
%
%   When second argument is not provided, expression is differentiated with
%   respect to all variables.

% Convert copula string expression into symbolic form
symExpr = sym(expr);
% Obtain all the variables of the symbolic expression
vars = symvar(symExpr);
% Expression is differentiated wrt all arguments
if nargin < 2
    m = numel(vars);
end
% Differentiate in the first m variables
for i=1:m
    symExpr = diff(symExpr, vars(i));
end
% Convert differentiated symbolic expression back to string
diffExpr = char(symExpr);

end

