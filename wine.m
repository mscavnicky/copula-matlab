%% Load white wine data

% We have dropped fixed acidity, chlorides and pH as they are least
% important

names = {...
    'Volatile Acidity',...
    'Citric Acid',...
    'Residual Sugar',...
    'Free SO2',...
    'Total SO2',...
    'Density',...
    'Sulphates',...
    'Alcohol'};
dataset = 'Wine';
classnames = {'5', '6', '7'};

data = csvread('../Data/Wine/winequality-white.csv');

X = data(:,[2:4, 6:8, 10:11]);
Y = data(:,12);
U = uniform(X);

[n, d] = size(X);

%% Histograms

hist(X(:,1), 20);
hist(X(:,2), 20);
hist(X(:,3), 20);
hist(X(:,4), 20);
hist(X(:,5), 20);
hist(X(:,6), 20);
hist(X(:,7), 20);
hist(X(:,8), 20);
hist(X(:,9), 20);
hist(X(:,10), 20);
hist(X(:,11), 20);
hist(Y, 20);

%% Asses fit of the margins

[ dists, pvalues ] = fitmargins(X);

%% Scatter visualizations

plotmatrix(S);
plotmatrix(U);
plotmatrix(X);
plotmatrix(P);

%% Fit margins and generate table

allDists = cell(3, 1);
allPValues = cell(3, 1);

for i=5:7
    [dists, pvalues] = fitmargins(X(Y==i, :));
    allDists{i-4} = dists;
    allPValues{i-4} = pvalues;
end

alldists2table('../Results', allDists, allPValues, names, dataset, classnames);

%% Fit copulas

cmlFits = cell(3, 1);
ifmFits = cell(3, 1);

for i=5:7
    cmlFits{i-4} = fitcopulas(X(Y==i, :), 'CML');
    ifmFits{i-4} = fitcopulas(X(Y==i, :), 'IFM', allDists{i-4});
end

%% Produce results

for i=5:7    
    fit2table('../Results', cmlFits{i-4}, ifmFits{i-4}, dataset, i, classnames{i-4});
    fit2bars('../Results', cmlFits{i-4}, ifmFits{i-4}, dataset, i, classnames{i-4});
end


%% Produce trees

for i=5:7
   U = uniform(X(Y==i, :));
   tree = hac.fit('frank', U, 'plot');
   filename = sprintf('../Results/%s-%d-tree.pdf', dataset, i);
   hac.plot('frank', tree, names, filename);    
end



%% KNN classifier

knn = ClassificationKNN.fit(X,Y);
resubLoss(knn);

cvknn = crossval(knn);
kloss = kfoldLoss(cvknn);


%% Decision trees

tree = classregtree(X, Y, 'method', 'classification', 'names', names, 'minleaf', 10);
view(tree);