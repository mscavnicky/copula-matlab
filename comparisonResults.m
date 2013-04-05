function [ fits ] = comparisonResults( X, method )
%COMPARISONRESULTS Fits all possible copulas functions to sample U and
%returns results of all fits. Method can be either CML or IFM.

dbg('fitcopulas', 1, 'Fiting copulas using %s method.\n', method);
dbg('fitcopulas', 2, 'Uniforming data.\n');

families = {...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'};

for i=1:numel(families)
    fits(i) = fitCopula( families{i}, X, method ); %#ok<AGROW>
end

end



