function [ Y, cdfcache ] = evalcdf( expr, family, U, params, cdfcache )
%HAC.FPDF Evaluate copula cdf expression
%   Example C1(C2(u1, u3), u4) which is an expression in a prefix notation.

stack = {};
top = 0;

while ~isempty(expr)
    if regexp(expr, '^C[0-9]+') > 0
        id = regexp(expr, '^C[0-9]+', 'match');
        id = id{1};
        
        if isKey(cdfcache, id)
            top = top + 1;
            stack{top} = cdfcache(id);
            
            % Skip id and first parenthesis;
            pos = length(id) + 2;            
            parens = 1;            
            while parens > 0
                if expr(pos) == '('
                    parens = parens+1;
                elseif expr(pos) == ')'
                    parens = parens-1;
                end                
                pos = pos + 1;
            end
            
            expr = expr(pos:end);
        else
            top = top + 1;
            stack{top} = id;
            expr = expr(numel(id)+1:end);
        end        
    elseif expr(1) == '('
        expr = expr(2:end);
    elseif regexp(expr, '^u[0-9]+') > 0
        var = regexp(expr, '[0-9]+', 'match');
        var = var{1};
        u = U(:, str2num(var));
        top = top + 1;
        stack{top} = u;
        expr = expr(numel(var)+2:end);    
    elseif expr(1) == ')'
        % Pop symbols
        V = [];
        while ~ischar(stack{top})
            V = [V stack{top}];
            top = top - 1;
        end
        id = stack{top};
        top = top - 1;
        
        X = archim.cdf(family, V, params(id));
        top = top + 1;
        stack{top} = X;
        cdfcache(id) = X;
        expr = expr(2:end);
    elseif strcmp(expr(1:2), ', ')
        expr = expr(3:end);
    else 
       error('Invalid copula expression %s.', expr);            
    end   
end

if top == 0
    error('Cdf expression not correct.');    
end

Y = horzcat(stack{1:top});

end

