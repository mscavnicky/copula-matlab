%% Load the data

dataset = 'Metals';
attributes = {'La', 'Pt', 'Ag', 'Au'};
classes = {'T1', 'T2', 'T3'};
folder = sprintf('../Results/%s', dataset);

data = double(importdata('../Data/Metals/Metals.mat'));
X = data(:, 1:4);
Y = toclasses(data(:, 5), 3);

%% Generate tree plots

for i=1:numel(classes)
    filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
    plotHacTree('frank', X(Y==i, :), attributes, filename); 
end
