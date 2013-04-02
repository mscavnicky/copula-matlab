function [ ll, aic, bic, ks, aks, snc ] = stats( copulaparams, U )
%COPULA.STATS Computes 6 different fit statistics given for a copula and
%   uniformed data. Computes LL, AIC, BIC, KS, AKS and SnC statistics.

[n, d] = size(U);

% Compute the log-likelihood
Y = copula.pdf(copulaparams, U);
ll = sum(log(Y));

k = copulaparams.numParams;
% Compute the AIC
aic = -2*ll + (2*n*k)/(n-k-1);
% Compute the BIC
bic = -2*ll + k*log(n);

% Compute KS measure
E = copula.pit( copulaparams, U );
% Produce vector with chi-square distribution
C = sum( norminv( E ) .^ 2, 2 );
% Compute the KS statistics
ks = sqrt(n) * max(abs(chi2cdf(C, d) - uniform(C)));
% Compute the AKS statistics
aks = sum(abs(chi2cdf(C, d) - uniform(C))) / sqrt(n);
% Compute the SnC statistics
snc = sum((copula.emp(E) - prod(E, 2)) .^ 2);

end

