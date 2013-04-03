%% Load the data

dataset = 'Vertebral';
attributes = {'Pelvic incidence', 'Pelvic tilt', 'Lordosis angle', 'Sacral slope', 'Sacral lordosis', 'Spondyl. grade'};
classes = {'Hernia', 'Displaced', 'Normal'};
folder = sprintf('../Results/%s', dataset);

fid = fopen('../Data/Vertebral/vertebral.dat');
% Read data into cell array
data = textscan(fid, '%f%f%f%f%f%f%s', 'delimiter', ' ');


X = cell2mat(data(1:6));
Y = 1*ismember(data{7}, 'DH') + 2*ismember(data{7}, 'SL') + 3*ismember(data{7}, 'NO');

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
    filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
    hactree('frank', X(Y==i, :), attributes, filename); 
end

%% Perform classificatin experiment

results = classifyall(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');