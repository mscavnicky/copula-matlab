%% Names

%datasets = {'Iris', 'Seeds', 'Wine', 'Vertebral'};
datasets = {'Iris'};
classes = {...,
    {'Setosa', 'Versicolor', 'Virginica'},...
    {'Kama', 'Rosa', 'Canadian'},...
    {'Q5', 'Q6', 'Q7'},...
    {'Hernia', 'Displaced', 'Normal'},...
    {'T1', 'T2', 'T3'}...
};

attributes = {...,
    {'Sepal length', 'Sepal width', 'Petal length', 'Petal width'},...
    {'Area', 'Perimeter', 'Compactness', 'Length', 'Width', 'Assymetry', 'Groove Length'},...
    {'Citric Acid', 'Volatile Acidity', 'Residual Sugar', 'Free SO2', 'Total SO2', 'Density', 'Sulphates', 'Alcohol'},...
    {'Pelvic incidence', 'Pelvic tilt', 'Lordosis angle', 'Sacral slope', 'Sacral lordosis', 'Spondyl. grade'},...
    {'Lt', 'Pt', 'Ag', 'Au'}
};

families = {...
    'gaussian' 't' 'clayton' 'gumbel' 'frank'...
    'claytonhac' 'gumbelhac' 'frankhac'...
};

familyNames = {...
    'Gaussian', 'Student-t',...
    'Clayton', 'Gumbel', 'Frank',...
    'Clayton HAC', 'Gumbel HAC', 'Frank HAC'...
};

familyNamesClassification = {...
    'Independent',...
    'Gaussian', 'Student-t',...
    'Clayton', 'Gumbel', 'Frank',...
    'Clayton HAC', 'Gumbel HAC', 'Frank HAC'...
    'Clayton HAC*', 'Gumbel HAC*', 'Frank HAC*'...
};

%% Generate scores

gen.cmp2table( datasets, familyNamesClassification );
gen.scores2table( families, datasets, classes );

%% Generate margins

for i=1:numel(datasets)
    dataset = datasets{i};
    folder = sprintf('../Results/%s', dataset);
    gen.margins2table(folder, dataset, attributes{i}, classes{i});
end

%% Generate bars

for i=1:numel(datasets)
    dataset = datasets{i};
    folder = sprintf('../Results/%s', dataset);
    for j=1:numel(classes{i})
       class = classes{i}{j};
       gen.fit2table(folder, familyNames, dataset, class);
       gen.fit2bars(folder, familyNames, dataset, class, 'AIC' );
       gen.fit2bars(folder, familyNames, dataset, class, 'SnC' );
    end
end

%% Generate classification

for i=1:numel(datasets)
    dataset = datasets{i};
    folder = sprintf('../Results/%s', dataset);
    gen.cm2bar(folder, dataset);
end

%% Generate comparison of modified okhrin's algorith

for i=1:numel(datasets)
    dataset = datasets{i};
    folder = sprintf('../Results/%s', dataset);
    gen.modified2table(folder, dataset, classes{i});
end
