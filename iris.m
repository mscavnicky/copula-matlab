%% Read data

dataset = 'Iris';
attributes = {'Sepal length', 'Sepal width', 'Petal length', 'Petal width'};
classes = {'Setosa', 'Versicolor', 'Virginica'};
folder = sprintf('../Results/%s', dataset);

data = dlmread('../Data/Iris/iris.data', ',');

X = data(:, 1:4);
Y = data(:, 5);

%% Fit copulas to data

for i=1:numel(classes) 
   margins = fitmargins(X(Y==i, :));
   cml = fitcopulas(X(Y==i, :), 'CML');
   ifm = fitcopulas(X(Y==i, :), 'IFM', margins);
   
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

results = classify(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');

%% Plot the classification

gen.cm2bar(folder, dataset);

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
