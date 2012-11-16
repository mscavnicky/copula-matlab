function [ U ] = pit( X, dists )
%PIT Performs probability integral transform on sample X.
%   Performs PIT on each column vector of sample X given its probability
%   distribution. Distribution should be passed as a cell array of ProbDist
%   objects.

assert(size(X, 2) == length(dists), 'Dimensions do not match.');

U = zeros(size(X));
for i=1:length(dists)
    PD = fitdist(X(:,i), dists{i});
    U(:,i) = PD.cdf(X(:,i));
end

end

