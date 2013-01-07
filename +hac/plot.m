function plot( tree )
%HAC.PLOT Plot structure of given HAC tree
%   
%   References:
%       [1] http://stackoverflow.com/questions/5065051/add-node-numbers-get-node-locations-from-matlabs-treeplot

nodes = hac2nodes( tree, [], 1 );
treeplot(nodes);
[x, y] = treelayout(nodes)

end

function [ nodes, count ] = hac2nodes( tree, nodes, count )

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




