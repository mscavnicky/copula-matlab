function [ Y ] = density( X, margins )
%DENSITY Produces density of the sample given distributions of its
%margins.

assert(size(X, 2) == numel(margins), 'Dimensions do not match.');

warning('off', 'all');
Y = zeros(size(X));
for i=1:numel(margins)
    Y(:,i) = margins{i}.pdf(X(:,i));
end
warning('on', 'all');

end

