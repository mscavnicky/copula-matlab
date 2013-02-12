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
    'tlocationscale',...
    'tlocationscale',...
    'inversegaussian',...
    'inversegaussian'};
S = pit(X, dists);
    

[n, d] = size(X);

P = X + repmat(std(X), n, 1) .* normrnd(0, 0.001, n, d);
P = uniform(P);

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

% fixed acidity
[D1, PD1] = allfitdist(X(:,1)); % NO (Inverse Gaussian)
[h, p] = kstest2(X(:,1), PD1{2}.random(n, 1))

% volatile acidity
[D2, PD2] = allfitdist(X(:,2)); % Gamma distribution
[h, p] = kstest2(X(:,2), PD2{1}.random(n, 1))

% citric acid
[D3, PD3] = allfitdist(X(:,3)); % NO (Exponential)
[h, p] = kstest2(X(:,3), PD3{2}.random(n, 1))

% residual sugar
[D4, PD4] = allfitdist(X(:,4)); % NO (tlocationscale)
[h, p] = kstest2(X(:,4), PD4{2}.random(n, 1))

% chlorides
[D5, PD5] = allfitdist(X(:,5)); % tlocationscale
[h, p] = kstest2(X(:,5), PD5{1}.random(n, 1))

% free SO2
[D6, PD6] = allfitdist(X(:,6)); % NO (Gamma)
[h, p] = kstest2(X(:,6), PD6{2}.random(n, 1))

% total SO2
[D7, PD7] = allfitdist(X(:,7)); % Inverse gaussian
[h, p] = kstest2(X(:,7), PD7{2}.random(n, 1))

% density
[D8, PD8] = allfitdist(X(:,8)); % t
[h, p] = kstest2(X(:,8), PD8{3}.random(n, 1))

% pH
[D9, PD9] = allfitdist(X(:,9)); % t
[h, p] = kstest2(X(:,9), PD9{3}.random(n, 1))

% sulphates
[D10, PD10] = allfitdist(X(:,10)); % Inverse Gaussian / Generalized Extreme Value
[h, p] = kstest2(X(:,10), PD10{4}.random(n, 1))

% alcohol
[D11, PD11] = allfitdist(X(:,11)); % NO Inverse Gaussian / Generalized Extreme Value
[h, p] = kstest2(X(:,11), PD11{1}.random(n, 1))


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


%% Fit copulas using CFL in 9 dimensions
% Drop sulphates (independent) and residuals sugar (too sparse)

Q = U(:, [1:3,5:9,11]);

writefit('wine-fit.csv', 'CFM', copula.eval('gaussian', Q, 1000));
writefit('wine-fit.csv', 'CFM', copula.eval('t', Q, 1000));
writefit('wine-fit.csv', 'CFM', copula.eval('clayton', Q, 100));
writefit('wine-fit.csv', 'CFM', copula.eval('gumbel', Q, 100));
writefit('wine-fit.csv', 'CFM', copula.eval('frank', Q, 100));
writefit('wine-fit.csv', 'CFM', copula.eval('claytonhac', Q, 0, 'okhrin'));
writefit('wine-fit.csv', 'CFM', copula.eval('gumbelhac', Q, 0, 'okhrin'));
writefit('wine-fit.csv', 'CFM', copula.eval('frankhac', Q, 0, 'okhrin'));


%% Fit copulas using IFM in 9 dimensions
% Drop sulphates (independent) and residuals sugar (too sparse)

Q = S(:, [1:3,5:9,11]);

writefit('wine-fit.csv', 'IFM', copula.eval('gaussian', Q, 1000));
writefit('wine-fit.csv', 'IFM', copula.eval('t', Q, 1000));
writefit('wine-fit.csv', 'IFM', copula.eval('clayton', Q, 100));
writefit('wine-fit.csv', 'IFM', copula.eval('gumbel', Q, 100));
writefit('wine-fit.csv', 'IFM', copula.eval('frank', Q, 100));
writefit('wine-fit.csv', 'IFM', copula.eval('claytonhac', Q, 0, 'okhrin'));
writefit('wine-fit.csv', 'IFM', copula.eval('gumbelhac', Q, 0, 'okhrin'));
writefit('wine-fit.csv', 'IFM', copula.eval('frankhac', Q, 0, 'okhrin'));



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

%% Correlations

matrix2latex(corr(U), '../Data/Wine/corr.tex', 'format', '%.3f', 'rowLabels', names, 'columnLabels', names);



