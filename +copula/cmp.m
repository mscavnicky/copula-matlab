function cmp( U )
%COPULACMP Performs fit on different copula families and gives you
%comparison
[ll, aic, bic, p] = gaussianfit(U);
fprintf('Gaussian     LL: %f AIC: %f BIC: %f p:%f\n', ll, aic, bic, p);
[ll, aic, bic, p] = tfit(U);
fprintf('Student-t    LL: %f AIC: %f BIC: %f p:%f\n', ll, aic, bic, p);
[ll, aic, bic, p] = archimfit('clayton', U);
fprintf('Clayton      LL: %f AIC: %f BIC: %f p:%f\n', ll, aic, bic, p);
[ll, aic, bic, p] = archimfit('gumbel', U);
fprintf('Gumbel       LL: %f AIC: %f BIC: %f p:%f\n', ll, aic, bic, p);
[ll, aic, bic, p] = archimfit('frank', U);
fprintf('Frank        LL: %f AIC: %f BIC: %f p:%f\n', ll, aic, bic, p);
[ll, aic, bic] = hacfit('clayton', U);
fprintf('Clayton HAC  LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
[ll, aic, bic] = hacfit('gumbel', U);
fprintf('Gumbel HAC   LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
[ll, aic, bic] = hacfit('frank', U);
fprintf('Frank HAC    LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
end

function [ll, aic, bic, p] = gaussianfit(U)
%GAUSSIANFIT Fit data to gaussian copula and return statistics
[n, d] = size(U);
copulaparams = copula.fit('gaussian', U);
ll = loglike(copulapdf('gaussian', U, copulaparams.rho));
[aic, bic] = aicbic(ll, d*(d-1)/2, n);
[h, p] = copula.gof('gaussian', U, 'snc', copulaparams);
end 

function [ll, aic, bic, p] = tfit(U)
%TFIT Fit data to t copula and return statistics
[n, d] = size(U);
copulaparams = copula.fit('t', U);
ll = loglike(copulapdf('t', U, copulaparams.rho, copulaparams.nu));
[aic, bic] = aicbic(ll, 1 + d*(d-1)/2, n);
p = NaN;
%[h, p] = copula.gof('t', U, 'snc', copulaparams);
end

function [ll, aic, bic, p] = archimfit(family, U)
%TFIT Fit data to Archim copula and return statistics
[n, d] = size(U);
copulaparams = copula.fit(family, U);
ll = loglike(archim.pdf(family, U, copulaparams.alpha));
[aic, bic] = aicbic(ll, 1, n);
[h, p] = copula.gof(family, U, 'snc', copulaparams);
end

function [ll, aic, bic] = hacfit(family, U)
[n, d] = size(U);
tree = hac.fit(family, U, 'okhrin');
ll = loglike(hac.pdf(family, U, tree));
[aic, bic] = aicbic(ll, d-1, n);
end