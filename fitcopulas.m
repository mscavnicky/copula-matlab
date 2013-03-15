function [ fits ] = fitcopulas( X, method, dists )
%FITCOPULAS Fits all possible copulas functions to sample U and returns the
%   best fit according to BIC and all other fits. Method can be either CML
%   or IFM.

dbg('fitcopulas', 1, 'Fiting copulas using %s method.\n', method);
dbg('fitcopulas', 2, 'Uniforming data.\n');

if strcmp(method, 'CML')
    U = uniform(X);
elseif strcmp(method, 'IFM');
    U = pit(X, {dists.ProbDist});
else
    error('Method %s not recognized.', method);
end

families = {...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'};

for i=1:numel(families)    
    family = families{i};
    dbg('fitcopulas', 3, 'Fitting family %s.\n', family);
    copulaparams = copula.fit(family, U);
    dbg('fitcopulas', 3, 'Computing statistics.\n');    
    [ll, aic, bic, ks, aks, snc] = copula.fitstat(copulaparams, U);
    
    % Compose the rseulting fit object
    fits(i).Family = copulaparams.family;
    fits(i).Copula = copulaparams;
    fits(i).Method = method;
    fits(i).LL = ll;
    fits(i).AIC = aic;
    fits(i).BIC = bic;
    fits(i).KS = ks;
    fits(i).AKS = aks;
    fits(i).SnC = snc;
end

end

