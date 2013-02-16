function [ alphahat ] = fit( family, U, lowerBound, upperBound )
%ARCHIMFIT Fit multivariate archimedean copula to data.
%   Data must be within interval [0, 1]. Returns value of fitted parameters
%   and likelihood of fit to data. Minimization is performed using fminbnd
%   method which requires methods to be continuouos.

% Function giving likelihood of the sample for given alpha
optimfun = @(alpha) loglike(archim.pdf( family, U, alpha ));

% Get bound for Archimedean copula family in this dimension
if nargin < 3
    [ lowerBound, upperBound ] = archim.bounds( family, size(U, 2) );
end

% Debugging function plot
if 0
    L = linspace(0.1, min(upperBound, 20), 100);
    fig = figure;
    plot(L, arrayfun( @(alpha)(loglike(archim.pdf( family, U, alpha ))), L));
    pause(10);
    close(fig);
end

% Find some reasonable upper bound
if upperBound == Inf
    newUpperBound = 4;    
    while optimfun(newUpperBound) > optimfun(newUpperBound * 2)
        newUpperBound = newUpperBound * 2;
    end
    upperBound = newUpperBound * 2;
end

alphahat = estimateAlpha(optimfun, max(lowerBound, -10), upperBound);

if abs(alphahat - upperBound) < 0.01
    warning('archim:fit:alpha', 'Estimated alpha too close to upper bound.');
end

end

function [ alphahat ] = estimateAlpha(fun, lowerBound, upperBound)
[ alphahat, ~, exitflag ] = fminbnd(fun, lowerBound, upperBound, statset('copulafit'));
if exitflag ~= 1
    erorr('Minimazation did not converge properly.')
end
end