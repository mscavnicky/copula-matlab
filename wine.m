%% Load red wine data

names = {...
    'fixed acidity',...
    'volatile acidity',...
    'citric acid',...
    'residual sugar',...
    'chlorides',...
    'free SO2',...
    'total SO2',...
    'density',...
    'pH',...
    'sulphates',...
    'alcohol'};

data = csvread('../Data/winequality-red.csv');
n = size(data, 1);

X = data(:,1:11);
Y = data(:,12);
U = uniform(X);

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
[D4, PD4] = allfitdist(X(:,4)); % NO (loglogistic)
[h, p] = kstest2(X(:,4), PD4{3}.random(n, 1))

% chlorides
[D5, PD5] = allfitdist(X(:,5)); % t
[h, p] = kstest2(X(:,5), PD5{1}.random(n, 1))

% free SO2
[D6, PD6] = allfitdist(X(:,6)); % NO (Gamma)
[h, p] = kstest2(X(:,6), PD6{2}.random(n, 1))

% total SO2
[D7, PD7] = allfitdist(X(:,7)); % Lognormal
[h, p] = kstest2(X(:,7), PD7{3}.random(n, 1))

% density
[D8, PD8] = allfitdist(X(:,8)); % t
[h, p] = kstest2(X(:,8), PD8{3}.random(n, 1))

% pH
[D9, PD9] = allfitdist(X(:,9)); % t
[h, p] = kstest2(X(:,9), PD9{3}.random(n, 1))

% sulphates
[D10, PD10] = allfitdist(X(:,10)); % Generalized Extreme Value
[h, p] = kstest2(X(:,10), PD10{1}.random(n, 1))

% alcohol
[D11, PD11] = allfitdist(X(:,11)); % NO Generalized Extreme Value
[h, p] = kstest2(X(:,11), PD11{1}.random(n, 1))


%% Histograms

hist(data(:,1), 20);
hist(data(:,2), 20);
hist(data(:,3), 20);
hist(data(:,4), 20);
hist(data(:,5), 20);
hist(data(:,6), 20);
hist(data(:,7), 20);
hist(data(:,8), 20);
hist(data(:,9), 20);
hist(data(:,10), 20);
hist(data(:,11), 20);
hist(data(:,12), 20);

%% Fit copulas using CFM in 11 dimensions

f1 = copula.eval('gaussian', U, 100);
%f2 = copula.eval('t', U, 10); % Computationally infeasible
f3 = copula.eval('clayton', U, 100);
f4 = copula.eval('gumbel', U, 10);
f5 = copula.eval('frank', U, 100);

matrix2latex([f1;f3;f4;f5], 'fit.tex',...
'alignment', 'r', 'format', '%.3f',...
'rowLabels', {'Gaussian', 'Clayton', 'Gumbel', 'Frank'},...
'columnLabels', {'LL', 'AIC', 'BIC', 'SnC', 'SnB'});

%% Fit copulas using CFM in 4 dimensions
S = U(:, [2,5,7,8]);
S = X(:, [2,5,7,8]);
S = pit(S, {'gamma', 'tlocationscale', 'lognormal', 'tlocationscale'});

f1 = copula.eval('gaussian', S, 200);
f2 = copula.eval('t', S, 11);
f3 = copula.eval('clayton', S, 200);
f4 = copula.eval('gumbel', S, 200);
f5 = copula.eval('frank', S, 200);
f6 = copula.eval('claytonhac', S, 0, 'okhrin');
f7 = copula.eval('gumbelhac', S, 0, 'okhrin');
f8 = copula.eval('frankhac', S, 0, 'okhrin');

matrix2latex([f1;f2;f3;f4;f5;[f6, NaN, NaN];[f7 NaN NaN];[f8 NaN NaN]], 'fit.tex',...
'alignment', 'r', 'format', '%.3f',...
'rowLabels', {'Gaussian', 't', 'Clayton', 'Gumbel', 'Frank', 'Clayton HAC', 'Gumbel HAC', 'Frank HAC'},...
'columnLabels', {'LL', 'AIC', 'BIC', 'SnC', 'SnB'});

%% Hierarchy of dependency

%U(:,9) = 1 - U(:,9);
%U = 1 - U;

claytonTree = hac.fit('clayton', U);
hac.plot(claytonTree, names);

gumbelTree = hac.fit('gumbel', U);
hac.plot(gumbelTree, names);

frankTree = hac.fit('frank', U);
hac.plot(frankTree, names);

joeTree = hac.fit('joe', U);
hac.plot(joeTree, names);

%% Decision trees

tree = classregtree(X, Y, 'method', 'classification', 'names', names, 'minleaf', 10);
view(tree);

%% Correlations
matrix2latex(corr(U), '../Data/Wine/corr.tex', 'format', '%.3f', 'rowLabels', names, 'columnLabels', names);



