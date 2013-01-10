%% Load data

data = csvread('../Data/seeds.txt');
X = data(:, 1:7);
Y = data(:, 8);

U = uniform(X);

%% Histograms

hist(X(:,1),20);
hist(X(:,2),20);
hist(X(:,3),100);
hist(X(:,4),20);
hist(X(:,5),20);
hist(X(:,6),20);
hist(X(:,7),20);

%% Histograms of uniformed data

hist(U(:,1));
hist(U(:,2));
hist(U(:,3));
hist(U(:,4));
hist(U(:,5));
hist(U(:,6));
hist(U(:,7));

%% Perform Fit using CFM

copula.eval('gaussian', U, 100);
copula.eval('t', U, 10);
copula.eval('clayton', U, 100);
copula.eval('gumbel', U, 100);
copula.eval('frank', U, 100);
copula.eval('claytonhac', U, 0, 'okhrin');
copula.eval('gumbelhac', U, 0, 'okhrin');
copula.eval('frankhac', U, 0, 'okhrin');