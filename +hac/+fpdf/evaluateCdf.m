function [ Y, cdfCache ] = evaluateCdf( expr, family, U, params, cdfCache )
%HAC.FPDF.EVALCDF Evaluate copula cdf expression
%   Example C1(C2(u1, u3), u4) which is an expression in a prefix notation.

%#ok<*AGROW>

% Stack that is storing intermediate results (matrices) of the computation.
stack = {};
top = 0;

% Process expression in prefix notation until it is empty. Always
% identifies next lexical by analyzing the first characters and does
% according action.
while ~isempty(expr)
    if expr(1) == '('
        % Opening parenthesis is skipped.
        expr = expr(2:end);  
    elseif expr(1) == ','
        % Comma is skipped together with trailing space.
        expr = expr(3:end);
    elseif expr(1) == ')'
        % Closing symbol means evaluation has to take place
        % Pop the stack until you encounter a copula identifier
        V = [];
        while ~ischar(stack{top})
            V = [V stack{top}];
            top = top - 1;
        end
        copulaId = stack{top};
        top = top - 1;
        
        % Compute the result of the copula function
        X = archim.cdf(family, V, params(copulaId));
        % Push it back onto the stack
        top = top + 1;
        stack{top} = X;
        % Cache the result for the future use
        cdfCache(copulaId) = X;
        % Skip the character
        expr = expr(2:end);  
    elseif expr(1) == 'C'
        % We have encountered a copula identifier. This means new
        % subexpressions starts. We can either continue with evaluation or
        % find it in the cache and skip the whole subexpression.
        copulaId = regexp(expr, '^C[0-9]+', 'match');
        copulaId = copulaId{1};
        
        % Copula expression is already in the cache. We can skip the whole
        % expression.
        if isKey(cdfCache, copulaId)
            % Push the evaluated subexpression onto the stack
            top = top + 1;
            stack{top} = cdfCache(copulaId); 
            
            % Now skip the subexpression by counting parenthesis.
            pos = length(copulaId) + 2;            
            parens = 1;            
            while parens > 0
                if expr(pos) == '('
                    parens = parens+1;
                elseif expr(pos) == ')'
                    parens = parens-1;
                end                
                pos = pos + 1;
            end
            
            % Skip the expression
            expr = expr(pos:end);
        else
            % Push copulaId onto the stack
            top = top + 1;
            stack{top} = copulaId;
            % Skip the copula identifier
            expr = expr(numel(copulaId)+1:end);
        end        
    elseif expr(1) == 'u'
        % We have encountered a variable identifier. We want to push its
        % margins onto the stack.
        
        % Find the number of variable
        variableNum = regexp(expr, '[0-9]+', 'match');
        variableNum = variableNum{1};
        % Push margin of this variable onto the stack
        u = U(:, sscanf(variableNum, '%d'));
        top = top + 1;
        stack{top} = u;
        
        % Skip the variable expression
        expr = expr(numel(variableNum)+2:end);    
    else 
       error('Invalid copula expression %s.', expr);            
    end   
end

% After analyzing the expression stack should not be empty.
if top == 0
    error('Invalid cdf expression.');    
end

Y = horzcat(stack{1:top});

end

