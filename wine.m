%% Load red wine data

data = csvread('../Data/winequality-red.csv');

X = data(:,1:11);
Y = data(:,12);

U = uniform(X);

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

%% Fit copulas using CFM

copula.eval('gaussian', U, 100);
copula.eval('t', U, 10);
copula.eval('clayton', U, 100);
copula.eval('gumbel', U, 10);
copula.eval('frank', U, 100);
copula.eval('claytonhac', U, 0, 'okhrin');
copula.eval('gumbelhac', U, 10, 'okhrin');