function [ fits ] = fitcopulas( X, method )
%FITCOPULAS Fits all possible copulas functions to sample U and returns the
%   best fit according to BIC and all other fits. Method can be either CML
%   or IFM.

dbg('fitcopulas', 1, 'Uniforming data.\n');

if strcmp(method, 'CML')
    U = uniform(X);
elseif strcmp(method, 'IFM');
    [dists, pvalues] = fitmargins(X);
    fit.dists = dists;
    fit.pvalues = pvalues;
    U = pit(X, dists);
else
    error('Method %s not recognized.', method);
end    

families = {'gaussian' 't' 'clayton' 'frank' 'gumbel' 'claytonhac' 'gumbelhac' 'frankhac'};
fits = cell(size(families));

for i=1:numel(families)    
    family = families{i};
    dbg('fitcopulas', 2, 'Fitting family %s.\n', family);
    copulaparams = copula.fit(family, U);
    dbg('fitcopulas', 2, 'Computing statistics.\n');
    [ll, aic, bic, ks] = copula.fitstat(copulaparams, U);
    
    fit.copulaparams = copulaparams;
    fit.family = copulaparams.family;
    fit.ll = ll;
    fit.aic = aic;
    fit.bic = bic;
    fit.ks = ks;
    
    fits{i} = fit;
end

end

