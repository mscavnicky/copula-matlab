function [ alphaHat ] = fit( family, U, lowerBound, upperBound )
%ARCHIM.FIT Fit a multivariate archimedean copula to data.
%   Data must be within interval [0, 1]. Returns value of fitted parameters
%   and likelihood of fit to data. Minimization is performed using fminbnd
%   method which requires likelihood method to be continuouos. If bound are
%   not provided default bounds for the copula family are used.

% Function giving likelihood of the sample for given alpha
optimfun = @(alpha) -sum(log((archim.pdf(family, U, alpha))));

% Get bound for Archimedean copula family in this dimension
if nargin < 3
    [ lowerBound, upperBound ] = archim.bounds( family, size(U, 2) );
end

% If upperBound is infinite, estimate some closer upperBound
originalUpperBound = upperBound;
if upperBound == Inf
    newUpperBound = 4;    
    while optimfun(newUpperBound) > optimfun(newUpperBound * 2)
        newUpperBound = newUpperBound * 2;
    end
    upperBound = newUpperBound * 2;
end

% Estimate the alpha using MATLAB's optimization methods
alphaHat = estimateAlpha(optimfun, max(lowerBound, -10), upperBound);

% Issue a warning if upper bound was estimated incorrectly
if originalUpperBound == Inf && abs(alphaHat - upperBound) < 0.001
    warning('archim:fit:alpha', 'Estimated alpha too close to the upper bound.');
end

end

function [ alphahat ] = estimateAlpha(fun, lowerBound, upperBound)
[ alphahat, ~, exitflag ] = fminbnd(fun, lowerBound, upperBound, statset('copulafit'));
if exitflag ~= 1
    erorr('Minimazation did not converge properly.')
end
end