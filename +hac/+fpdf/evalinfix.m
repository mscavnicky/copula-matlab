function [ Y ] = evalinfix( family, U, expr, params )

n = size(U, 1);
Y = zeros(n, 1);

cdfcache = containers.Map;

summands = regexp(expr, '\+', 'split');
for i = 1:numel(summands)    
    summand = summands{i};
    S = ones(n, 1);
    
    factors = regexp(summand, '\*', 'split');    
    for j = 1:numel(factors)
        factor = factors{j};
        
        if regexp(factor, '\^') > 0
            tokens = regexp(factor, '\^', 'split');
            
            factor = tokens{1};
            exponent = sscanf(tokens{2}, '%d');            
                        
            [F, cdfcache] = hac.fpdf.evalterm(family, factor, U, params, cdfcache);
            E = repmat(exponent, n, 1);
            S = S .* (F .^ E);       
        else
            [F, cdfcache] = hac.fpdf.evalterm(family, factor, U, params, cdfcache);
            S = S .* F;
        end
    end  
    
    Y = Y + S;
end

end

