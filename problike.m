function [ Y ] = problike( X, PD )
%PROBLIKE Produces likelihood of the sample given distributions of its
%margins.

assert(size(X, 2) == numel(PD), 'Dimensions do not match.');

warning('off', 'all');
Y = zeros(size(X));
for i=1:numel(PD)
    Y(:,i) = PD{i}.pdf(X(:,i));
end
warning('on', 'all');

end

