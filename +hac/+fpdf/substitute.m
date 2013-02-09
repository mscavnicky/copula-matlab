function [ newexpr, terms ] = substitute( expr )
%HAC.SYM.SUBSTITUTE Substitutes derivations with symbols.
%   Take symbolic expression of derived functions and replaces all derived
%   functions with different symbols. Returns both new expression and
%   substitutions.
%
%   Note that function does not take into account parenthesis and may
%   return invalid expression in aliases array.

%#ok<*AGROW>

terms = containers.Map;

summands = regexp(expr, '\+', 'split');
newsummands = {};
for i = 1:numel(summands)
    summand = summands{i};    
    factors = regexp(summand, '\*', 'split');
    newfactors = {};
    for j = 1:numel(factors)
        factor = strtrim(factors{j});
        
        exponent = 0;
        if regexp(factor, '\^') > 1
            tokens = regexp(factor, '\^', 'split');
            factor = tokens{1};
            exponent = tokens{2};            
        end
        
        if regexp(factor, '^D\(\[[0-9, ]+\], C[0-9]+\)\([0-9Cu, ()]+\)$')
            alias = sprintf('t_%d_%d', i, j);
            terms(alias) = factor;
            if exponent == 0
                newfactors{end+1} = alias;            
            else
                newfactors{end+1} = sprintf('%s^%s', alias, exponent);
            end            
        elseif regexp(factor, '^diff\(C[0-9]+\([0-9u,() ]+\),[0-9u,() ]+\)$')
            alias = sprintf('t_%d_%d', i, j);
            terms(alias) = factor;
            if exponent == 0
                newfactors{end+1} = alias;            
            else
                newfactors{end+1} = sprintf('%s^%s', alias, exponent);
            end 
        elseif regexp(factor, '^[0-9]+$')
            newfactors{end+1} = factor;
        else
            error('Unexpected symbolic expression %s', factor);
        end
    end  
    
    newsummands{end+1} = strjoin(newfactors, '*');
end

newexpr = strjoin(newsummands, '+');

end

