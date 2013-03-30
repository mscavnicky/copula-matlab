function [ fits ] = fitcopulas( X, method )
%FITCOPULAS Fits all possible copulas functions to sample U and returns the
%   best fit according to BIC and all other fits. Method can be either CML
%   or IFM.

dbg('fitcopulas', 1, 'Fiting copulas using %s method.\n', method);
dbg('fitcopulas', 2, 'Uniforming data.\n');

families = {...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'};

for i=1:numel(families)
    fits(i) = fitcopula( families{i}, X, method ); %#ok<AGROW>
end

end

function [ fit ] = fitcopula( family, X, method )
    dbg('fitcopulas', 3, 'Fitting family %s.\n', family);
    fit.Family = family;
    
    if ismember(family, {'claytonhac*', 'gumbelhac*', 'frankhac*'})
        P = hac.preprocess( family, X, method );
        X = X * P;
        family = family(1:end-1);
    end    
    
    if strcmp(method, 'CML')
        U = uniform(X);
    elseif strcmp(method, 'IFM');
        margins = fitmargins(X);
        U = pit(X, {margins.ProbDist});
    else
        error('Method %s not recognized.', method);
    end   
    
    copulaparams = copula.fit(family, U);
    dbg('fitcopulas', 3, 'Computing statistics.\n');    
    [ll, aic, bic, ks, aks, snc] = copula.fitstat(copulaparams, U);
    
    % Compose the resulting fit object    
    fit.Copula = copulaparams;
    fit.Method = method;
    fit.LL = ll;
    fit.AIC = aic;
    fit.BIC = bic;
    fit.KS = ks;
    fit.AKS = aks;
    fit.SnC = snc;
end

