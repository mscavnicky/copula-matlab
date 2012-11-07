function [ hac ] = hacfit( family, U )
%HACFIT Fits sample to Hierachical Archimedean Copula. Return tree.
%   Uses method by Okhrin to select HAC structure. HAC structure and alphas
%   are all encoded in resulting parameters.

% Expose subfunctions for unit-testing
if nargin == 0
   hac = {@findBestFit, @generateBinaryTrees}; 
   return;
end

d = size(U, 2);
vars = 1:d;
hac = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
iteration = 0;

while length(vars) > 1
    % Number of this fit
   iteration = iteration + 1;
   fitNumber = d + iteration;
   fprintf('Iteration %d - %s.\n', iteration, mat2str(vars));
   % Find the best fit available for current vars 
   [ bestComb, bestAlpha ] = findBestFit( family, U, vars );   
   % Insert it into cache
   hac(fitNumber) = { bestAlpha, bestComb };
   % Add new column based on variables in best fit our data sample   
   U = [U archimcdf( family, U(:, bestComb), bestAlpha )];
   % Update vars
   vars = [setdiff(vars, bestComb), fitNumber];    
end


end


function [ trees ] = generateBinaryTrees( d )
%GENERATETREES Generate all possible binary trees of d-dimensional copulas

% Return tree node when dimension is 1
if d == 1
    trees = {'x'};
    return;
end

trees = {};
for i=1:(d-1)      
    lefts = generateBinaryTrees(i);
    rights = generateBinaryTrees(d-i);
    for l=1:length(lefts)
        for r=1:length(rights)
            trees{end+1} = { lefts{l}, rights{r} }; %#ok<AGROW>
        end
    end
end

end


function [ maxComb, maxAlpha ] = findBestFit( family, U, vars )
%FINDBESTFIT Tries to find the combination of variables that gives the
%highest alpha possible.
    
maxComb = [];
maxAlpha = 0;

% Generate combinations of variables of length 2 and more
for k = 2:length(vars)
    combinations = combnk(vars, k);
    % Go over each combination and compute its fit
    for j = 1:size(combinations, 1)
        comb = combinations(j,:);
        fprintf('* Evaluating combination %s ... ', mat2str(comb));
        alpha = archimfit( family, U(:, comb) );
        fprintf('%f\n', alpha);
        if alpha > maxAlpha
           maxComb = comb;
           maxAlpha = alpha;
        end
    end    
end

end

