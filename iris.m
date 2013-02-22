%% Read data

dataset = 'Iris';
names = {'Sepal length', 'Sepal width', 'Petal length', 'Petal width'};
classnames = {'Iris Setosa', 'Iris Versicolor', 'Iris Virginica'};

data = dlmread('../Data/Iris/iris.data', ',');

X = data(:, 1:4);
Y = data(:, 5);

U = uniform(X);

%% Plot matrix

plotmatrix(X);

%% Trees

claytonTree = hac.fit('clayton', U, 'plot');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'okhrin');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'okhrin');
hac.plot('frank', frankTree, names);

%% Fit margins and generate tables

allDists = cell(3, 1);
allPValues = cell(3, 1);

for i=1:3
    [dists, pvalues] = fitmargins(X(Y==i, :));
    allDists{i} = dists;
    allPValues{i} = pvalues;
end

alldists2table('../Results', allDists, allPValues, names, dataset, classnames);

%% Fit copulas

ifmFits = cell(3, 1);
cmlFits = cell(3, 1);
for i=1:3
    cmlFits{i} = fitcopulas(X(Y==i, :), 'CML');
    ifmFits{i} = fitcopulas(X(Y==i, :), 'IFM', allDists{i});
end


%% Produce results

for i=1:3    
    fit2table('../Results', cmlFits{i}, ifmFits{i}, dataset, i, classnames{i});
    fit2bars('../Results', cmlFits{i}, ifmFits{i}, dataset, i, classnames{i});
end

%% Produce trees

for i=1:3
   U = uniform(X(Y==i, :));
   tree = hac.fit('gumbel', U, 'plot');
   filename = sprintf('../Results/%s-%d-tree.pdf', 'Iris', i);
   hac.plot('gumbel', tree, names, filename);    
end




