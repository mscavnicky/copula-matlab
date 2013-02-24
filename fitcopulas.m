function [ fits ] = fitcopulas( X, method, dists )
%FITCOPULAS Fits all possible copulas functions to sample U and returns the
%   best fit according to BIC and all other fits. Method can be either CML
%   or IFM.

dbg('fitcopulas', 1, 'Fiting copulas using %s method.\n', method);
dbg('fitcopulas', 2, 'Uniforming data.\n');

if strcmp(method, 'CML')
    U = uniform(X);
elseif strcmp(method, 'IFM');
    U = pit(X, dists);
else
    error('Method %s not recognized.', method);
end    

families = {'gaussian' 't' 'clayton' 'frank' 'gumbel' 'claytonhac' 'gumbelhac' 'frankhac'};
fits = cell(numel(families), 1);
stats = zeros(numel(families), 4);

for i=1:numel(families)    
    family = families{i};
    dbg('fitcopulas', 2, 'Fitting family %s.\n', family);
    copulaparams = copula.fit(family, U);
    dbg('fitcopulas', 2, 'Computing statistics.\n');    
    
    fit.copulaparams = copulaparams;
    fit.family = copulaparams.family;    
    [ll, aic, bic, ~, aks] = copula.fitstat(copulaparams, U);
    fit.stats = [ll, aic, bic, aks];
    stats(i, :) = fit.stats;
    
    fits{i} = fit;
end

end

