function [ summary ] = copulasummary( family, X )
%COPULASUMMARY Fits given data to a copula and computes different GOF mesaures

% By default, copulafit uses maximum likelihood to fit a copula to U. 
% When U contains data transformed to the unit hypercube by parametric 
% estimates of their marginal cumulative distribution functions, this is 
% known as the Inference Functions for Margins (IFM) method. 
% When U contains data transformed by the empirical cdf (see ecdf), this is
% known as Canonical Maximum Likelihood (CML).

% FIXME NumParams argument for aicbic

% Convert columns of X to uniform variates
U = colfun(@uniform, X);
% Read sizes of the dataset
[m, n] = size(U);
% Compute empirical copula using empirical uniform values
empiricalCopula = ecopula(U);

switch family
    case 'gaussian'
        % Fit and computer LL, AIC, BIC
        rhohat = copulafit(family, U);
        ll = loglike(copulapdf(family, U, rhohat));
        [aic, bic] = aicbic(ll, n*(n-1)/2, m);
        
    case 't'
        % Fit and compute LL, AIC, BIC
        [rhohat, nuhat] = copulafit(family, U);
        ll = loglike(copulapdf(family, U, rhohat, nuhat));
        [aic, bic] = aicbic(ll, 1 + n*(n-1)/2, m);
        
    case {'frank', 'gumbel', 'clayton'}
        % Fit and compute LL, AIC, BIC
        paramhat = copulafit(family, U);
        ll = loglike(copulapdf(family, U, paramhat));
        [aic, bic] = aicbic(ll, 1, m);
        
        % Kolmogorov-Smirnov GOF test
        hypothesisCopula = copulacdf(family, U, paramhat);
        [h, p] = kstest2(empiricalCopula, hypothesisCopula);
   
    otherwise
        error 'Copula family not recognized.'
end

summary.logLikelihhod = ll;
summary.aic = aic;
summary.bic = bic;

if exist('rhohat', 'var')
    summary.rhohat = rhohat;
end
if exist('nuhat', 'var')
    summary.nuhat = nuhat;
end
if exist('paramhat', 'var')
    summary.paramhat = paramhat;
end

end

