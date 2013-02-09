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

%Evaluate the postfix form
stack = {};
len = 0;

for i=1:numel(postexpr)
    token = postexpr{i};
    
    if regexp(token, '\+|\*|\^') == 1
        T2 = stack{len};
        len = len - 1;       
        T1 = stack{len};
        len = len - 1;        
        
        if strcmp(token, '+')
            T = T1 + T2;
        elseif strcmp(token, '*')
            T = T1 .* T2;
        elseif strcmp(token, '^')
            T = T1 .^ T2;
        end
        
        len = len + 1;
        stack{len} = T;                
        
    elseif regexp(token, 't_[0-9]+_[0-9]+') == 1
        term = terms(token);        
        T = hac.fpdf.evalterm(family, term, U, params);
        
        len = len + 1;
        stack{len} = T;        
    else
        len = len + 1; 
        stack{len} = hac.fpdf.evalterm(family, token, U, params);              
    end    
end

if len ~= 1
    error('Implementation error in hacfpdf.');
end

Y = stack{1};

end