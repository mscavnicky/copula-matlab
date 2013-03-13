function [ results ] = classify( X, Y )
%CLASSIFY Performs dataset classification using all copula families

families = {...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'};
numFamilies = numel(families);

for i=1:numFamilies
    family = families{i};
    confus = copula.crossval(family, 'CML', X, Y, 10);    
    
    results(i).Family = family;
    results(i).Method = 'CML';
    results(i).Confus = confus;
    results(i).Correct = sum(confus(eye(size(confus)) == 1));
    results(i).Incorrect = sum(confus(eye(size(confus)) == 0));    
end

for i=1:numFamilies
    family = families{i};
    confus = copula.crossval(family, 'IFM', X, Y, 10);    
    
    results(i+numFamilies).Family = family;
    results(i+numFamilies).Method = 'IFM';
    results(i+numFamilies).Confus = confus;
    results(i+numFamilies).Correct = sum(confus(eye(size(confus)) == 1));
    results(i+numFamilies).Incorrect = sum(confus(eye(size(confus)) == 0));    
end

end

