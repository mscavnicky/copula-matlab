function [ outTree, U ] = preprocess( tree, U )
%HAC.PREPROCESS

if iscell(tree)
    outTree = {};
    for i=1:numel(tree)-1
        [preprocessedTree U] = hac.preprocess(tree{i}, U);
        outTree{i} = preprocessedTree;
    end
    % Add alpha at the end of the tree
    outTree{end+1} = tree{end};    
else
    % If is rotated attribute
    if tree < 0
        U(:, -tree) = 1 - U(:, -tree);        
    end
    outTree = abs(tree);
end

end

