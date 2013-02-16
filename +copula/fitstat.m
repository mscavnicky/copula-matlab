function [ ll, aic, bic ] = fitstat( copulaparams, U )
%COPULA.FITSTAT Given copula structure and data U compuates fit statistics.
%   Computes LL, AIC and BIC statistics.

n = size(U, 1);

ll = -loglike(copula.pdf(copulaparams, U));
k = copulaparams.numParams;
aic = -2*ll + (2*n*(k+1))/(n-k-2);
bic = -2*ll + k*log(n);

end

