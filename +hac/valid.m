function [ isValid ] = valid( tree )
%HAC.VALID Performs validation of the requirement HAC
%   Verifies the assumption that the alpha of the parent copula has to
%   be larger than the alpha of the child copula.

isValid = 1;
% Alpha for this copula level
alpha = tree{end};
% Go over all nested copulas and check their alpha
for i=1:numel(tree)-1
    % Perform recursion if element of structure is another copula
    child = tree{i};
    if iscell(child)
        if alpha >= child{end}
            isValid = 0;
            return;
        end
        
        if ~hac.valid(child)
            isValid = 0;
            return;
        end
    end        
end

end

