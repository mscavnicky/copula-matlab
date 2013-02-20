%% Load red wine data

names = {...
    'fixed acidity',...
    'volatile acidity',...
    'citric acid',...
    'residual sugar',...
    'chlorides',...
    'free SO^2',...
    'total SO^2',...
    'density',...
    'pH',...
    'sulphates',...
    'alcohol'};

data = csvread('../Data/Wine/winequality-red.csv');

X = data(:,1:11);
Y = data(:,12);
U = uniform(X);

dists = {...
    'inversegaussian',...
    'gamma',...
    'exponential',...
    'tlocationscale',...
    'tlocationscale',...
    'gamma',...
    'inversegaussian',...
    'loglogistic',...
    'loglogistic',...
    'loglogistic',...
    'inversegaussian'};
S = pit(X, dists);    

[n, d] = size(X);

%% Histograms

hist(X(:,1), 20);
hist(X(:,2), 20);
hist(X(:,3), 20);
hist(X(:,4), 20);
hist(X(:,5), 20);
hist(X(:,6), 20);
hist(X(:,7), 20);
hist(X(:,8), 20);
hist(X(:,9), 20);
hist(X(:,10), 20);
hist(X(:,11), 20);
hist(Y, 20);

%% Asses fit of the margins

[ dists, pvalues ] = fitmargins(X);

%% Scatter visualizations

plotmatrix(S);
plotmatrix(U);
plotmatrix(X);
plotmatrix(P);

%% Fit copulas using CML in 11 dimensions

copula.eval('gaussian', U, 100);
copula.eval('t', U, 10);
copula.eval('clayton', U, 100);
copula.eval('gumbel', U, 10);
copula.eval('frank', U, 100);


%% Fit copulas

X = X(:, [1:3,5:9,11]);

% Does not make sense fitting class 3 as there is only 10 elements
fitcopulas(X(Y==4, :), 'CML')
fitcopulas(X(Y==5, :), 'CML')
fitcopulas(X(Y==6, :), 'CML')
fitcopulas(X(Y==7, :), 'CML')

fitcopulas(X(Y==4, :), 'IFM')
fitcopulas(X(Y==5, :), 'IFM')
fitcopulas(X(Y==6, :), 'IFM')
fitcopulas(X(Y==7, :), 'IFM')

%% Hierarchy of dependency

claytonTree = hac.fit('clayton', U, 'plot');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'plot');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'plot');
hac.plot('frank', frankTree, names);

joeTree = hac.fit('joe', U);
hac.plot('joe', joeTree, names);

%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);


%% Decision trees

tree = classregtree(X, Y, 'method', 'classification', 'names', names, 'minleaf', 10);
view(tree);