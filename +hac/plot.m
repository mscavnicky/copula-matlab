function plot( tree )
%HAC.PLOT Plot structure of given HAC tree
%   
%   References:
%       [1] http://stackoverflow.com/questions/5065051/add-node-numbers-get-node-locations-from-matlabs-treeplot

[~, nodes ] = hac2nodes( tree, 1, [] );
treeplot(nodes);
[x, y] = treelayout(nodes)

end

function [ order, nodes ] = hac2nodes( tree, order, nodes )

parent = order;
fprintf('%s: %d\n', dprint(tree), order);

for i=1:length(tree)-1
    nodes(order+1) = parent;
    if iscell(tree{i})        
        [order, nodes] = hac2nodes(tree{i}, order + 1, nodes);
    else
        fprintf('%d: %d\n', tree{i}, order + 1);
        order = order + 1;        
    end    
end

end




