function [ Y, cdfcache ] = evalterm( family, term, U, params, cdfcache )
%EVALTERM Evaluate term in derivation expression.
%   There are 3 types of terms: D, diff and constant.

if regexp(term, 'D') > 0
    % Match the first part of the expression
    tokens = regexp(term, 'D\(\[(?<diffvars>[0-9, ]+)\], (?<id>C[0-9]+)\)\((?<vars>[0-9Cu, ()]+)\)', 'names');
    % Extract id, vars and diffvars
    id = tokens.id;
    diffvars = str2vars(tokens.diffvars);    
    expr = tokens.vars;
    
    % Evaluate copula expression
    [V, cdfcache] = hac.fpdf.evalcdf(expr, family, U, params, cdfcache);    
    % Finally evaluate the derivative
    Y = archim.cdfdiff(family, V, params(id), diffvars);       
    
elseif regexp(term, 'diff') > 0
    tokens = regexp(term, 'diff\((?<id>C[0-9]+)\((?<vars>[0-9u,() ]+)\), (?<diffvars>[0-9u,() ]+)\)', 'names');
    
    % Extract id, vars and diffvars
    id = tokens.id;
    diffvars = str2vars(tokens.diffvars);    
    vars = str2vars(tokens.vars); 
    
    % Get indexes of diffvars
    diffvars = find(ismember(vars, diffvars));    
    % Finally evaluate the diff function
    Y = archim.cdfdiff(family, U(:, vars), params(id), diffvars); %#ok<FNDSB>
    
else
    n = size(U, 1);
    Y = repmat(str2double(term), n, 1);
end

end

function [ vars ] = str2vars( str )
    tokens = regexp(str, '[0-9]+', 'match');
    n = numel(tokens);
    
    vars = zeros(n, 1);
    for i=1:n
        vars(i) = str2num(tokens{i});
    end
end