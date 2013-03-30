function [ TY ] = classify( family, method, TX, X, Y )
%COPULA.CLASSIFY 

n = size(Y, 1);
d = size(X, 2);

% Obtain list of classes
K = unique(Y);
assert(isequal(K, sort(K)), 'Classes do not have the right order.');
numClasses = numel(K);

% Fit a copula for each class depending on the fit method
dbg('copulas.classify', 3, 'Fitting copulas for class.\n');
for i=1:numClasses
    % Prior class probability
    C(i).P = sum(Y == K(i)) / n;
    % Training data for class i
    C(i).X = X(Y == K(i), :);
        
    % If model requires preprocessing do it for both train and test dataset
    family_i = family;
    if ismember(family, {'claytonhac*', 'gumbelhac*', 'frankhac*'})
        P = hac.preprocess( family, C(i).X, method );
        C(i).X = C(i).X * P;
        TX = TX * P;
        family_i = family(1:end-1);
    end
    
    % Uniformed data for C(i)
    if strcmp(method, 'CML')  
        C(i).U = uniform(C(i).X);
    elseif strcmp(method, 'IFM')
        C(i).Margins = fitmargins(C(i).X);
        C(i).U = pit(C(i).X, {C(i).Margins.ProbDist});
    else
        error('Unknown method %s', method);
    end        
    
    C(i).Copula = copula.fit(family_i, C(i).U);
end

% Compute likelihood for test sample in each copula
L = zeros(size(TX, 1), d + 2, numClasses);
for i=1:numClasses
    dbg('copulas.classify', 3, 'Computing likelihood for class %d.\n', i);
    if strcmp(method, 'CML')
        L(:,1,i) = copula.pdf(C(i).Copula, empcdf(C(i).X, TX));
        L(:,2:d+1,i) = emppdf(C(i).X, TX);
    elseif strcmp(method, 'IFM')
        L(:,1,i) = copula.pdf(C(i).Copula, pit(TX, {C(i).Margins.ProbDist}));
        L(:,2:d+1,i) = problike(TX, {C(i).Margins.ProbDist});
    else
        error('Unknown method %s', method);
    end
    L(:,d+2,i) = C(i).P;
end

% Make a product of likelihoods and make a matrix out of it
PL = prod(L, 2);
PL = PL(:, :);

% For each sample choose class with the highest likelihood and if they are
% same use highest copula likelihood, otherwise choose randomly
TY = zeros(size(TX, 1), 1);

for i=1:size(TX, 1)
    maxIndices = allmax(PL(i, :));
    if numel(maxIndices) == 1
        TY(i) = maxIndices;
    else
        maxIndices = allmax(L(i, 1));
        if numel(maxIndices) == 1
            TY(i) = maxIndices;
        else
            % Choose random value
            TY(i) = randi(numClasses);     
        end   
    end    
end

end

function [ xi ] = allmax( x )
%ALLMAX Given a vector x provides indices of all maximum values.
xi = find(x == max(x));
end

