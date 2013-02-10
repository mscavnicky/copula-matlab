%% Load data

names = {'area', 'perimeter', 'compactness', 'length', 'width', 'assymetry', 'groove'};

data = csvread('../Data/Seeds/seeds.txt');
X = data(:, 1:7);
Y = data(:, 8);

n = size(X, 1);

U = uniform(X);
S = pit(X, {'inversegaussian', 'inversegaussian', 'normal', 'inversegaussian', 'inversegaussian', 'gamma', 'inversegaussian'});

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

[~, PD1] = allfitdist(X(:,1)); % Inverse Gaussian
[h, p] = kstest2(X(:,1), PD1{2}.random(n, 1))

[D, PD2] = allfitdist(X(:,2)); % Inverse Gaussian
[h, p] = kstest2(X(:,2), PD2{3}.random(n, 1))

[~, PD3] = allfitdist(X(:,3)); % Normal
[h, p] = kstest2(X(:,3), PD3{6}.random(n, 1))

[~, PD4] = allfitdist(X(:,4)); % Inverse Gaussian
[h, p] = kstest2(X(:,4), PD4{3}.random(n, 1))

[~, PD5] = allfitdist(X(:,5)); % Inverse Gaussian
[h, p] = kstest2(X(:,5), PD5{3}.random(n, 1))

[~, PD6] = allfitdist(X(:,6)); % Gamma
[h, p] = kstest2(X(:,6), PD6{4}.random(n, 1))

[~, PD7] = allfitdist(X(:,7)); % Generalized Extreme Value
[h, p] = kstest2(X(:,7), PD7{1}.random(n, 1))

%% Visualize dependency using HAC

claytonTree = hac.fit('clayton', U, 'plot');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'plot');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'plot');
hac.plot('frank', frankTree, names);

%% Perform Fit using CFM

writefit('seeds-fit.csv', 'CML', copula.eval('gaussian', U, 1000));
writefit('seeds-fit.csv', 'CML', copula.eval('t', U, 1000, 'ml'));
writefit('seeds-fit.csv', 'CML', copula.eval('clayton', U, 1000));
writefit('seeds-fit.csv', 'CML', copula.eval('gumbel', U, 1000));
writefit('seeds-fit.csv', 'CML', copula.eval('frank', U, 1000));
writefit('seeds-fit.csv', 'CML', copula.eval('claytonhac', U, 0, 'okhrin'));
writefit('seeds-fit.csv', 'CML', copula.eval('gumbelhac', U, 0, 'okhrin'));
writefit('seeds-fit.csv', 'CML', copula.eval('frankhac', U, 0, 'okhrin'));

%% Perform Fit using IFM

writefit('seeds-fit.csv', 'IFM', copula.eval('gaussian', S, 1000));
writefit('seeds-fit.csv', 'IFM', copula.eval('t', S, 1000, 'ml'));
writefit('seeds-fit.csv', 'IFM', copula.eval('clayton', S, 1000));
writefit('seeds-fit.csv', 'IFM', copula.eval('gumbel', S, 1000));
writefit('seeds-fit.csv', 'IFM', copula.eval('frank', S, 1000));
writefit('seeds-fit.csv', 'IFM', copula.eval('claytonhac', S, 0, 'okhrin'));
writefit('seeds-fit.csv', 'IFM', copula.eval('gumbelhac', S, 0, 'okhrin'));
writefit('seeds-fit.csv', 'IFM', copula.eval('frankhac', S, 0, 'okhrin'));

%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);