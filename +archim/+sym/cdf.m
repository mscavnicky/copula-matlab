function f = cdf( family, symbols, alpha )
%ARCHIMSYM Produces symbolic expression of given Archimedean copula CDF.
%   Given dimension produces symbolic expression n-dimensional Archimedean
%   copula using provided symbols for variables and alpha for parameter symbol.

% Sum together all inverse generators
f = sym(0);
for i=1:length(symbols)
    s = symbols{i};
    f = f + archim.sym.inv(family, s, alpha);
end

% Appply generator over the sum
f = archim.sym.gen(family, f, alpha);

end

