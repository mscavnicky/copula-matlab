%% Read data

data = dlmread('../Data/Iris/iris.data', ',');

names = {'sepal length', 'sepal width', 'petal length', 'petal width'};

X = data(:, 1:4);
Y = data(:, 5);

U = uniform(X);


%% Plot matrix

plotmatrix(X);

%% Trees

claytonTree = hac.fit('clayton', U, 'okhrin');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'okhrin');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'okhrin');
hac.plot('frank', frankTree, names);

%% Fit copulas

fitcopulas(X(Y==1, :), 'CML')
fitcopulas(X(Y==2, :), 'CML')
fitcopulas(X(Y==3, :), 'CML')

fitcopulas(X(Y==1, :), 'IFM')
fitcopulas(X(Y==2, :), 'IFM')
fitcopulas(X(Y==3, :), 'IFM')

