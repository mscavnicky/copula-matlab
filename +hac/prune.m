function [ prunedTree ] = prune( tree, m )
%HAC.PRUNE Recursively prunes bivariate HAC tree to contain m variables.
%   Uses property of bivariate Archimedean copula that C(u,1) = u.

assert(numel(tree) <= 4, 'HAC.PRUNE:TooManyDimensions', 'Pruning only works for bivariate HAC.');

if iscell(tree)
   prunedLeft = hac.prune(tree{1}, m);
   prunedRight = hac.prune(tree{2}, m);
   alpha = tree{3};
   
   if iscell(prunedLeft) && iscell(prunedRight)
       prunedTree = {prunedLeft prunedRight alpha};
   elseif iscell(prunedLeft)
       if prunedRight == 0
           prunedTree = prunedLeft;
       else
           prunedTree = {prunedLeft prunedRight alpha};
       end    
   elseif iscell(prunedRight)
       if prunedLeft == 0
           prunedTree = prunedRight;
       else
           prunedTree = {prunedLeft prunedRight alpha};
       end
   else
       if prunedLeft ~= 0 && prunedRight ~= 0
           prunedTree = {prunedLeft prunedRight alpha};
       else
           prunedTree = prunedLeft + prunedRight;
       end       
   end
else
   % Replace pruned variable with zero
   if tree > m
       prunedTree = 0;
   else
       prunedTree = tree;
   end      
end

end