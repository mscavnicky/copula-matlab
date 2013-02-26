%% Load data

dataset = 'Seeds';
names = {'Area', 'Perimeter', 'Compactness', 'Length', 'Width', 'Assymetry', 'Groove'};
classnames = {'Kama', 'Rosa', 'Canadian'};

data = csvread('../Data/Seeds/seeds.txt');
X = data(:, 1:7);
Y = data(:, 8);

n = size(X, 1);

U = uniform(X);
S = pit(X, {'inversegaussian', 'inversegaussian', 'weibull', 'inversegaussian', 'inversegaussian', 'weibull', 'inversegaussian'});

%% Histograms

hist(X(:,1),100);
hist(X(:,2),100);
hist(X(:,3),100);
hist(X(:,4),100);
hist(X(:,5),100);
hist(X(:,6),100);
hist(X(:,7),100);

%% Histograms of uniformed data

hist(U(:,1));
hist(U(:,2));
hist(U(:,3));
hist(U(:,4));
hist(U(:,5));
hist(U(:,6));
hist(U(:,7));

%% Plot all scatters

plotmatrix(U);
plotmatrix(S);

%% Examine the distributions of marginals

[ dists, pvalues ] = fitmargins(X);

%% Visualize dependency using HAC

claytonTree = hac.fit('clayton', U, 'plot');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'plot');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'plot');
hac.plot('frank', frankTree, names);

%% Fit margins and generate table

allDists = cell(3, 1);
allPValues = cell(3, 1);

for i=1:3
    [dists, pvalues] = fitmargins(X(Y==i, :));
    allDists{i} = dists;
    allPValues{i} = pvalues;
end

alldists2table('../Results', allDists, allPValues, names, dataset, classnames);

%% Fit copulas

cmlFits = cell(3, 1);
ifmFits = cell(3, 1);

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
   filename = sprintf('../Results/%s-%d-tree.pdf', 'Seeds', i);
   hac.plot('gumbel', tree, names, filename);    
end


%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);