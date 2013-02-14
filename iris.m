%% Read data

data = dlmread('../Data/Iris/iris.data', ',');

names = {'sepal length', 'sepal width', 'petal length', 'petal width'};

X = data(:, 1:4);
Y = data(:, 5);

U = uniform(X);

dists = {'inversegaussian', 'gamma', 'normal', 'gamma'};
S = pit(X, dists);

%% Plot matrix

plotmatrix(X);

%% Examine the distributions of marginals

[~, PD1] = allfitdist(X(:,1)); % Inverse Gaussian
[h, p] = kstest2(X(:,1), PD1{1}.random(n, 1))

[D, PD2] = allfitdist(X(:,2)); % Gamma
[h, p] = kstest2(X(:,2), PD2{1}.random(n, 1))

[~, PD3] = allfitdist(X(:,3)); % NO Normal
[h, p] = kstest2(X(:,3), PD3{8}.random(n, 1))

[~, PD4] = allfitdist(X(:,4)); % NO Gamma
[h, p] = kstest2(X(:,4), PD4{4}.random(n, 1))

%% Trees

claytonTree = hac.fit('clayton', U, 'plot');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'plot');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'plot');
hac.plot('frank', frankTree, names);

%% Fit copulas using CML

writefit('iris-fit.csv', 'CML', copula.eval('gaussian', U, 1000));
writefit('iris-fit.csv', 'CML', copula.eval('t', U, 100, 'approximateml'));
writefit('iris-fit.csv', 'CML', copula.eval('clayton', U, 100));
writefit('iris-fit.csv', 'CML', copula.eval('gumbel', U, 100));
writefit('iris-fit.csv', 'CML', copula.eval('frank', U, 100));
writefit('iris-fit.csv', 'CML', copula.eval('claytonhac', U, 0, 'okhrin'));
writefit('iris-fit.csv', 'CML', copula.eval('gumbelhac', U, 0, 'okhrin'));
writefit('iris-fit.csv', 'CML', copula.eval('frankhac', U, 0, 'okhrin'));

%% Fit copulas using IFM

writefit('iris-fit.csv', 'IFM', copula.eval('gaussian', S, 0));
writefit('iris-fit.csv', 'IFM', copula.eval('t', S, 0, 'approximateml'));
writefit('iris-fit.csv', 'IFM', copula.eval('clayton', S, 0));
writefit('iris-fit.csv', 'IFM', copula.eval('gumbel', S, 0));
writefit('iris-fit.csv', 'IFM', copula.eval('frank', S, 0));
writefit('iris-fit.csv', 'IFM', copula.eval('claytonhac', S, 0, 'okhrin'));
writefit('iris-fit.csv', 'IFM', copula.eval('gumbelhac', S, 0, 'okhrin'));
writefit('iris-fit.csv', 'IFM', copula.eval('frankhac', S, 0, 'okhrin'));
