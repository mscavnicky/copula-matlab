function [ ] = summary( x )
%SUMMARY prints basic statistics for given sample (imitates R function)

fprintf('\n')
fprintf('\tmean\t\t std\t\t min\t\t median\t\t max\t\t kurt\t\t skew\n')
fprintf('\t%f\t %f\t %f\t %f\t %f\t %f\t %f\n', mean(x), std(x), min(x), median(x), max(x), kurtosis(x), skewness(x))
fprintf('\n')

end

