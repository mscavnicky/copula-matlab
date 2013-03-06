function [ TY ] = classify( family, method, TX, X, Y )
%COPULA.CLASSIFY 

n = size(Y, 1);

% Obtain list of classes
C = unique(Y);
c = numel(C);

% Prepare data structures
XC = cell(c, 1);
UC = cell(c, 1);
DC = cell(c, 1);

% Prior class probabilities
P = zeros(c, 1);
for i=1:c
    P(i) = sum(Y == C(i)) / n;
end

% Fit a copula for each class depending on the fit method
dbg('copulas.classify', 3, 'Fitting copulas for class.\n');
copulas = cell(c, 1);
for i=1:c
    XC{i} = X(Y == C(i), :);
    if strcmp(method, 'CML')  
        UC{i} = uniform(XC{i});
    elseif strcmp(method, 'IFM')
        DC{i} = fitmargins(XC{i});
        UC{i} = pit(XC{i}, DC{i});
    else
        error('Unknown method %s', method); 
    end        
    
    copulas{i} = copula.fit(family, UC{i});
end

% Compute likelihood for test sample in each copula
L = zeros(size(TX, 1), c);
for i=1:c
    dbg('copulas.classify', 3, 'Computing likelihood for class %d.\n', i);
    if strcmp(method, 'CML')  
        L(:, i) = copula.pdf(copulas{i}, empcdf(XC{i}, TX)) .* prod(emppdf(XC{i}, TX), 2) * P(i);
    elseif strcmp(method, 'IFM')
        L(:, i) = copula.pdf(copulas{i}, pit(TX, DC{i})) .* prod(problike(TX, DC{i}), 2) * P(i);
    else
        error('Unknown method %s', method);
    end
end

% Chooses classes with higherst likelihood
[~, m] = max(L, [], 2);
TY = C(m);

end

