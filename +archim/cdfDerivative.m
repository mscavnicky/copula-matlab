function [ Y ] = cdfDerivative( family, U, alpha, diffVars )
%ARCHIM.CDFDERIVATIVE Computes derivative of d-dimensionsal Archimedean cdf
%with respect to all provided variables.
%   Uses symbolic version of cdfdiff to compure derivatives. Caches
%   derivatives of the cdf.

% Cache containing references to Matlab functions
persistent cache;
if isempty(cache)
    cache = containers.Map;
end

d = size(U, 2);

% Key for this derivation
cacheKey = sprintf('%s_%d_%s', family, d, sprintf('%d_', diffVars));

% Return cached version if it exists
if isKey(cache, cacheKey)
    fhandle = cache(cacheKey);
else
    % Construct symbolic version of cdf diff
    f = archim.sym.cdfDerivative( family, d, diffVars );
    % We are taking the assumption that alpha parameter is the first one
    args = symvar(f);
    % Convert symbolic version into matlabFunction
    fhandle = matlabFunction(f, 'vars', {args(2:end), args(1)});
    % Cache the resulting matlab function
    cache(cacheKey) = fhandle;
end

Y = fhandle(U, alpha);

end

