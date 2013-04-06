function [ Y ] = evaluateDerivative( family, U, expr, params )
%HAC.FPDF.EVALUATEDERIVATIVE Evaluate the derivative of symbolic hac
%expression in infix form.
%   Function caches intermediate results of the computation.

n = size(U, 1);
Y = zeros(n, 1);

% Cache for compute values of cdf for different parts of the tree
cdfCache = containers.Map;
% Cache for factors in the derivated expression.
% For bivariate copulas contains up to d*5 expressions.
factorCache = containers.Map;

% We assume differentiated expression is given in an infix form without
% brackets. Expression is split into single terms and evaluated.
summands = regexp(expr, ' \+ ', 'split');
for i = 1:numel(summands);    
    summand = summands{i};
    S = ones(n, 1);
    
    factors = regexp(summand, '\*', 'split');    
    for j = 1:numel(factors)
        factor = factors{j};        
        
        % Some factors contain exponentiation
        exponent = 1;
        if regexp(factor, '\^') > 0
            tokens = regexp(factor, '\^', 'split');
            
            factor = tokens{1};
            exponent = sscanf(tokens{2}, '%d');
        end        
        
        % Evaluate factor or get it from the cache
        if isKey(factorCache, factor)
            F = factorCache(factor);
        else        
            % Evaluate factor of the expression
            [F, cdfCache] = hac.fpdf.evaluateFactor(family, factor, U, params, cdfCache);
            % Store evaluated factor in the cache
            factorCache(factor) = F;
        end
        
        % Exponentiate factor it necessary
        if exponent > 1
            E = repmat(exponent, n, 1);
            F = F .^ E;       
        end
            
        % Get the intermediate result
        S = S .* F;
    end
    
    % Get the intermediate result
    Y = Y + S;
end

end

