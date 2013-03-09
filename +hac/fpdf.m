function [ Y ] = fpdf( family, U, tree, cacheLevel )
%HAC.PDF Probability distribution function of family of HAC.
%   Derives and evalutes expression of density function for given
%   HAC. Using fast evaluation based on deriving only the high-level
%   derivation.

%#ok<*AGROW>

d = size(U, 2);

if nargin < 4
   cacheLevel = min(d-1, 7); 
end

% Compose high level symbolic functions
[expr, params] = hac.fpdf.expr(tree);

% Differentiate expression symbolically
dbg('hac.fpdf', 4, 'Differentiating expression.\n')
dexpr = hac.fpdf.diffexpr(expr);

% Evaluate differentiated expression
dbg('hac.fpdf', 4, 'Evaluating expression.\n')
Y = hac.fpdf.evalinfix( family, U, dexpr, params, cacheLevel );

end