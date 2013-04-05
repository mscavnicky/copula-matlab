function [ Y ] = fastCnd( family, U, tree, m )
%HAC.FCND Fast implementation of conditional HAC function.
%   Computes conditional CDF of d-dimensional copula, where m-th variable
%   is conditined upon first m-1 variables.

% Nominator tree is pruned to m dimensions
nTree = hac.prune( tree, m );
% Copula expression string is produced
[nExpr, nParams] = hac.fpdf.expr(nTree);
% Copula expression string is differentiated in m-1 variables
nDiffExpr = hac.fpdf.diffexpr(nExpr, m-1);
% Evaluate differentiated expression
N = hac.fpdf.evalinfix( family, U, nDiffExpr, nParams, m-1 );

% In 2 dimensions denominator tree reduces to single variable that is
% derived to 1, therefore we only need to return nominator.
if m == 2
    Y = N;
    return;
end

% Denominator tree is pruned to m-1 dimensions
dTree = hac.prune( tree, m-1 );
% Copula expression string is produced
[dExpr, dParams] = hac.fpdf.expr(dTree);
% Copula expression string is differentiated in m-1 variables
dDiffExpr = hac.fpdf.diffexpr(dExpr, m-1);
% Evaluate differentiated expression
D = hac.fpdf.evalinfix( family, U, dDiffExpr, dParams, m-1 );

Y = N ./ D;
end