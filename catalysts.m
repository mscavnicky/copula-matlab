%% Load the data

data = double(importdata('../Data/Catalysts/catalysts.mat'));

X = data(:, 15:23);
Y1 = data(:, 1);
Y2 = data(:, 2);

U = uniform(X);

%% Plotmatrix

plotmatrix(U)

%% Fit marginal distributions

allDists = cell(3, 1);
allPValues = cell(3, 1);

for i=1:3
    [dists, pvalues] = fitmargins(X(Y1 < 7.3, :));
    allDists{i} = dists;
    allPValues{i} = pvalues;
end

cmlFits{i} = fitcopulas(X(Y1 < 7.3, :), 'CML');



