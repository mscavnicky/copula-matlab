function f = archimsym( family, symbols, alpha )
%ARCHIMSYM Produces symbolic expression of given Archimedean copula.
%   Given dimension produces symbolic expression n-dimensional Archimedean
%   copula using provided symbols for variables and alpha for parameter symbol.

% Sum together all inverse generators
f = sym(0);
for i=1:length(symbols)
    s = symbols{i};
    f = f + archiminvsym(family, s, alpha);
end

% Appply generator over the sum
f = archimgensym(family, f, alpha);

end

