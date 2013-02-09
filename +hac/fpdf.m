function [ Y ] = fpdf( family, U, tree )
%HACPDF Probability distribution function of family of HAC.
%   Derives and evalutes symbolic expression of density function for given
%   HAC.

%#ok<*AGROW>

% Compose high level symbolic functions
[expr, params] = hac.fpdf.expr(tree);

% Perform its derivations in all variables
fexpr = sym(expr);
vars = symvar(fexpr);
for i=1:numel(vars)
    fexpr = diff(fexpr, vars(i));
end

% Replace terms inside it with variables
[inexpr, terms] = hac.fpdf.substitute(char(fexpr));

% Convert infix expression into its postfix form
postexpr = hac.fpdf.in2post(inexpr);

% Initialized empty cdf cache
cdfcache = containers.Map;
% Evaluate the postfix form
stack = coll.Stack();

for i=1:numel(postexpr)
    token = postexpr{i};
    
    if regexp(token, '\+|\*|\^') == 1
        T2 = stack.pop();
        T1 = stack.pop();
        
        if strcmp(token, '+')
            T = T1 + T2;
        elseif strcmp(token, '*')
            T = T1 .* T2;
        elseif strcmp(token, '^')
            T = T1 .^ T2;
        end
        
        stack.push(T);        
        
    elseif regexp(token, 't_[0-9]+_[0-9]+') == 1
        term = terms(token);        
        [T, cdfcache] = hac.fpdf.evalterm(family, term, U, params, cdfcache);
        stack.push(T);
    else
        [T, cdfcache] = hac.fpdf.evalterm(family, token, U, params, cdfcache);
        stack.push(T);
    end    
end

if stack.size() ~= 1
    error('Implementation error in hacfpdf.');
end

Y = stack.pop();

end