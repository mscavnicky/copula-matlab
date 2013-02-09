function [ expr, params, d ] = expr( tree, d )
%HAC.SYM.EXPR Generate string expression for HAC copula.

%#ok<*AGROW>

if nargin < 2
    d = 1;
end

params = containers.Map;
id = sprintf('C%d', d);
d = d + 1;
expr = {id, '('};

for i=1:numel(tree) - 1
    node = tree{i};    
    if iscell(node)
        [subexpr, subparams, d ] = hac.fpdf.expr( node, d );
        expr{end+1} = subexpr;
        params = [params; subparams];                
    else
        expr{end+1} = sprintf('u%d', node);
    end     
    
    if i < numel(tree) - 1
       expr{end+1} = ','; 
    end
end

expr{end+1} = ')';
expr = strjoin(expr);
params(id) = tree{end};

end

