function [ dists ] = fitmargins( X )
%FITMARGINS Given sample X fits some distribution to each margin.
%   Returns list of distributions and kstest p-values.

dbg('fitmargins', 3, 'Fitting margins.\n');

d = size(X, 2);

for i=1:d   
    [D, PD] = allfitdist(X(:,i));    
    warning('off', 'all');
    
    for j=1:numel(PD)
        try 
            % Try running cdf and pdf functions over X to verify it is numerically stable
            Y = PD{j}.cdf(X(:,i)) + PD{j}.pdf(X(:,i));
            if isnan(Y) | isinf(Y)
                exception = MException('fitmargins:unstable', 'Distribution is not numerically stable.');
                throw(exception);
            end          
            
            % Store distribution and its p-value
            dists(i) = D(j);
            break;
        catch e
            % Skip this distribution
            dbg('fitmargins', 3, e.message);
        end
    end
    
    warning('on', 'all');    
end

end

