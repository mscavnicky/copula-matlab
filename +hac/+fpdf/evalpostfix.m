function [ Y ] = evalpostfix( family, U, postexpr, terms, params )

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

