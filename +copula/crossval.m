function [ M ] = crossval( family, method, X, Y, k )
%COPULA.CROSSVAL

dbg('copula.crossval', 2, 'Cross validation for family %s.\n', family);

% Reset random numbe generator to obtain same partition every time
rng(42);

% Find existing classes
C = unique(Y);
classifyFun = @(X, Y, TX, TY) confusionmat(TY, copula.classify(family, method, TX, X, Y), 'order', C);

% Run cross-validation
M = crossval(classifyFun, X, Y, 'kfold', k, 'stratify', Y);
M = reshape(sum(M), 3, 3);

end

