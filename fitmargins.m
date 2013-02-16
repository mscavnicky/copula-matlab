function [ dists, pvalues ] = fitmargins( X )
%FITMARGINS Given sample X fits some distribution to each margin.
%   Returns list of distributions and kstest p-values.

d = size(X, 2);
dists = cell(d, 1);
pvalues = NaN(d, 1);

for i=1:d   
    [~, PD] = allfitdist(X(:,i));
    
    
    j = 1;
    while j <= numel(PD)
        dists{i} = PD{j}.DistName;
        try 
            [~, pvalue] = kstest(X(:,i), PD{j});
            pvalues(i) = pvalue;    
            break;
        catch
            warning('fitmargins:kstest', 'Kolmogorov-Smirnov test failed %s.', dists{i});
            j = j + 1;
        end
    end
end

end

