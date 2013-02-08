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
        factor = factors{j};
        
        if regexp(factor, 'D\(\[[0-9, ]+\], C[0-9]+\)\([0-9Cu, ()]+\)')
            alias = sprintf('t_%d_%d', i, j);
            terms(alias) = factor;
            newfactors{end+1} = alias;
        elseif regexp(factor, 'diff\(C[0-9]+\([0-9u,() ]+\),[0-9u,() ]+\)')
            alias = sprintf('t_%d_%d', i, j);
            terms(alias) = factor;
            newfactors{end+1} = alias; 
        elseif regexp(factor, '[0-9]+')
            newfactors{end+1} = strtrim(factor);
        else
            error('Unexpected symbolic expression.');
        end
    end  
    
    newsummands{end+1} = strjoin(newfactors, '*');
end

newexpr = strjoin(newsummands, '+');

end

