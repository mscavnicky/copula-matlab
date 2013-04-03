function [ fits ] = fitcopulas( X, method )
%FITCOPULAS Fits all possible copulas functions to sample U and returns
%results of all fits. Method can be either CML or IFM.

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
%FITCOPULA Fit single copula family to X using selected method.
    dbg('fitcopulas', 3, 'Fitting family %s.\n', family);
    fit.Family = family;
    
    % Preprocess data for some types of copulas
    if ismember(family, {'claytonhac*', 'gumbelhac*', 'frankhac*'})
        P = hac.preprocess( family(1:end-4), X, method );
        X = X * P;
        family = family(1:end-1);
    end
    
    % Obtain uniformed sample
    if strcmp(method, 'CML')
        U = uniform(X);
    elseif strcmp(method, 'IFM');
        margins = fitmargins(X);
        U = pit(X, {margins.ProbDist});
    else
        error('Method %s not recognized.', method);
    end
    
    % Fit copula to uniformed data
    copulaparams = copula.fit(family, U);
    dbg('fitcopulas', 3, 'Computing statistics.\n');    
    [ll, aic, bic, ks, aks, snc] = copula.stats(copulaparams, U);
    
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

