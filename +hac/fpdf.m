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
stack = {};
top = 0;

for i=1:numel(postexpr)
    token = postexpr{i};
    
    if regexp(token, '\+|\*|\^') == 1
        T2 = stack{top}; top = top - 1;
        T1 = stack{top}; top = top - 1;
        
        if strcmp(token, '+')
            T = T1 + T2;
        elseif strcmp(token, '*')
            T = T1 .* T2;
        elseif strcmp(token, '^')
            T = T1 .^ T2;
        end
        
        top = top + 1; stack{top} = T;
    elseif regexp(token, 't_[0-9]+_[0-9]+') == 1
        term = terms(token);        
        [T, cdfcache] = hac.fpdf.evalterm(family, term, U, params, cdfcache);
        top = top + 1; stack{top} = T;
    else
        [T, cdfcache] = hac.fpdf.evalterm(family, token, U, params, cdfcache);
        top = top + 1; stack{top} = T;
    end    
end

if top ~= 1
    error('Implementation error in hacfpdf.');
end

Y = stack{1};

end