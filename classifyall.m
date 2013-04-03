function [ results ] = classifyall( X, Y )
%CLASSIFY Performs dataset classification using all copula families

families = {...
    'independent',...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
    'claytonhac*' 'gumbelhac*' 'frankhac*'
};

%families = {'frankhac*'};

numFamilies = numel(families);

for i=1:numFamilies
    family = families{i};
    results(i) = classifyUsing(family, 'CML', X, Y);
end

for i=1:numFamilies
    family = families{i};
    results(i+numFamilies) = classifyUsing(family, 'IFM', X, Y);
end

end

function [ result ] = classifyUsing( family, method, X, Y )
    confus = copcrossval(family, method, X, Y, 10);
    
    result.Family = family;
    result.Method = method;
    result.Confus = confus;
    result.Correct = sum(confus(eye(size(confus)) == 1));
    result.Incorrect = sum(confus(eye(size(confus)) == 0));
end

function [ confusionMatrix ] = copcrossval( family, method, X, Y, k )
%COPULA.CROSSVAL

dbg('copula.crossval', 2, 'Cross validation for family %s.\n', family);

% Reset random numbe generator to obtain same partitions every run
rng(42);
% Run stratified k-fold cross-validation
fun = @(X, Y, TX, TY) classifyAndTest(family, method, X, Y, TX, TY);
confusionMatrix = crossval(fun, X, Y, 'kfold', k, 'stratify', Y);

% Reshape confusion matrix
numClasses = numel(unique(Y));
% Perform sum of confusion matrices from all the runs
confusionMatrix = reshape(sum(confusionMatrix), numClasses, numClasses);

end

function [ confusionMatrix ] = classifyAndTest(family, method, X, Y, TX, TY)
    K = unique(Y);    
    TYhat = classify(family, method, TX, X, Y);
    confusionMatrix = confusionmat(TY, TYhat, 'order', K);
end

