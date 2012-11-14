function [ hac ] = hacfit( family, U, method )
%HACFIT Fits sample to Hierachical Archimedean Copula. Return tree.
%   Uses method by Okhrin to select HAC structure. HAC structure and alphas
%   are all encoded in resulting parameters.

% Expose subfunctions for unit-testing
if nargin == 0
   hac = {@findBestFit, @generateBinaryTrees, @splitVars, @evaluateTree}; 
   return;
end

% Assert dataset dimensions
assert(size(U, 2) > 1, 'Number of dimensions must be at least two for HAC.');

switch method
case 'full'
    hac = hacfitFull( family, U );    
case 'okhrin'
    hac = hacfitOkhrin( family, U );
end

end

function [ hac ] = hacfitFull( family, U )
%HACFITFULL Finds the best hierarchical archimedean copula that fits U.
%   Function is almost unusable for dimensions larger than 5.

minLogLike = Inf;
minHac = {};

d = size(U, 2);
trees = generateBinaryTrees(1:d);
for i=1:length(trees)
    hac = evaluateTree(family, U, trees{i});
    ll = loglike(hacpdf(family, U, hac));    
    dbg('Evaluated %s: %f\n', dprint(hac), ll);
    
    if ll < minLogLike
       minLogLike = ll;
       minHac = hac;
    end
end

hac = minHac;

end

function [ hac ] = evaluateTree( family, U, tree )
%EVALUATETREE Given proposed tree structure. Return HAC structure or empty
%cell array if HAC cannot be built using specified tree.

% Preallocate accumulator of vectors for this level
n = size(U, 1);
d = length(tree);
V = zeros(n, d);

% Evalate each node and store it in an accumulator
for i=1:d
    node = tree{i};
    if iscell(node)
        % Node is another tree, which we need to evaluate to HAC
        nestedHac = evaluateTree( family, U, node );
        % Compute column vector of output of this HAC
        V(:,i) = haccdf( family, U, nestedHac );
        % Insert hac back into tree structure
        tree{i} = nestedHac;
    else
        % Node is number so only column from input dataset
        V(:,i) = U(:,node);
    end    
end

% Fit tree to data and insert alpha into the structure
alpha = archimfit( family, V );
tree{end+1} = [alpha];
hac = tree;

end


function [ trees ] = generateBinaryTrees( vars )
%GENERATETREES Generate all possible binary trees of d-dimensional copulas

% Return tree node when dimension is 1
d = length(vars);
if d == 1
    trees = {vars(1)};
    return;
end

trees = {};

partitions = splitVars(vars);
for j=1:length(partitions)
    partition = partitions{j};

    lefts = generateBinaryTrees(partition{1});
    rights = generateBinaryTrees(partition{2});        

    for l=1:length(lefts)
        for r=1:length(rights)
            trees{end+1} = { lefts{l}, rights{r} }; %#ok<AGROW>
        end
    end        
end

end


function [ partitions ] = splitVars( vars )
%SPLITVARS Divides variables into 2 groups. Where first group is larger or
%equal in size to second group.
%   Parameter vars is a vector

partitions = {};

% For each size of the group collect combinations of the size
d = length(vars);
for i=1:d-1
    combinations = flipud(combnk(vars, i));    
    for j=1:length(combinations)
        c = combinations(j,:);
        partitions{end+1} = { setxor(vars, c), c }; %#ok<AGROW>
    end
end

% Take only the second half of partitions to eliminate isomorphic trees
l = length(partitions) / 2;
partitions = partitions(1:l);

end


function [ hac ] = hacfitOkhrin( family, U )
%HACFITOKHRIN Find HAC copula using Okhrin's greedy method.
%   Uses only bivariate copula and does not perform joins as Okhrin
%   suggests.

% Map for storing nested copulas
nestedCopulas = containers.Map('KeyType', 'uint32', 'ValueType', 'any');

d = size(U, 2);
vars = 1:d;

iteration = 0;
while length(vars) > 1
    iteration = iteration + 1;    
    % Number of this fit   
    copulaNumber = d + iteration;
    dbg('Iteration %d - %s.\n', iteration, mat2str(vars));
    % Find the best fit available for current vars 
    [ nestedVars, nestedAlpha ] = findBestNestedCopula( family, U, vars );
    % Compute output of chocsen nested copula and append it to the data sample
    U = [U archimcdf( family, U(:, nestedVars), nestedAlpha )];
    % Insert it into cache using HAC format
    nestedCopulas(copulaNumber) = num2cell([nestedVars, nestedAlpha]);    
    % Remove variables used in nested copula and introduce new for the copula
    vars = [setdiff(vars, nestedVars), copulaNumber];
end

% Recursively build the HAC structure using partial copulas
% Keep vars as a queue of variables to process
% The single remaining var has an index to copula
hac = buildHacStructure( nestedCopulas(vars(1)), nestedCopulas );

end


function [ hac ] = buildHacStructure( rootCopula, nestedCopulas )
    hac = {};
    % Iterate over all variables in the rootCopula and expand them
    for i=1:length(rootCopula)-1
       var = rootCopula{i};
       if nestedCopulas.isKey(var)
           hac{end+1} = buildHacStructure( nestedCopulas(var), nestedCopulas );
       else
           hac{end+1} = var;
       end
    end
    % Copy alpha into built HAC structure
    hac{end+1} = rootCopula{end};
end


function [ maxVars, maxAlpha ] = findBestNestedCopula( family, U, vars )
%FINDBESTFIT Tries to find the combination of variables that gives the
%highest alpha possible.
    
maxVars = [];
maxAlpha = 0;

% Generate combinations of variables of length 2
combinations = combnk(vars, 2);
% Go over each combination and compute its fit
for j = 1:size(combinations, 1)
    comb = combinations(j,:);
    dbg('* Evaluating combination %s ... ', mat2str(comb));
    alpha = archimfit( family, U(:, comb) );
    fprintf('%f\n', alpha);
    if alpha > maxAlpha
       maxVars = comb;
       maxAlpha = alpha;
    end
end

end

