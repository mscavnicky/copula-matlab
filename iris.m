%% Read data

data = dlmread('../Data/Iris/iris.data', ',');

X = data(:, 1:4);
Y = data(:, 5);

U = uniform(X);

%% Fit copulas using CML

U = U(Y==3,:);

copula.eval('gaussian', U, 0);
copula.eval('t', U, 0);
copula.eval('clayton', U, 100);
copula.eval('gumbel', U, 100);
copula.eval('frank', U, 100);
copula.eval('claytonhac', U, 0, 'okhrin');
copula.eval('gumbelhac', U, 0, 'okhrin');
copula.eval('frankhac', U, 0, 'okhrin');


