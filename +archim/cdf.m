function [ Y ] = cdf( family, U, alpha )
%ARCHIM.CDF Computes cdf of multivariate Archimedean copulas.
%   Checks for parameter bounds using archim.bounds function.

% Copula dimension is necessary for parameter validation
d = size(U, 2);
% Get bounds for family and dimension
[ lowerBound, upperBound ] = archim.bounds(family, d);
% Verify parameter against bounds
assert(alpha > lowerBound && alpha < upperBound, 'Copula parameter out of range.');
assert(alpha ~= 0, 'Copula parameter cannot be zero.');

% Compute CDF according to definition
Y = archim.gen(family, sum(archim.inv(family, U, alpha), 2), alpha);

% For large levels of alpha Frank copula is numerically unstable and
% produces Inf values. Fot rhis reason infinite elements are replaced by
% estimation provided by the comonotonicity copula.
if strcmp(family, 'frank')
    if sum(isinf(Y)) > 0 && (alpha > 40)
        Y(isinf(Y)) = min(U(isinf(Y),:),[],2);
    end
end

end




