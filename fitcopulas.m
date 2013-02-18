function [ fits ] = fitcopulas( X, method )
%FITCOPULAS Fits all possible copulas functions to sample U and returns the
%   best fit according to BIC and all other fits. Method can be either CML
%   or IFM.

fprintf('Uniforming data...\n');

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
    fprintf('Fitting family %s...\n', family);
    copulaparams = copula.fit(family, U);
    [ll, aic, bic] = copula.fitstat(copulaparams, U);
    
    fit.copulaparams = copulaparams;
    fit.family = copulaparams.family;
    fit.ll = ll;
    fit.aic = aic;
    fit.bic = bic;  
    
    fits{i} = fit;
end

end

