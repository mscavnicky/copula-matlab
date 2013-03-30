function hactree( family, X, folder, dataset, class, attributes )

P = hac.preprocess(family, X, 'CML');
X = X * P;

U = uniform(X);
tree = hac.fit(family, U, 'okhrin');

filename = sprintf('%s/%s-%s-Tree.pdf', folder, dataset, class);

names = {};
for j=1:size(X, 2)
  if P(j,j) == 1
    names{j} = attributes{j};
  else
    names{j} = sprintf('%s*', attributes{j});
  end      
end

hac.plot(family, tree, names, filename);

end

