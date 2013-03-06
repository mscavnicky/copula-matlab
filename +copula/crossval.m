function [ M ] = crossval( family, method, X, Y, k )
%COPULA.CROSSVAL

dbg('copula.crossval', 2, 'Cross validation for family %s.\n', family);

% Find existing classes
C = unique(Y);

% Reset random numbe generator to obtain same partition every time
rng(42);
% Split data into k stratified partitions
P = cvpartition(Y, 'k', k);

classifyFun = @(X, Y, TX, TY) confusionmat(TY, copula.classify(family, method, TX, X, Y), 'order', C);

M = crossval(classifyFun, X, Y, 'partition', P);
M = reshape(sum(M), 3, 3);

end

