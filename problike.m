function [ Y ] = problike( X, dists )
%PROBLIKE Produces likelihood of the sample given distributions of its
%margins.

assert(size(X, 2) == length(dists), 'Dimensions do not match.');

Y = zeros(size(X));
for i=1:length(dists)
    PD = fitdist(X(:,i), dists{i});
    Y(:,i) = PD.pdf(X(:,i));
end

end

