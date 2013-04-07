function [ f ] = cdfDerivative( family, d, diffVars )
%ARCHIM.SYM.CDFDERIVATIVE Derives a d-dimensionsal cdf with respect to all
%provided variables. Returns symbolic expression. Variables is an array of
%numbers which represent symbols.

% Generate symbols
alpha = sym('a');

vars = cell(d, 1);
for i=1:d
    vars{i} = sym(sprintf('u%d', i));
end

% Generate cdf function
f = archim.sym.cdf( family, vars, alpha );

% Differentiate the cdf in all dimensions
for i=1:numel(diffVars)
   f = diff(f, vars{diffVars(i)});
end

end

