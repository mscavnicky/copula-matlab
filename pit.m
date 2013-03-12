function [ U ] = pit( X, PD )
%PIT Performs probability integral transform on sample X.
%   Performs PIT on each column vector of sample X given its probability
%   distribution. Distribution should be passed as a cell array of ProbDist
%   objects.

assert(size(X, 2) == numel(PD), 'Dimensions do not match.');

U = zeros(size(X));
for i=1:numel(PD)
    U(:,i) = PD{i}.cdf(X(:,i));
end

% Values must be strictly between 0 and 1
U(U == 0) = 1e-6;
U(U == 1) = 1 - 1e-6;

end

