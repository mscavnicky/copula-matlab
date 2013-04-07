function [ tree ] = full( family, U )
%HAC.FIT.FULL Finds the best hierarchical Archimedean copula that fits U.
%   Chooses the best copula according to likelihood. Function is unusable
%   for dimensions larger than 5.

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
%cell array if HAC cannot be built using the specified tree.

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
%GENERATEBINARYREES Generate all possible binary trees of d-dimensional
%copulas

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
%equal in size to second group. Parameter vars is a vector

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