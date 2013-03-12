%% Load data

dataset = 'Seeds';
attributes = {'Area', 'Perimeter', 'Compactness', 'Length', 'Width', 'Assymetry', 'Groove'};
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

%% Produce classification results

%% Perform classificatin experiment

families = {...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'};
filename = sprintf('%s/%s-Confus.mat', folder, dataset);
matrices = {};
save(filename, 'matrices');
for i=1:numel(families)
    family = families{i};
    
    cmlCm = copula.crossval(family, 'CML', X, Y, 10);    
    s = load(filename, 'matrices');
    matrices = s.matrices;
    matrices{end+1} = struct('family', family, 'method', 'CML', 'confus', cmlCm);
    save(filename, 'matrices', '-append');
    
    ifmCm = copula.crossval(family, 'IFM', X, Y, 10);
    s = load(filename, 'matrices');
    matrices = s.matrices;
    matrices{end+1} = struct('family', family, 'method', 'IFM', 'confus', cmlCm);
    save(filename, 'matrices', '-append');    
end

%% Plot the classification

gen.cm2table('../Results', dataset, 'CML', cmlCm);
gen.cm2table('../Results', dataset, 'IFM', ifmCm);

%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);

%% Visualize dependency using HAC

U = uniform(X);

claytonTree = hac.fit('clayton', U, 'okhrin*');
hac.plot('clayton', claytonTree, names);

gumbelTree = hac.fit('gumbel', U, 'okhrin*');
hac.plot('gumbel', gumbelTree, names);

frankTree = hac.fit('frank', U, 'okhrin*');
hac.plot('frank', frankTree, names);