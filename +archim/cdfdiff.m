function [ Y ] = cdfdiff( family, U, alpha, diffvars )
%ARCHIM.CDFDIFF Derives d-dimensionsal cdf by all provided vars.
%   Returns symbolic expression. Vars is an array of numbers where number
%   represents symbol.

% Cache containing references to Matlab functions
persistent cache;
if isempty(cache)
    cache = containers.Map;
end

d = size(U, 2);

% Identifier of this derivation
id = sprintf('%s_%d_%s', family, d, sprintf('%d_', diffvars));

% Return cached version if it exists
if isKey(cache, id)
    fhandle = cache(id);
else
    % Construct symbolic version of cdf diff
    f = archim.sym.cdfdiff( family, d, diffvars );
    % We are taking the assumption that alpha parameter is the first one
    args = symvar(f);
    % Convert symbolic version into matlabFunction
    fhandle = matlabFunction(f, 'vars', {args(2:end), args(1)});
    % Cache the resulting matlab function
    cache(id) = fhandle;
end

Y = fhandle(U, alpha);

end

