function [ P ] = preprocess( family, X, method )
%HAC.PREPROCESS Preprocess function based on modified Okhrin's algorithm.
%   Given an input sample and a fitting method runs modified Okhrin's
%   algorithm and returns a diagonal matrix which can be used to preprocess
%   the input sample.

% Fit both original margins and negated margins
if strcmp(method, 'CML')
    U = pseudoObservations(X);
    V = pseudoObservations(-X);
elseif strcmp(method, 'IFM');
    U = probabilityTransform(X, fitMargins(X));
    V = probabilityTransform(-X, fitMargins(-X));
else
    error('Method %s not recognized.', method);
end

% Dimensions of the copula
d = size(U, 2);
% Map for storing alphas
alphas = containers.Map('KeyType', 'int32', 'ValueType', 'double');
% Variables available for fit
vars = 1:d;
% Rotated variables
rotations = [];

num = d;
while length(vars) > 1
    num = num + 1;
    dbg('hac.fit', 4, 'Iteration %d - %s.\n', num, mat2str(vars));
    
    % Find the best fit available for current vars
    [ pair, alpha, newRotations ] = choosePair( family, U, V, vars, alphas, d );
    
    % Append rotations
    rotations = [rotations newRotations]; %#ok<AGROW>
    
    % Append new attributes to sample data
    U = [U archim.cdf( family, U(:, pair), alpha )]; %#ok<AGROW>
    
    % Append new pseudo-attribute and remove chosen pair
    vars = [setdiff(vars, pair), num];

    % Store new existing alpha for future reference
    alphas(num) = alpha;
end

% Compose the rotation matrix
P = eye(d);
P(rotations, rotations) = (-1) * P(rotations, rotations);

end

function [ vars, maxAlpha, rotations ] = choosePair( family, U, V, availableVars, alphas, d )
%CHOOSEPAIR Tries to find the combination of variables that gives the
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
    
    % Make sure we are using valid upper bound
    [ lowerBound, upperBound ] = hac.bounds( family );    
    upperBound = min( upperBound, childAlpha( alphas, [i j] ) );
    
    % Perform using valid bounds and given combination
    alpha = archim.fit( family, U(:, [i j]), lowerBound, upperBound );
    
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

function [ alpha ] = childAlpha( alphas, vars )
%CHILDALPHA Given list of already generated copulas and a list of newly
%proposed copulas returns minimum value of their alphas.
alpha = Inf;
for i=1:length(vars)
   if isKey( alphas, vars(i) )
       alpha = min(alpha, alphas(vars(i)));
   end
end
end