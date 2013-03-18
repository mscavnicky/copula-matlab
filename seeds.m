%% Load data

dataset = 'Seeds';
attributes = {'Area', 'Perimeter', 'Compactness', 'Length', 'Width', 'Assymetry', 'Groove Length'};
classes = {'Kama', 'Rosa', 'Canadian'};
folder = sprintf('../Results/%s', dataset);

data = csvread('../Data/Seeds/seeds.txt');

X = data(:, 1:7);
Y = data(:, 8);

%% Fit copulas to data

for i=1:numel(classes)  
   margins = fitmargins(X(Y==i, :));
   cml = fitcopulas(X(Y==i, :), 'CML');
   ifm = fitcopulas(X(Y==i, :), 'IFM', margins);
   
   class = classes{i};
   filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cml', 'ifm');
end

%% Generate tree plots

for i=1:numel(classes)
   U = uniform(X(Y==i, :));
   tree = hac.fit('frank', U, 'okhrin*');
   filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
   hac.plot('frank', tree, attributes, filename);    
end

%% Produce classification results

results = classify(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');

%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);