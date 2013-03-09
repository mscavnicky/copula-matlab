function [ dists, pvalues ] = fitmargins( X )
%FITMARGINS Given sample X fits some distribution to each margin.
%   Returns list of distributions and kstest p-values.

d = size(X, 2);
dists = cell(d, 1);
pvalues = NaN(d, 1);

for i=1:d   
    [~, PD] = allfitdist(X(:,i));    
    warning('off', 'all');
    
    for j=1:numel(PD)
        try 
            % Try running cdf functions over X to verify it is stable
            Y = PD{j}.cdf(X(:,i));
            if isnan(Y) | isinf(Y)
                throw('Distribution is not numerically stable.')
            end
           
            % Perform Kolmogorov-Smirnov test
            [~, pvalue] = kstest(X(:,i), PD{j});
            
            % Store distribution and its p-value
            dists{i} = PD{j}.DistName;
            pvalues(i) = pvalue;            
            break;
        catch          
            % Skip this distribution
        end
    end
    
    warning('on', 'all');    
end

end

