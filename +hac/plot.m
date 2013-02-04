function plot( tree, names )
%HAC.PLOT Plot structure of given HAC tree
%   
%   References:
%       [1] http://stackoverflow.com/questions/5065051/add-node-numbers-get-node-locations-from-matlabs-treeplot

% Parent of the root node is 0
nodes(1) = 0;
% Label of the root node is its alpha
labels{1} = strcat('\theta=', num2str(tree{end}));
% Run DFS to obtain nodes and labels
[nodes, labels, count] = hac2nodes( tree, nodes, labels, 1 );
% Plot the tree using nodes
treeplot(nodes);
% Write the labels
[x, y] = treelayout(nodes);
% Use column names if they are available
if nargin > 1
   for i=1:count
      if ~ischar(labels{i})
          u = labels{i};
          if u > 0
            labels{i} = sprintf('%s', names{u});
          else
            labels{i} = sprintf('*%s', names{abs(u)});
          end
      end
   end
end
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
        labels{count} = strcat('\theta=', num2str(child{end}));
        [nodes, labels, count] = hac2nodes(child, nodes, labels, count);        
    else
        % Use variable number as a label of this subtree
        labels{count} = child;
        % fprintf('%d: %d\n', child, count);        
    end
end

end