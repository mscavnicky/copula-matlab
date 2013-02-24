%% Load the data

data = double(importdata('../Data/Catalysts/catalysts.mat'));
dataset = 'Catalysts';
names = {'Mg', 'La', 'Sr', 'Ba', 'Na', 'Cs', 'Li', 'Mn', 'W'};
classnames = {'1', '2', '3'};

X = data(:, 15:23);

Y1 = toclasses(data(:, 1), 3);
Y2 = toclasses(data(:, 2), 3);

U = uniform(X);

%% Plotmatrix

plotmatrix(U)

%% Fit marginal distributions

allDists = cell(3, 1);
allPValues = cell(3, 1);

for i=1:3
    [dists, pvalues] = fitmargins(X(Y2==i, :));
    allDists{i} = dists;
    allPValues{i} = pvalues;
end

alldists2table('../Results', allDists, allPValues, names, dataset, classnames);

%% Fit copulas

ifmFits = cell(3, 1);
cmlFits = cell(3, 1);
for i=1:3
    cmlFits{i} = fitcopulas(X(Y2==i, :), 'CML');
end

%% Produce results

for i=1:3    
    fit2table('../Results', cmlFits{i}, cmlFits{i}, dataset, i, classnames{i});
    fit2bars('../Results', cmlFits{i}, cmlFits{i}, dataset, i, classnames{i});
end

%% Produce trees

for i=1:3
   U = uniform(X(Y2==i, :));
   tree = hac.fit('gumbel', U, 'plot');
   filename = sprintf('../Results/%s-%d-tree.pdf', dataset, i);
   hac.plot('gumbel', tree, names, filename);    
end




