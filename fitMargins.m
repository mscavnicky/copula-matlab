function [ margins, marginResults ] = fitMargins( X )
%FITMARGINS Given sample X fits a statistical distribution to each margin.
%   Returns list of distributions and kstest p-values.

dbg('fitmargins', 3, 'Fitting margins.\n');

for i=1:size(X, 2)
    marginResults(i) = fitAllDistributions(X(:,i)); %#ok<AGROW>
end

margins = {marginResults.ProbDist};

end

