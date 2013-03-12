function [ TY ] = classify( family, method, TX, X, Y )
%COPULA.CLASSIFY 

n = size(Y, 1);

% Obtain list of classes
K = unique(Y);
numClasses = numel(K);

% Fit a copula for each class depending on the fit method
dbg('copulas.classify', 3, 'Fitting copulas for class.\n');
for i=1:numClasses
    % Prior class probability
    C(i).P = sum(Y == K(i)) / n;
    % Training data for class i
    C(i).X = X(Y == K(i), :);
    % Uniformed data for C(i)
    if strcmp(method, 'CML')  
        C(i).U = uniform(C(i).X);
    elseif strcmp(method, 'IFM')
        C(i).Margins = fitmargins(C(i).X);
        C(i).U = pit(C(i).X, {C(i).Margins.ProbDist});
    else
        error('Unknown method %s', method);
    end        
    
    C(i).Copula = copula.fit(family, C(i).U);
end

% Compute likelihood for test sample in each copula
L = zeros(size(TX, 1), numClasses);
for i=1:numClasses
    dbg('copulas.classify', 3, 'Computing likelihood for class %d.\n', i);
    if strcmp(method, 'CML')
        copulaLikelihood = copula.pdf(C(i).Copula, empcdf(C(i).X, TX));
        marginsLikelihood = prod(emppdf(C(i).X, TX), 2);
    elseif strcmp(method, 'IFM')
        copulaLikelihood = copula.pdf(C(i).Copula, pit(TX, {C(i).Margins.ProbDist}));
        marginsLikelihood = prod(problike(TX, {C(i).Margins.ProbDist}), 2);
    else
        error('Unknown method %s', method);
    end
    classProbability = C(i).P;
    L(:, i) = copulaLikelihood .* marginsLikelihood * classProbability;
end

% Chooses classes with highest likelihood
[~, m] = max(L, [], 2);
TY = K(m);

end

