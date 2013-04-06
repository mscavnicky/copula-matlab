function [ f ] = cdfDerivative( family, d, diffvars )
%ARCHIM.SYM.CDFDIFF Derives d-dimensionsal cdf by all provided vars.
%   Returns symbolic expression. Vars is an array of numbers where number
%   represents symbol.

% Generate symbols
a = sym('a');

vars = cell(d, 1);
for i=1:d
    vars{i} = sym(sprintf('u%d', i));
end

% Generate cdf function
f = archim.sym.cdf( family, vars, a );

% Differentiate the cdf in all dimensions
for i=1:numel(diffvars)
   f = diff(f, vars{diffvars(i)});
end

end

