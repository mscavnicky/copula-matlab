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
   X_i = X(Y==i, :);
   [~, margins] = fitmargins(X_i);
   cml = comparisonResults(X_i, 'CML');
   ifm = comparisonResults(X_i, 'IFM');
   
   filename = sprintf('%s/%s-%s.mat', folder, dataset, classes{i});
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cml', 'ifm');
end

%% Generate tree plots

for i=1:numel(classes)
    filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
    plotHacTree('frank', X(Y==i, :), attributes, filename); 
end

%% Perform classification experiment

results = classificationResults(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');