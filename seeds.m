%% Load data

data = csvread('../Data/Seeds/seeds.txt');
X = data(:, 1:7);
Y = data(:, 8);

U = uniform(X);
n = size(X, 1);

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

%% Examine the distributions of marginals

[~, PD1] = allfitdist(X(:,1)); % Generalized Pareto / Inverse Gaussian
[h, p] = kstest2(X(:,1), PD1{2}.random(n, 1))

[~, PD2] = allfitdist(X(:,2)); % Generalized Pareto / Inverse Gaussian
[h, p] = kstest2(X(:,2), PD2{3}.random(n, 1))

[~, PD3] = allfitdist(X(:,3)); % t-locationscale
[h, p] = kstest2(X(:,3), PD3{1}.random(n, 1))

[~, PD4] = allfitdist(X(:,4)); % t-locationscale
[h, p] = kstest2(X(:,4), PD4{1}.random(n, 1))

[~, PD5] = allfitdist(X(:,5)); % t-locationscale
[h, p] = kstest2(X(:,5), PD5{1}.random(n, 1))

[~, PD6] = allfitdist(X(:,6)); % Gamma
[h, p] = kstest2(X(:,6), PD6{4}.random(n, 1))

[~, PD7] = allfitdist(X(:,7)); % t-locationscale
[h, p] = kstest2(X(:,7), PD7{1}.random(n, 1))

%% Visualize dependency using HAC

claytonTree = hac.fit('clayton', U);
hac.plot(claytonTree);

gumbelTree = hac.fit('gumbel', U);
hac.plot(gumbelTree);

frankTree = hac.fit('frank', U);
hac.plot(frankTree);

%% Perform Fit using IFM

S = pit(X, {'inversegaussian', 'inversegaussian', 'tlocationscale', 'tlocationscale', 'tlocationscale', 'gamma', 'tlocationscale'});
plotmatrix(S);

copula.eval('gaussian', S, 1000);
copula.eval('t', S, 10);
copula.eval('clayton', S, 100);
copula.eval('gumbel', S, 100);
copula.eval('frank', S, 100);
copula.eval('claytonhac', S, 0, 'okhrin');
copula.eval('gumbelhac', S, 0, 'okhrin');
copula.eval('frankhac', S, 0, 'okhrin');

%% Perform Fit using CFM

copula.eval('gaussian', U, 1000);
copula.eval('t', U, 20, 'approximateml');
copula.eval('clayton', U, 100);
copula.eval('gumbel', U, 100);
copula.eval('frank', U, 100);
copula.eval('claytonhac', U, 0, 'okhrin');
copula.eval('gumbelhac', U, 0, 'okhrin');
copula.eval('frankhac', U, 0, 'okhrin');