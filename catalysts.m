%% Load the data

dataset = 'Chemistry';
attributes = {'X', 'Y'};
classes = {'T1', 'T2', 'T3'};
folder = sprintf('../Results/%s', dataset);

data = double(importdata('../Data/Chemistry/chemistry.mat'));
X = data(:, 6:7);
Y1 = toclasses(data(:, 1), 3);
Y2 = toclasses(data(:, 2), 3);

%% Fit copulas to data

for i=1:numel(classes) 
   margins = fitmargins(X(Y2<=i, :));
   cml = fitcopulas(X(Y2<=i, :), 'CML');
   ifm = fitcopulas(X(Y2<=i, :), 'IFM', {margins.DistName});
   
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




