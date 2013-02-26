function plot( family, tree, names, imagename )
%HAC.PLOT Plot structure of given HAC tree.
%   Generates a figure of HAC where each leaf represents an attribute and
%   each inner node represents an Archimedean copula. Parameter of the
%   copula is displayed as Kendall's tau.
%
%   References:
%       [1] http://stackoverflow.com/questions/5065051/add-node-numbers-get-node-locations-from-matlabs-treeplot

% Parent of the root node is 0
nodes(1) = 0;
% Label of the root node is its alpha
labels{1} = sprintf('$%.3f$', copulastat(family, tree{end}));
% Run DFS to obtain nodes and labels
[nodes, labels, count] = hac2nodes( family, tree, nodes, labels, 1 );
% Plot the tree using nodes
treeplot(nodes);
% Turn off all the borders in the picture
set(gca, 'Box','off')
set(gca, 'XTick', [], 'YTick', []);
% Remevoes the height label
set(get(gca, 'XLabel'), 'String', []);
set(gca, 'Visible', 'off');

% Write the labels
[x, y] = treelayout(nodes);
% Use column names if they are available
if nargin > 2
   for i=1:count
      if ~ischar(labels{i})
          u = labels{i};
          if u > 0
            labels{i} = sprintf('%s', names{u});
          else
            labels{i} = sprintf('%s*', names{abs(u)});
          end
      end
   end
end

% Plot node labels
for i=1:numel(labels)
    if regexp(labels{i}, '[01]\.[0-9]+')
        th = text(x(i)+0.02, y(i), labels{i});
        set(th, 'Interpreter', 'latex');    
        set(th, 'VerticalAlignment', 'bottom');
        set(th, 'HorizontalAlignment', 'left');        
    else
        th = text(x(i), y(i), labels{i});
        set(th, 'Interpreter', 'latex');    
        set(th, 'VerticalAlignment', 'bottom');
        set(th, 'HorizontalAlignment', 'right');
        set(th, 'Rotation', 55);       
    end
end

% Print to file if argument specified
% Size is set according to dimensions

d = hac.dim(tree);

if nargin > 3
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [d+1 d+2]);
    set(gcf, 'PaperPosition', [0 0 d+1 d+2]);
    print('-dpdf', '-r300', imagename);
end


end

function [ nodes, labels, count ] = hac2nodes( family, tree, nodes, labels, count )
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
        alpha = child{end};
        % Convert copula parameter to Kendall's tau
        tau = copulastat(family, alpha);        
        labels{count} = sprintf('$%.3f$', tau);
        [nodes, labels, count] = hac2nodes(family, child, nodes, labels, count);        
    else
        % Use variable number as a label of this subtree
        labels{count} = child;
        % fprintf('%d: %d\n', child, count);        
    end
end

end