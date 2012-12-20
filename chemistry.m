%% Load the data

data = importdata('../Data/scavnicky.mat');
data = data(:, [1 2 6 7]);

Y1 = data(:,1);
Y2 = data(:,2);
X1 = data(:,3);
X2 = data(:,4);

Y = [Y1 Y2];
X = [X1 X2];

%% Historgrams

hist(Y1);
hist(Y2);
hist(X1, 100);
hist(X2, 100);

%% Correlations

corrPearson = corr(data);
corrSpearman = corr(data, 'type', 'spearman');
corrKendall = corr(data, 'type', 'kendall');

%% Distributions

% Question is how to perform F^{-1}
U = uniform(data);
UX = uniform(X);
UY = uniform(Y);

%% Uniformed histograms

%Histograms for U3 and U4 is deformed
hist(U(:,1));
hist(U(:,2));
hist(U(:,3));
hist(U(:,4));

%% Fit copulas

% Data are not suitable for copulas
% GOF's are zero
copula.eval('gaussian', U, 100);
copula.eval('t', U, 0);
% Archimedean copulas, have even positive likelihoods
copula.eval('clayton', U, 1000);
copula.eval('gumbel', U, 1000);
copula.eval('frank', U, 1000);
% Clayton HAC seems to uncover some structure
copula.eval('claytonhac', U, 0, 'okhrin');
copula.eval('gumbelhac', U, 10, 'okhrin');
copula.eval('frankhac', U, 0, 'okhrin');

% GOF's are zero, Gumbel gives 0.05 p-value
copula.eval('gaussian', UY, 1000);
copula.eval('t', UY, 10);
copula.eval('clayton', UY, 1000);
copula.eval('gumbel', UY, 1000);
copula.eval('frank', UY, 1000);

copula.eval('gaussian', UX, 1000);
copula.eval('t', UX, 10);
copula.eval('clayton', UX, 1000);
copula.eval('gumbel', UX, 1000);
copula.eval('frank', UX, 1000);
