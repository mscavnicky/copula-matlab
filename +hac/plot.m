function plot( tree )
%HAC.PLOT Plot structure of given HAC tree
%   
%   References:
%       [1] http://stackoverflow.com/questions/5065051/add-node-numbers-get-node-locations-from-matlabs-treeplot

% Parent of the root node is 0
nodes(1) = 0;
% Label of the root node is its alpha
labels{1} = tree{end};
% Run DFS to obtain nodes and labels
[nodes, labels, ~] = hac2nodes( tree, nodes, labels, 1 );
% Plot the tree using nodes
treeplot(nodes);
% Write the labels
[x, y] = treelayout(nodes);
text(x, y, labels, 'VerticalAlignment','bottom','HorizontalAlignment','right')

end

function [ nodes, labels, count ] = hac2nodes( tree, nodes, labels, count )
%HAC2NODES Given the tree and number of root copula returns nodes for
%treeplot and number of last numbered copula and names.

% fprintf('%s: %d\n', dprint(tree), count);

parent = count;
for i=1:length(tree)-1
    count = count + 1;
    nodes(count) = parent; 
    child = tree{i};
    if iscell(child)        
        % Use alpha as a label of this subtree
        labels{count} = child{end};
        [nodes, labels, count] = hac2nodes(child, nodes, labels, count);        
    else
        % Use variable number as a label of this subtree
        labels{count} = child;
        % fprintf('%d: %d\n', child, count);        
    end
end

end