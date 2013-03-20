function [ tree ] = fit( family, U, method )
%HAC.FIT Fits sample to Hierachical Archimedean Copula. Return tree.
%   Uses method by Okhrin to select HAC structure. HAC structure and alphas
%   are all encoded in resulting parameters.
%
%   References:
%       [1] Okhrin. O, Ristig. A, Hierarchical Archimedean Copulae: The HAC
%       Package

% Use Okhrin's method by default
if nargin < 3
   method = 'okhrin';
end

% Assert dataset dimensions
assert(size(U, 2) > 1, 'Number of dimensions must be at least two for HAC.');

% Perform fit of HAC
switch method
case 'full'
    tree = hacfitFull( family, U );    
case 'okhrin'
    tree = hacfitOkhrin( family, U, 'okhrin' );
case 'okhrin*'
    tree = hacfitOkhrin( family, U, 'okhrin*' );    
otherwise
    error('hac:fit:method', 'Fitting method %s not recognized', method);
end

% Validate generated HAC
valid = hac.valid(tree);
if ~valid
   error('hac:fit:invalid', 'HAC copula is not valid %s', dprint(tree));   
end

end

function [ tree ] = hacfitFull( family, U )
%HACFITFULL Finds the best hierarchical archimedean copula that fits U.
%   Function is almost unusable for dimensions larger than 5.

minLogLike = Inf;
minTree = {};

d = size(U, 2);
trees = generateBinaryTrees(1:d);
for i=1:length(trees)
    tree = evaluateTree(family, U, trees{i});
    nll = -sum(log(hac.fpdf(family, U, tree)));    
    dbg('hac.fit', 5, 'Evaluated %s: %f\n', dprint(tree), nll);
    
    if nll < minLogLike
       minLogLike = nll;
       minTree = tree;
    end
end

tree = minTree;

end

function [ tree ] = evaluateTree( family, U, tree )
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
        V(:,i) = hac.cdf( family, U, nestedHac );
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
%hac = tree;

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


function [ tree ] = hacfitOkhrin( family, U, method )
%HACFITOKHRIN Find HAC copula using Okhrin's greedy method [1].
%   Uses only bivariate copula and does not perform joins as Okhrin
%   suggests. To obtain valid HAC parameter space is shortened for outer
%   copulas.

% Map for storing nested copulas
copulas = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
% Dimensions of the copula
d = size(U, 2);
% Variables available for fit
vars = 1:d;

copulaNumber = d;
while length(vars) > 1
    copulaNumber = copulaNumber + 1;
    dbg('hac.fit', 4, 'Iteration %d - %s.\n', copulaNumber - d, mat2str(vars));
    
    % Find the best fit available for current vars 
    [ nestedVars, nestedAlpha ] = chooseCopula( family, U, vars, copulas, d, method );
    
    % Compute output of chocsen nested copula and append it to the data sample
    U = [U archim.cdf( family, U(:, abs(nestedVars)), nestedAlpha )];
    
    % Insert it into cache using HAC format
    copulas(copulaNumber) = num2cell([nestedVars, nestedAlpha]);    
    
    % Remove variables used in nested copula and introduce new for the copula
    vars = [setdiff(vars, abs(nestedVars)), copulaNumber];
end

% Recursively build the HAC structure using partial copulas
% Keep vars as a queue of variables to process
% The single remaining var has an index to copula
tree = buildHacStructure( copulas(vars(1)), copulas );

end

function [ maxVars, maxAlpha ] = chooseCopula( family, U, vars, copulas, d, method )
%CHOOSECOPULA Tries to find the combination of variables that gives the
%highest alpha possible.
    
maxVars = [];
maxAlpha = -1;

% Generate combinations of variables of length 2
combinations = combnk(vars, 2);
% Go over each combination and compute its fit
for j = 1:size(combinations, 1)
    comb = combinations(j,:);   
    
    dbg('hac.fit', 5, '* Evaluating combination %s ... \n', mat2str(comb));
    % Make sure we are using valid upper bound
    [ lowerBound, upperBound ] = hac.bounds( family );    
    upperBound = min( upperBound, childAlpha( copulas, comb ) );
    
    % Perform using valid bounds and given combination
    alpha = archim.fit( family, U(:, comb), lowerBound, upperBound );
    dbg('hac.fit', 5, '%f\n', alpha);
    
    if alpha > maxAlpha
       maxVars = comb;
       maxAlpha = alpha;
    end
    
    % Rotated left
    if strcmp(method, 'okhrin*') && comb(1) <= d        
        alpha = archim.fit( family, [1-U(:, comb(1)) U(:, comb(2))], lowerBound, upperBound );
        
        if alpha > maxAlpha
            maxVars = comb .* [-1 1];
            maxAlpha = alpha;
        end
    end
    
    % Rotated right
    if strcmp(method, 'plot') && comb(2) <= d        
        alpha = archim.fit( family, [U(:, comb(1)) 1-U(:, comb(2))], lowerBound, upperBound );
        
        if alpha > maxAlpha
            maxVars = comb .* [1 -1];
            maxAlpha = alpha;
        end        
    end
end

end

function [ alpha ] = childAlpha( copulas, comb )
%CHILDALPHA Given list of already generated copulas and a list of newly
%proposed copulas returns minimum value of their alphas.
alpha = Inf;
for i=1:length(comb)
   c = comb(i);
   % Only variables that represent child copulas are interesting
   if isKey( copulas, c )
       childCopula = copulas(c);
       childAlpha = childCopula{end};
       alpha = min(alpha, childAlpha);
   end
end
end


function [ tree ] = buildHacStructure( rootCopula, nestedCopulas )
    tree = {};
    % Iterate over all variables in the rootCopula and expand them
    for i=1:length(rootCopula)-1
       var = rootCopula{i};
       if nestedCopulas.isKey(var)
           tree{end+1} = buildHacStructure( nestedCopulas(var), nestedCopulas );
       else
           tree{end+1} = var;
       end
    end
    % Copy alpha into built HAC structure
    tree{end+1} = rootCopula{end};
end