function [ confusionMatrix ] = crossval( family, method, X, Y, k )
%COPULA.CROSSVAL

dbg('copula.crossval', 2, 'Cross validation for family %s.\n', family);
% Reset random numbe generator to obtain same partitions every run
rng(42);

% Define classificication function
C = unique(Y);
classifyFun = @(X, Y, TX, TY) confusionmat(TY, copula.classify(family, method, TX, X, Y), 'order', C);

% Run stratified k-fold cross-validation
confusionMatrix = crossval(classifyFun, X, Y, 'kfold', k, 'stratify', Y);
confusionMatrix = reshape(sum(confusionMatrix), numel(C), numel(C));

end

