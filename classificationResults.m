function [ results ] = classificationResults( X, Y )
%CLASSIFICATIONRESULTS Given an input sample performs k-fold
%cross-validation for 12 copula familes and 2 fitting methods. Returns
%struct array of results.

%#ok<*AGROW>

families = {...
    'independent',...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'
};

numFamilies = numel(families);

% Perform cross-validaton of all families using CML
for i=1:numFamilies
    family = families{i};
    results(i) = crossvalResults(family, 'CML', X, Y); 
end

% Perform cross-validaton of all families using IFM
for i=1:numFamilies
    family = families{i};
    results(i+numFamilies) = crossvalResults(family, 'IFM', X, Y);
end

end

function [ result ] = crossvalResults( family, method, X, Y )
%CROSSVALRESULTS Given a copula family, fitting method and input
%sample, peforms cross-validation of the input data using classifier based
%on copulas and returns a struct of results of the classification.

confus = copulaCrossValidation(family, method, X, Y, 10);

result.Family = family;
result.Method = method;
result.Confus = confus;
result.Correct = sum(confus(eye(size(confus)) == 1));
result.Incorrect = sum(confus(eye(size(confus)) == 0));
end




