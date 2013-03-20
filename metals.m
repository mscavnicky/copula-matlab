%% Load the data

dataset = 'Metals';
attributes = {'La', 'Pt', 'Ag', 'Au'};
classes = {'T1', 'T2', 'T3'};
folder = sprintf('../Results/%s', dataset);

data = double(importdata('../Data/Metals/Metals.mat'));
X = data(:, 1:4);
Y = toclasses(data(:, 5), 3);

%% Fit copulas to data

for i=1:numel(classes) 
   margins = fitmargins(X(Y<=i, :));
   cml = fitcopulas(X(Y<=i, :), 'CML');
   ifm = fitcopulas(X(Y<=i, :), 'IFM', margins);
   
   class = classes{i};
   filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
   save(filename, 'dataset', 'class', 'attributes', 'margins', 'cml', 'ifm');
end

%% Generate trees

for i=1:numel(classes)
   U = uniform(X(Y<=i, :));
   tree = hac.fit('clayton', U, 'okhrin*');
   filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
   hac.plot('clayton', tree, attributes, filename);
end




