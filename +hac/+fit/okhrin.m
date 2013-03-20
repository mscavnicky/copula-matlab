function [ tree ] = okhrin( family, U, method )
%HAC.FIT.OKHRIN Find HAC copula using Okhrin's greedy method [1].
%   Uses only bivariate copula and does not perform joins as Okhrin
%   suggests. To obtain valid HAC parameter space is shortened for outer
%   copulas.

% Map for storing nested copulas
copulas = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
% Dimensions of the copula
d = size(U, 2);
% Variables available for fit
vars = 1:d;

copulaNumber = d;
while length(vars) > 1
    copulaNumber = copulaNumber + 1;
    dbg('hac.fit', 4, 'Iteration %d - %s.\n', copulaNumber - d, mat2str(vars));
    
    % Find the best fit available for current vars 
    [ nestedVars, nestedAlpha ] = chooseCopula( family, U, vars, copulas, d, method );
    
    % Compute output of chocsen nested copula and append it to the data sample
    U = [U archim.cdf( family, U(:, abs(nestedVars)), nestedAlpha )];
    
    % Insert it into cache using HAC format
    copulas(copulaNumber) = num2cell([nestedVars, nestedAlpha]);    
    
    % Remove variables used in nested copula and introduce new for the copula
    vars = [setdiff(vars, abs(nestedVars)), copulaNumber];
end

% Recursively build the HAC structure using partial copulas
% Keep vars as a queue of variables to process
% The single remaining var has an index to copula
tree = buildHacStructure( copulas(vars(1)), copulas );

end

function [ maxVars, maxAlpha ] = chooseCopula( family, U, vars, copulas, d, method )
%CHOOSECOPULA Tries to find the combination of variables that gives the
%highest alpha possible.
    
maxVars = [];
maxAlpha = -1;

% Generate combinations of variables of length 2
combinations = combnk(vars, 2);
% Go over each combination and compute its fit
for j = 1:size(combinations, 1)
    comb = combinations(j,:);   
    
    dbg('hac.fit', 5, '* Evaluating combination %s ... \n', mat2str(comb));
    % Make sure we are using valid upper bound
    [ lowerBound, upperBound ] = hac.bounds( family );    
    upperBound = min( upperBound, childAlpha( copulas, comb ) );
    
    % Perform using valid bounds and given combination
    alpha = archim.fit( family, U(:, comb), lowerBound, upperBound );
    dbg('hac.fit', 5, '%f\n', alpha);
    
    if alpha > maxAlpha
       maxVars = comb;
       maxAlpha = alpha;
    end
    
    % Rotated left
    if strcmp(method, 'okhrin*') && comb(1) <= d        
        alpha = archim.fit( family, [1-U(:, comb(1)) U(:, comb(2))], lowerBound, upperBound );
        
        if alpha > maxAlpha
            maxVars = comb .* [-1 1];
            maxAlpha = alpha;
        end
    end
    
    % Rotated right
    if strcmp(method, 'plot') && comb(2) <= d        
        alpha = archim.fit( family, [U(:, comb(1)) 1-U(:, comb(2))], lowerBound, upperBound );
        
        if alpha > maxAlpha
            maxVars = comb .* [1 -1];
            maxAlpha = alpha;
        end        
    end
end

end

function [ alpha ] = childAlpha( copulas, comb )
%CHILDALPHA Given list of already generated copulas and a list of newly
%proposed copulas returns minimum value of their alphas.
alpha = Inf;
for i=1:length(comb)
   c = comb(i);
   % Only variables that represent child copulas are interesting
   if isKey( copulas, c )
       childCopula = copulas(c);
       childAlpha = childCopula{end};
       alpha = min(alpha, childAlpha);
   end
end
end


function [ tree ] = buildHacStructure( rootCopula, nestedCopulas )
    tree = {};
    % Iterate over all variables in the rootCopula and expand them
    for i=1:length(rootCopula)-1
       var = rootCopula{i};
       if nestedCopulas.isKey(var)
           tree{end+1} = buildHacStructure( nestedCopulas(var), nestedCopulas );
       else
           tree{end+1} = var;
       end
    end
    % Copy alpha into built HAC structure
    tree{end+1} = rootCopula{end};
end