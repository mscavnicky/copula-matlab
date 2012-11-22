function cmp( U )
%COPULACMP Performs fit on different copula families and gives you
%comparison
[ll, aic, bic] = gaussianfit(U);
fprintf('Gaussian    LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
[ll, aic, bic] = tfit(U);
fprintf('Student-t   LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
[ll, aic, bic] = claytonfit(U);
fprintf('Clayton     LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
[ll, aic, bic] = gumbelfit(U);
fprintf('Gumbel      LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
[ll, aic, bic] = frankfit(U);
fprintf('Frank       LL: %f AIC: %f BIC: %f\n', ll, aic, bic);
end

function [ll, aic, bic] = gaussianfit(U)
%GAUSSIANFIT Fit data to gaussian copula and return statistics
[n, d] = size(U);
rhohat = copulafit('gaussian', U);
ll = loglike(copulapdf('gaussian', U, rhohat));
[aic, bic] = aicbic(ll, d*(d-1)/2, n);
end

function [ll, aic, bic] = tfit(U)
%TFIT Fit data to t copula and return statistics
[n, d] = size(U);
[rhohat, nuhat] = copulafit('t', U);
ll = loglike(copulapdf('t', U, rhohat, nuhat));
[aic, bic] = aicbic(ll, 1 + d*(d-1)/2, n);
end

function [ll, aic, bic] = claytonfit(U)
[n, d] = size(U);
tree = hac.fit('clayton', U, 'okhrin');
ll = loglike(hac.pdf('clayton', U, tree));
[aic, bic] = aicbic(ll, d-1, n);
end

function [ll, aic, bic] = gumbelfit(U)
[n, d] = size(U);
tree = hac.fit('gumbel', U, 'okhrin');
ll = loglike(hac.pdf('gumbel', U, tree));
[aic, bic] = aicbic(ll, d-1, n);
end

function [ll, aic, bic] = frankfit(U)
[n, d] = size(U);
tree = hac.fit('frank', U, 'okhrin');
ll = loglike(hac.pdf('frank', U, tree));
[aic, bic] = aicbic(ll, d-1, n);
end
