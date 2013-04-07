function [ f ] = cdf( family, symbols, alpha )
%ARCHIM.SYM.CDF Produces symbolic expression of d-dimensional Archimedean
%copula using provided symbols as variables and alpha as a parameter
%symbol.

% Sum together all inverse generators
f = sym(0);
for i=1:length(symbols)
    s = symbols{i};
    f = f + archim.sym.generatorInverse(family, s, alpha);
end

% Appply generator over the sum
f = archim.sym.generator(family, f, alpha);

end

