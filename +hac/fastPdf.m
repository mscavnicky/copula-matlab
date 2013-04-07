function [ Y ] = fastPdf( family, U, tree )
%HAC.FASTPDF Probability distribution function of family of HAC.
%   Derives and evalutes expression of density function for given
%   HAC. Using fast evaluation based on deriving only the high-level
%   strucutre.

% Compose high level expression of HAC
[hacExpression, params] = hac.fastPdf.hacExpression(tree);

% Differentiate high level expression symbolically
dbg('hac.fpdf', 4, 'Differentiating expression.\n')
differentiatedExpr = hac.fastPdf.differentiateExpression(hacExpression);

% Evaluate differentiated expression using its parameters
dbg('hac.fpdf', 4, 'Evaluating expression.\n')
Y = hac.fastPdf.evaluateDerivative( family, U, differentiatedExpr, params );

end