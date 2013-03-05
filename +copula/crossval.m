function [ M ] = crossval( family, U, Y, k )
%COPULA.CROSSVAL

% Find existing classes
C = unique(Y);
% Split data into partitions
P = cvpartition(Y, 'k', k);

f = @(X, Y, TX, TY) confusionmat(TY, copula.classify(family, TX, X, Y), 'order', C);

M = crossval(f, U, Y, 'partition', P);
M = reshape(sum(M), 3, 3);

end

