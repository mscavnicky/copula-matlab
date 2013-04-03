function [ results ] = classify( X, Y )
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
    confus = copula.crossval(family, method, X, Y, 10);
    
    result.Family = family;
    result.Method = method;
    result.Confus = confus;
    result.Correct = sum(confus(eye(size(confus)) == 1));
    result.Incorrect = sum(confus(eye(size(confus)) == 0));
end

