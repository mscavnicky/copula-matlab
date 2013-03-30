function [ P ] = preprocess( family, X, method )
%HAC.PREPROCESS

family = family(1:end-4);

% Fit margins and rotated margins
if strcmp(method, 'CML')
    U = uniform(X);
    V = uniform(-X);
elseif strcmp(method, 'IFM');
    margins = fitmargins(X);
    U = pit(X, {margins.ProbDist});
    rotatedMargins = fitmargins(-X);
    V = pit(-X, {rotatedMargins.ProbDist});   
else
    error('Method %s not recognized.', method);
end

% Map for storing nested copulas
copulas = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
% Dimensions of the copula
d = size(U, 2);
% Variables available for fit
vars = 1:d;
% Rotated variables
rotations = [];

num = d;
while length(vars) > 1
    num = num + 1;
    dbg('hac.fit', 4, 'Iteration %d - %s.\n', num, mat2str(vars));
    
    % Find the best fit available for current vars
    [ newVars, newAlpha, newRotations ] = chooseCopula( family, U, V, vars, copulas, d );
    % Append rotations
    rotations = [rotations newRotations]; %#ok<AGROW>
    % Compute value of the new attribute
    W = archim.cdf( family, U(:, newVars), newAlpha );
    % Append new attributes to sample data
    U = [U W]; %#ok<AGROW>
    % Store new copula in copulas map
    copulas(num) = num2cell([newVars, newAlpha]);
    % Remove variables used in nested copula and introduce new for the copula
    vars = [setdiff(vars, newVars), num];
end

% Compose the rotation matrix
P = zeros(d);
for i=1:size(X, 2)       
    if ~ismember(i, rotations)
        P(i,i) = 1;
    else
        P(i,i) = -1;
    end        
end

end

function [ vars, maxAlpha, rotations ] = chooseCopula( family, U, V, availableVars, copulas, d )
%CHOOSECOPULA Tries to find the combination of variables that gives the
%highest alpha possible.

vars = [];
maxAlpha = -Inf;
rotations = [];

% Generate combinations of variables of length 2
combinations = combnk(availableVars, 2);
% Go over each combination and compute its fit
for k = 1:size(combinations, 1)
    i = combinations(k,1);
    j = combinations(k,2);
    
    
    dbg('hac.fit', 5, '* Evaluating combination [%d, %d] ... \n', i, j);
    % Make sure we are using valid upper bound
    [ lowerBound, upperBound ] = hac.bounds( family );    
    upperBound = min( upperBound, childAlpha( copulas, [i j] ) );
    
    % Perform using valid bounds and given combination
    alpha = archim.fit( family, U(:, [i j]), lowerBound, upperBound );
    dbg('hac.fit', 5, '%f\n', alpha);
    
    if alpha > maxAlpha
       vars = [i j];
       maxAlpha = alpha;
       rotations = [];
    end
    
    % Rotation right
    if i <= d        
        alpha = archim.fit( family, [V(:, i) U(:, j)], lowerBound, upperBound );
        
        if alpha > maxAlpha   
            vars = [i j];
            maxAlpha = alpha;
            rotations = i;
        end
    end
    
    % Rotation left
    if j <= d
        alpha = archim.fit( family, [U(:, i) V(:, j)], lowerBound, upperBound );
        
        if alpha > maxAlpha 
            vars = [i j];
            maxAlpha = alpha;
            rotations = j;
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