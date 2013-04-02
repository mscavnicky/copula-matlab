function hactree( family, X, attributes, filename )

P = hac.preprocess(family, X, 'CML');
X = X * P;

U = uniform(X);
tree = hac.fit(family, U, 'okhrin');

for j=1:size(X, 2)
    if P(j,j) == -1
        attributes{j} = sprintf('%s*', attributes{j});
    end      
end

if nargin > 3
    hac.plot(family, tree, attributes, filename);
else
    hac.plot(family, tree, attributes);
end

end

