function [ fits ] = hacfit( family, U )
%HACFIT Fits sample to Hierachical Archimedean Copula. Return tree.
%   Uses method by Okhrin to select HAC structure. Tree structure and alpha
%   are all encoded in tree structure that is using cell arrays.

[~, d] = size(U);
vars = 1:d;
fits = containers.Map;
iteration = 0;

while length(vars) > 1
    % Number of this fit
   iteration = iteration + 1;
   fitNumber = d + iteration;
   fprintf('Iteration %d - %s.\n', iteration, mat2str(vars));
   % Find the best fit available for current vars 
   [ bestComb, bestAlpha ] = findBestFit( family, U, vars );   
   % Insert it into cache
   fits(int2str(fitNumber)) = { bestAlpha, bestComb };
   % Add new column based on variables in best fit our data sample   
   U = [U archimcdf( family, U(:, bestComb), bestAlpha )];
   % Update vars
   vars = [setdiff(vars, bestComb), fitNumber];    
end


function [ minComb, minAlpha ] = findBestFit( family, U, vars )
minComb = [];
minAlpha = 0;
minLogLike = 1e12;

% Generate combinations of variables of length 2 and more
for k = 2:length(vars)
    combinations = combnk(vars, k);
    % Go over each combination and compute its likelihood
    for j = 1:size(combinations, 1)
        comb = combinations(j,:);        
        fprintf('* Evaluating combination %s ... ', mat2str(comb));
        [ alpha, ll ] = archimfit( family, U(:, comb) );
        fprintf('%f\n', ll);
        if ll < minLogLike
           minComb = comb;
           minAlpha = alpha;
           minLogLike = ll;
        end
    end    
end

end

end

