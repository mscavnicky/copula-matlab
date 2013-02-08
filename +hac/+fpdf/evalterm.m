function [ Y ] = evalterm( family, term, U, params )
%EVALTERM Evaluate term in derivation expression.
%   There are 3 types of terms: D, diff and constant.

if strfind(term, 'D') == 1
    % Match the first part of the expression
    matches = regexp(term, 'D\(\[(?<diffvars>[0-9, ]+)\], (?<id>C[0-9]+)\)\((?<vars>[0-9Cu, ()]+)\)', 'names');
    % Extract id, vars and diffvars
    id = matches.id;
    diffvars = str2vars(matches.diffvars);    
    vars = regexp(match.vars, ', ', 'split');
    
    % Compute subcopulas used as arguments
    n = size(U, 1);
    d = numel(vars);
    V = zeros(n ,d);
    
    for i=1:d
       V(:,i) = evalcdf(vars{i});       
    end
    
    % Finally evaluate the derivative
    Y = archim.cdfdiff(family, V, params(id), diffvars);       
    
elseif strfind(term, 'diff') == 1
    % Strip diff keyword and parenthesis
    term = term(6:end-1);
    
    % Extract copula function identifier
    id = regexp(term, 'C[0-9]+', 'match');
    % Remove the identifier from the term
    term = term(length(id)+1:end);
    
    % Extract function variables
    vars = regexp(term, '\(.*\)', 'match');    
    % Rest of the term is diffvars
    diffvars = term(length(vars)+3:end);    
    
    % Process vars into numbers
    vars = str2vars(vars);
    % Process diffvars into numbers
    diffvars = str2vars(diffvars);
    
    % Get indexes of diffvars
    diffvars = find(ismember(vars, diffvars));    
    % Finally evaluate the diff function
    Y = archim.cdfdiff(family, U(:, idx), params(id), diffvars); %#ok<FNDSB>
    
else
    n = size(U, 1);
    Y = repmat(n, 1, str2double(term));
end

end

function [ vars ] = str2vars( str )
    tokens = regexp(str, '[0-9]+', 'match');
    n = numel(tokens);
    
    vars = zeros(n, 1);
    for i=1:n
        vars(i) = str2int(tokens{i});
    end
end