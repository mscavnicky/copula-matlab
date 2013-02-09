function [ Y ] = evalcdf( expr, family, U, params )
%HAC.FPDF Evaluate copula cdf expression
%   Example C1(C2(u1, u3), u4) which is an expression in a prefix notation.

stack = coll.Stack;    

while ~isempty(expr)
    if regexp(expr, '^C[0-9]+') > 0
        id = regexp(expr, '^C[0-9]+', 'match');
        id = id{1};
        stack.push(id);
        expr = expr(numel(id)+1:end);
    elseif expr(1) == '('
        expr = expr(2:end);
    elseif regexp(expr, '^u[0-9]+') > 0
        var = regexp(expr, '[0-9]+', 'match');
        var = var{1};
        u = U(:, str2num(var));
        stack.push(u);
        expr = expr(numel(var)+2:end);    
    elseif expr(1) == ')'
        % Pop symbols
        V = [];
        while ~ischar(stack.peek())
            V = [V stack.pop()];
        end
        id = stack.pop();
        
        stack.push(archim.cdf(family, V, params(id)));
        expr = expr(2:end);
    elseif strcmp(expr(1:2), ', ')
        expr = expr(3:end);
    else 
       error('Invalid copula expression %s.', expr);            
    end   
end

if stack.empty() == 1
    error('Cdf expression not correct.');    
end

cells = stack.content();
Y = horzcat(cells{:});

end

