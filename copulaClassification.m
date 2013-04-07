function [ TY ] = copulaClassification( family, method, TX, X, Y )
%COPULACLASSIFICATION Classifier based on copula. Uses given copula family
%and fitting method to model each class of input sample X. Uses MAP rule to
%classify each sample from testing set TX. Returns vector TY of chosen
%classes for each sample from TX.

% Size and dimensions of the training dataset
n = size(X, 1);
% Size of the test dataset
t = size(TX, 1);

% Obtain list of classes
K = unique(Y);
numClasses = numel(K);
% Test that classes are ordered
assert(isequal(K, sort(K)), 'Classes do not have the right order.');

% Compute prior probabilities for each class
p = zeros(numClasses, 1);
for i=1:numClasses
    p(i) = sum(Y == K(i)) / n;
end

% Fit a copula for each class depending on the fit method
L = cell(numClasses, 1);
for i=1:numClasses
    dbg('copulacls', 3, 'Fitting copulas for class %d.\n', i);
    L{i} = likelihoodForClass(family, method, X(Y == i, :), TX);
end

% Compute posterior probabilities for each class.
PP = zeros(t, numClasses);
for i=1:numClasses
    PP(:, i) = prod(L{i}, 2) * p(i);
end

% For each sample choose class with the highest likelihood and if they are
% same use highest copula likelihood, otherwise choose randomly.
TY = zeros(t, 1);
for i=1:t
    maxIndices = allmax(PP(i, :));
    if numel(maxIndices) == 1
        TY(i) = maxIndices;
    else
        maxIndices = allmax(cellfun(@(x) x(i,1), L));
        if numel(maxIndices) == 1
            TY(i) = maxIndices;
        else
            % Choose random value
            TY(i) = randi(numClasses);     
        end   
    end    
end

end


function [ L ] = likelihoodForClass(family, method, X, TX)
%LIKELIHOODFORCLASS Models data of the single class using copula and
%computes the likelihood of testing sample for this class.

% Run preprocessing if required.
if ismember(family, {'claytonhac*', 'gumbelhac*', 'frankhac*'})
    P = hac.preprocess( family(1:end-4), X, method );
    X = X * P;
    % Test data need to be preprocessed too
    TX = TX * P;
    family = family(1:end-1);
end
    
% Uniform data 
if strcmp(method, 'CML')  
    U = pseudoObservations(X);
elseif strcmp(method, 'IFM')
    margins = fitMargins(X);
    U = probabilityTransform(X, margins);
else
    error('Unknown method %s', method);
end        

% Fit copula to uniformed data
copulaparams = copula.fit(family, U);

% Compute likelihood for estimated copula
d = size(X, 2);
t = size(TX, 1);
L = zeros(t, d+1);
if strcmp(method, 'CML')
    L(:,1) = copula.pdf(copulaparams, empiricalCdf(X, TX));
    L(:,2:d+1) = kernelDensity(X, TX);
elseif strcmp(method, 'IFM')
    L(:,1) = copula.pdf(copulaparams, probabilityTransform(TX, margins));
    L(:,2:d+1) = density(TX, margins);
else
    error('Unknown method %s', method);
end

end


function [ xi ] = allmax( x )
%ALLMAX Given a vector x provides indices of all maximum values.
xi = find(x == max(x));
end

