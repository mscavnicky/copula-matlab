%% Load data

names = {'area', 'perimeter', 'compactness', 'length', 'width', 'assymetry', 'groove'};

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

claytonTree = hac.fit('clayton', U, 'okhrin');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'plot');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'plot');
hac.plot('frank', frankTree, names);

%% Fit copulas

fitcopulas(X(Y==1, :), 'CML')
fitcopulas(X(Y==2, :), 'CML')
fitcopulas(X(Y==3, :), 'CML')

fitcopulas(X(Y==1, :), 'IFM')
fitcopulas(X(Y==2, :), 'IFM')
fitcopulas(X(Y==3, :), 'IFM')


%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);