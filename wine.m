%% Load white wine data

% We have dropped fixed acidity, chlorides and pH as they are least
% important. Only classes 5, 6 and 7 are used.

dataset = 'Wine';
attributes = {...
    'Citric Acid', 'Volatile Acidity',...
    'Residual Sugar', 'Free SO2',...
    'Total SO2', 'Density',...
    'Sulphates', 'Alcohol'};
classes = {'Q5', 'Q6', 'Q7'};
folder = sprintf('../Results/%s', dataset);

data = csvread('../Data/Wine/winequality-white.txt');


% Filter out problematic data
data = data([1:3119,3121:3710,3712:4534], :);
Z = data(:, 12);
% Only choose interesting attributes
X = data((Z >= 5 & Z <= 7), [2:4, 6:8, 10:11]);
Y = data((Z >= 5 & Z <= 7), 12) - 4;

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