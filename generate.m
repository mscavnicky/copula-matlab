%% Names

datasets = {'Iris', 'Seeds', 'Wine', 'Vertebral'};
classes = {...,
    {'Setosa', 'Versicolor', 'Virginica'},...
    {'Kama', 'Rosa', 'Canadian'},...
    {'Q5', 'Q6', 'Q7'},...
    {'Hernia', 'Spondylolisthesis', 'Normal'},...
    {'T1', 'T2', 'T3'}...
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

%% Generate scores

gen.scores2table( families, datasets, classes );

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
