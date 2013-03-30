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
   margins = fitmargins(X_i);
   cml = fitcopulas(X_i, 'CML');
   ifm = fitcopulas(X_i, 'IFM');
   
   class = classes{i};
   filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cml', 'ifm');
end

%% Generate tree plots

for i=1:numel(classes)
   hactree('frank', X(Y==i, :), folder, dataset, classes{i}, attributes); 
end

%% Perform classificatin experiment

results = classify(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');