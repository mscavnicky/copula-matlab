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
   ifm = fitcopulas(X(Y==i, :), 'IFM');
   
   class = classes{i};
   filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cml', 'ifm');
end

%% Generate tree plots

for i=1:numel(classes)
   hactree('frank', X(Y==i, :), folder, dataset, classes{i}, attributes); 
end

%% Produce classification results

results = classify(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');

