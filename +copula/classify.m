function [ TY ] = classify( family, TX, X, Y )
%COPULA.CLASSIFY 

% Obtain list of classes
C = unique(Y);
c = numel(C);

% Fit a copulas for each class
dbg('copulas.classify', 2, 'Fitting copulas for class.\n');
copulas = cell(c, 1);
for i=1:c
    copulas{i} = copula.fit(family, X(Y == C(i), :));
end

% Compute likelihood for test sample in each copula
L = zeros(size(TX, 1), c);
for i=1:c
    dbg('copulas.classify', 2, 'Computing likelihood for class %d.\n', i);
    L(:, i) = copula.pdf(copulas{i}, TX);
end

% Obtaines classes for the test samples
[~, m] = max(L, [], 2);
TY = C(m);

end

