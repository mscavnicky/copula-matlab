function [ alphahat ] = fit( family, U, lowerBound, upperBound )
%ARCHIMFIT Fit multivariate archimedean copula to data.
%   Data must be within interval [0, 1]. Returns value of fitted parameters
%   and likelihood of fit to data. Minimization is performed using fminbnd
%   method which requires methods to be continuouos. This assumption should
%   be checked in Nelsen.

% Function giving likelihood of the sample for given alpha
fun = @(alpha) loglike(archim.pdf( family, U, alpha ));

% Get bound for Archimedean copula family in this dimension
if nargin < 3
    [ lowerBound, upperBound ] = archim.bounds( family, size(U, 2) );
end

% Debugging function plot
if 0
    L = linspace(max(lowerBound, -10), min(upperBound, 10), 100);
    fig = figure;
    plot(L, arrayfun( @(alpha)(loglike(archim.pdf( family, U, alpha ))), L));
    pause(10);
    close(fig);
end

% Perform the actual minimization using clipped bounds
alphahat = estimateAlpha(fun, max(lowerBound, -10), min(upperBound, 10));
if abs(alphahat) > 9.9
    %warning('Alpha limit too small %f.', alphahat);
    alphahat = estimateAlpha(fun, max(lowerBound, -100), min(upperBound, 100));
    if abs(alphahat) > 99.9
        warning('Alpha not estimated correctly %f.', alphahat);
    end
end

end

function [ alphahat ] = estimateAlpha(fun, lowerBound, upperBound)
[ alphahat, ~, exitflag ] = fminbnd(fun, lowerBound, upperBound);
if exitflag ~= 1
    erorr('Minimazation did not converge properly.')
end
end