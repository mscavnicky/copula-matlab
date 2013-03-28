function [ confusionMatrix ] = crossval( family, method, X, Y, k )
%COPULA.CROSSVAL

dbg('copula.crossval', 2, 'Cross validation for family %s.\n', family);

% Reset random numbe generator to obtain same partitions every run
rng(42);
% Run stratified k-fold cross-validation
fun = @(X, Y, TX, TY) classifyAndTest(family, method, X, Y, TX, TY);
confusionMatrix = crossval(fun, X, Y, 'kfold', k, 'stratify', Y);

% Reshape confusion matrix
numClasses = numel(unique(Y));
% Perform sum of confusion matrices from all the runs
confusionMatrix = reshape(sum(confusionMatrix), numClasses, numClasses);

end

function [ confusionMatrix ] = classifyAndTest(family, method, X, Y, TX, TY)
    K = unique(Y);    
    TYhat = copula.classify(family, method, TX, X, Y);
    confusionMatrix = confusionmat(TY, TYhat, 'order', K);
end

