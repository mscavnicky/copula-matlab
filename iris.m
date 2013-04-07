%% Read data

dataset = 'Iris';
attributes = {'Sepal length', 'Sepal width', 'Petal length', 'Petal width'};
classes = {'Setosa', 'Versicolor', 'Virginica'};
folder = sprintf('../Results/%s', dataset);

data = dlmread('../Data/Iris/iris.txt', ',');

X = data(:, 1:4);
Y = data(:, 5);

%% Fit copulas to data

for i=1:numel(classes)
   X_i = X(Y==i, :);
   [~, margins] = fitMargins(X_i);
   cmlFits = comparisonResults(X_i, 'CML');
   ifmFits = comparisonResults(X_i, 'IFM');
   
   class = classes{i};
   filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cmlFits', 'ifmFits');
end

%% Generate tree plots

for i=1:numel(classes)
    filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
    plotHacTree('frank', X(Y==i, :), attributes, filename); 
end

%% Perform classification experiment

cmlResults = classificationResults(X, Y, 'CML');
ifmResults = classificationResults(X, Y, 'IFM');
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'cmlResults', 'ifmResults');