%% Read data

dataset = 'Iris';
attributes = {'Sepal length', 'Sepal width', 'Petal length', 'Petal width'};
classes = {'Setosa', 'Versicolor', 'Virginica'};
folder = sprintf('../Results/%s', 'Iris');

data = dlmread('../Data/Iris/iris.data', ',');

X = data(:, 1:4);
Y = data(:, 5);

%% Fit copulas to data

for i=1:3   
   margins = fitmargins(X(Y==i, :));
   cml = fitcopulas(X(Y==i, :), 'CML');
   ifm = fitcopulas(X(Y==i, :), 'IFM', {margins.DistName});
   
   class = classes{i};
   filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cml', 'ifm');
end

%% Generate thesis materials

gen.margins2table(folder, dataset, attributes, classes);

for i=1:numel(classes)  
    gen.fit2table(folder, dataset, classes{i});
    gen.fit2bars(folder, dataset, classes{i});
end

%% Generate tree plots

for i=1:numel(classes)
   U = uniform(X(Y==i, :));
   tree = hac.fit('frank', U, 'okhrin*');
   filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
   hac.plot('frank', tree, attributes, filename);    
end

%% Perform classificatin experiment

ifmCm = cell(11, 1);
cmlCm = cell(11, 1);
families = {...
    'gaussian' 't' 'clayton' 'frank' 'gumbel'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'};
for i=1:numel(families)
    cmlCm{i} = copula.crossval(families{i}, 'CML', X, Y, 10);
    ifmCm{i} = copula.crossval(families{i}, 'IFM', X, Y, 10);   
end

%% Plot the classification

gen.cm2table('../Results', 'Iris', 'CML', cmlCm);
gen.cm2table('../Results', 'Iris', 'IFM', ifmCm);


%% Trees

U = uniform(X);

claytonTree = hac.fit('clayton', U, 'plot');
hac.plot('clayton', claytonTree, attributes);

gumbelTree = hac.fit('gumbel', U, 'okhrin');
hac.plot('gumbel', gumbelTree, attributes);

frankTree = hac.fit('frank', U, 'okhrin');
hac.plot('frank', frankTree, attributes);
