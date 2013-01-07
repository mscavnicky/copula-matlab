function plot( tree )
%HAC.PLOT Plot structure of given HAC tree
%   
%   References:
%       [1] http://stackoverflow.com/questions/5065051/add-node-numbers-get-node-locations-from-matlabs-treeplot

[nodes, count] = hac2nodes( tree, [], 1 );
treeplot(nodes);
[x, y] = treelayout(nodes);
name1 = cellstr(num2str((1:count)'));
text(x, y, name1, 'VerticalAlignment','bottom','HorizontalAlignment','right')

end

function [ nodes, count ] = hac2nodes( tree, nodes, count )
%HAC2NODES Given the tree and number of root copula returns nodes for
%treeplot and number of last numbered copula and names.

parent = count;
fprintf('%s: %d\n', dprint(tree), count);

for i=1:length(tree)-1
    count = count+1;
    nodes(count) = parent;
    if iscell(tree{i})     
        [nodes, count] = hac2nodes(tree{i}, nodes, count);
    else
        fprintf('%d: %d\n', tree{i}, count);
    end
end

end