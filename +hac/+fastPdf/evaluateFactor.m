function [ Y, cdfCache ] = evaluateFactor( family, factor, U, params, cdfCache )
%HAC.FPDF.EVALUATEFACTOR Evaluate factor of the differentiated expression.
%   There are 3 types of factors: D, diff and constant.

if regexp(factor, 'D') > 0   
    % Match interesting part expression
    tokens = regexp(factor, '^D\(\[(?<diffvars>[0-9, ]+)\], (?<id>C[0-9]+)\)\((?<vars>[0-9Cu, ()]+)\)$', 'names');
    % Extract id, vars and diffvars
    id = tokens.id;
    diffvars = str2vars(tokens.diffvars);    
    expr = tokens.vars;
    
    % Evaluate copula expression
    [V, cdfCache] = hac.fastPdf.evaluateCdf(expr, family, U, params, cdfCache);    
    % Finally evaluate the derivative
    Y = archim.cdfDerivative(family, V, params(id), diffvars);
    
elseif regexp(factor, 'diff') > 0
    % Match interesting part expression
    tokens = regexp(factor, '^diff\((?<id>C[0-9]+)\((?<vars>[0-9u,() ]+)\), (?<diffvars>[0-9u,() ]+)\)$', 'names');
    
    % Extract id, vars and diffvars
    id = tokens.id;
    diffvars = str2vars(tokens.diffvars);    
    vars = str2vars(tokens.vars); 
    
    % Get indexes of diffvars
    diffvars = find(ismember(vars, diffvars));    
    % Finally evaluate the diff function
    Y = archim.cdfDerivative(family, U(:, vars), params(id), diffvars); %#ok<FNDSB>
    
else
    % The term is just a constant.
    n = size(U, 1);
    Y = repmat(sscanf(factor, '%d'), n, 1);
end

end

function [ vars ] = str2vars( str )
    tokens = regexp(str, '[0-9]+', 'match');
    n = numel(tokens);
    
    vars = zeros(n, 1);
    for i=1:n
        vars(i) = sscanf(tokens{i}, '%d');
    end
end