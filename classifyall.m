function [ results ] = classifyall( X, Y )
%CLASSIFYALL 

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
%CLASSIFICATIONRESULTS Given a copula family, fitting method and input
%sample, peforms cross-validation of the input data using classifier based
%on copulas and returns a struct of results of the classification.

confus = copulaCrossval(family, method, X, Y, 10);

result.Family = family;
result.Method = method;
result.Confus = confus;
result.Correct = sum(confus(eye(size(confus)) == 1));
result.Incorrect = sum(confus(eye(size(confus)) == 0));
end


function [ confus ] = copulaCrossval( family, method, X, Y, k )
%COPULACROSSVAL Given a copula family, fitting method and an input sample
%runs k-fold cross-validation of the input data using classifier based on
%copulas and returns a confusion matrix for the classification.

dbg('copula.crossval', 2, 'Cross validation for family %s.\n', family);

% Reset random number generator to obtain same partitions every run
rng(42);

% Run stratified k-fold cross-validation
fun = @(X, Y, TX, TY) classifyfun(family, method, X, Y, TX, TY);
results = crossval(fun, X, Y, 'kfold', k, 'stratify', Y);

% Transform results of cross-validation to single confusion matrix
c = numel(unique(Y));
confus = reshape(sum(results), c, c);
end


function [ confusionMatrix ] = classifyfun(family, method, X, Y, TX, TY)
%CLASSIFYFUN Wrapper over classifier based on copulas (copulacls) for
%MATLAB's crossval method.
TYhat = copulacls(family, method, TX, X, Y);
confusionMatrix = confusionmat(TY, TYhat, 'order', unique(Y));
end

