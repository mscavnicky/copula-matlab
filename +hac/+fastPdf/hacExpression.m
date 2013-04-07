function [ expr, params, time ] = hacExpression( tree, time )
%HAC.FASTPDF.HACEXPRESSION Recursively generates string expression of HAC.
%   Function assigns id to each nested copula in DFS order. Returns string
%   expression as well as list of alphas from the copula.

%#ok<*AGROW>

if nargin < 2
    time = 1;
end

% Map of the parameters of the HAC expression
params = containers.Map;
% Generate copula identifier for the top-level copula
copulaId = sprintf('C%d', time);
tokens = {copulaId, '('};
% Increase DFS time
time = time + 1;

% Recursively generate expression for children nodes
for i=1:numel(tree) - 1
    node = tree{i};
    if iscell(node)
        [subExpr, subParams, time] = hac.fastPdf.hacExpression( node, time );
        % Append expression of the child copula
        tokens{end+1} = subExpr;
        % Merge two maps with parameters
        params = [params; subParams];                
    else
        tokens{end+1} = sprintf('u%d', node);
    end     
    
    % Use comma between child expressions
    if i < numel(tree) - 1
       tokens{end+1} = ','; 
    end
end

tokens{end+1} = ')';
% Join string tokens into single expression
expr = strjoin(tokens);
% Update alphas with alpha of top-level copula
params(copulaId) = tree{end};

end

