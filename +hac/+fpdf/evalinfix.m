function [ Y ] = evalinfix( family, U, expr, params, cacheLevel )

n = size(U, 1);
Y = zeros(n, 1);

% Cache for copula cdf results
cdfcache = containers.Map;
% Cache for simple derivations
% Containts up to d*5 expressions for bivariate copulas
diffcache = containers.Map;

summands = regexp(expr, ' \+ ', 'split');
for i = 1:numel(summands);    
    summand = summands{i};
    S = ones(n, 1);
    
    factors = regexp(summand, '\*', 'split');    
    for j = 1:numel(factors)
        factor = factors{j};
        
        if regexp(factor, '\^') > 0
            tokens = regexp(factor, '\^', 'split');
            
            factor = tokens{1};
            exponent = sscanf(tokens{2}, '%d');            
                        
            [F, cdfcache, diffcache] = hac.fpdf.evalterm(family, factor, U, params, cdfcache, diffcache, cacheLevel);
            E = repmat(exponent, n, 1);
            S = S .* (F .^ E);       
        else
            [F, cdfcache, diffcache] = hac.fpdf.evalterm(family, factor, U, params, cdfcache, diffcache, cacheLevel);
            S = S .* F;
        end
    end
    
    Y = Y + S;
end

end

