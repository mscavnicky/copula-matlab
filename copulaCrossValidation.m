function [ confusionMatrix ] = copulaCrossValidation( family, method, X, Y, k )
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
confusionMatrix = reshape(sum(results), c, c);
end


function [ confusionMatrix ] = classifyfun(family, method, X, Y, TX, TY)
%CLASSIFYFUN Wrapper over classifier based on copulas (copulacls) for
%MATLAB's crossval method.
TYhat = copulaClassification(family, method, TX, X, Y);
confusionMatrix = confusionmat(TY, TYhat, 'order', unique(Y));
end