function [ Y ] = cdf( family, U, alpha )
%ARCHIMCDF CDF of multivariate Archimedean copulas.
%   Checks for parameter bounds using archimbounds function.
%   In Nelsen Clayton copula is defined using max function. We assume it is
%   needed only when negative alpha is allowed.

% Copula dimension is necessary for parameter validation
d = size(U, 2);
% Get bounds for family and dimension
[ lowerBound, upperBound ] = archim.bounds(family, d);
% Verify parameter against bounds
assert(alpha > lowerBound && alpha < upperBound, 'Copula parameter out of range.');
assert(alpha ~= 0, 'Copula parameter cannot be zero.');

% TODO Make computation use prod for lower bound

% Compute CDF according to definition
Y = archim.gen(family, sum(archim.inv(family, U, alpha), 2), alpha);

% If infinite elements exist they might be caused by large alpha
% Replace them with results of the comonotonicity copula
if strcmp(family, 'frank')
    if sum(isinf(Y)) > 0 && (alpha > 40)
        Y(isinf(Y)) = min(U(isinf(Y),:),[],2);
    end
end

end




