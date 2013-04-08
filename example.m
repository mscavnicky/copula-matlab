%% Example demonstrating the usage of some implemented functions. 
%   Works with the Iris dataset. The Iris dataset is a 4-dimensional
%   classification dataset with 3 classes: Setosa, Versicolor and
%   Virginica.

%% Load the data of the Iris dataset

data = dlmread('../Data/Iris/iris.txt', ',');
attributes = {'Sepal length', 'Sepal width', 'Petal length', 'Petal width'};

X = data(:, 1:4);
Y = data(:, 5);

setosa = X(Y==1, :);
veriscolor = X(Y==2, :);
virginica = X(Y==3, :);


%% Fit 4-dimensional Gaussian copula to Setosa using CML

% Transform input sample into pseudo-observations
setosaPseudoObservations = pseudoObservations(setosa);
% Fit the Gaussian copula to pseudo-observations
setosaGaussian = copula.fit('gaussian', setosaPseudoObservations)


%% Fit 4-dimensional Gumbel copula to Setosa using IFM

% Obtain margins of the setosa class
setosaMargins = fitMargins(setosa);
% Uniform data using probability transform
setosaTransformed = probabilityTransform(setosa, setosaMargins);
% Fit gumbel copula to uniformed data
setosaGumbel = copula.fit('gumbel', setosaTransformed)


%% Fit 4-dimensional Frank HAC copula to Setosa using CML

% Transform input sample into pseudo-observations
setosaPseudoObservations = pseudoObservations(setosa);
% Fit gumbel copula to uniformed data
setosaFrankHac = copula.fit('frankhac', setosaPseudoObservations)

% Visualize the obtained tree
figure;
hac.plot('frank', setosaFrankHac.tree, attributes);


%% Fit 4-dimensional Gumbel copula to Setosa using CML and modified Okhrin's algorithm

% Setosa class only has positive dependence between attributes. To
% demonstrate the modified Okhrin's algorithm we alter the original setosa
% data.
setosaAltered = setosa;
setosaAltered(:,1) = -setosaAltered(:,1);

% First we show what happend when modified data are fitted to Gumbel HAC
setosaAlteredPseudoObservations = pseudoObservations(setosaAltered);
setosaAlteredGumbelHac = copula.fit('gumbelhac', setosaAlteredPseudoObservations);

% The resulting tree fails to find dependence between Sepal Length and
% other attributes
figure;
hac.plot('gumbel', setosaAlteredGumbelHac.tree, attributes);

% Now we perform the fit using modified Okhrin's algorithm
% We obtain the preprocessing matrix
preprocessingMatrix = hac.preprocess('gumbel', setosaAltered, 'CML');
% Preprocess the input data using the matrix
setosaPreprocessed = setosaAltered * preprocessingMatrix;

% Now we can fit the copula to the preprocessed data
setosaPreprocessedPseudoObservations = pseudoObservations(setosaPreprocessed);
setosaPreprocessedGumbelHac = copula.fit('gumbelhac', setosaPreprocessedPseudoObservations);

% The resulting tree now relates the Sepal length attribute to others.
figure;
hac.plot('gumbel', setosaPreprocessedGumbelHac.tree, attributes);


%% Perform 10-fold cross-validation of the Iris dataset using Student-t copula and CML fitting method

tConfusionMatrix = copulaCrossValidation('t', 'CML', X, Y, 10)

