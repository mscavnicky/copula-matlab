%% Load white wine data

% We have dropped fixed acidity, chlorides and pH as they are least
% important. Only classes 5, 6 and 7 are used.

dataset = 'Wine';
attributes = {...
    'Volatile Acidity', 'Citric Acid',...
    'Residual Sugar', 'Free SO2',...
    'Total SO2', 'Density',...
    'Sulphates', 'Alcohol'};
classes = {'Q5', 'Q6', 'Q7'};
folder = sprintf('../Results/%s', dataset);

data = csvread('../Data/Wine/winequality-white.csv');


Z = data(:, 12);
X = data((Z >= 5 & Z <= 7), [2:4, 6:8, 10:11]);
Y = data((Z >= 5 & Z <= 7), 12) - 4;


%% Fit copulas to data

for i=1:numel(classes)  
   margins = fitmargins(X(Y==i, :));
   cml = fitcopulas(X(Y==i, :), 'CML');
   ifm = fitcopulas(X(Y==i, :), 'IFM', margins);
   
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

%% Generate tree plots

for i=1:numel(classes)
   U = uniform(X(Y==i, :));
   tree = hac.fit('frank', U, 'okhrin*');
   filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, classes{i});
   hac.plot('frank', tree, attributes, filename);    
end

%% Perform classificatin experiment

results = classify(X, Y);
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
save(filename, 'results');

%%

gen.cm2bar(folder, dataset);


%% Visualize dependency using HAC

claytonTree = hac.fit('clayton', U, 'okhrin*');
hac.plot('clayton', claytonTree, attributes);

gumbelTree = hac.fit('gumbel', U, 'okhrin*');
hac.plot('gumbel', gumbelTree, attributes);

frankTree = hac.fit('frank', U, 'okhrin*');
hac.plot('frank', frankTree, attributes);


%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);


%% Decision trees

tree = classregtree(X, Y, 'method', 'classification', 'names', attributes, 'minleaf', 10);
view(tree);

%% Funky stuff

 load('../Results/Wine/Wine-Confus.mat');
 for i=1:numel(matrices)
     m = matrices{i};
     matrices{i}.correct = sum(m.confus(eye(3) == 1));
     matrices{i}.misclassified = sum(m.confus(eye(3) == 0));
 end
 save('../Results/Wine/Wine-Confus.mat', 'matrices');
 
 
 
 

