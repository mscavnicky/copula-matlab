function [ alphahat, ll ] = archimfit( family, U )
%ARCHIMFIT Fit multivariate archimedean copula to data.
%   Data must be within interval [0, 1]. Returns value of fitted parameters
%   and likelihood of fit to data. Minimization is performed using fminbnd
%   method which requires methods to be continuouos. This assumption should
%   be checked in Nelsen.

% Function giving likelihood of the sample for given alpha
fun = @(alpha) loglike(archimpdf( family, U, alpha ));

% Get bound for Archimedean copula family in this dimension
[ lowerBound, upperBound ] = archimbounds( family, size(U, 2) );

% If the lower bound is infinite, approximate some closer parameter
if lowerBound == -Inf
    [~, lowerBound] = estimateBounds(fun, 5, -5); % 'lower', search descending from -5
    if ~isfinite(lowerBound)
        error('Unable to find a lower bound for the estimate of the copula parameter.');
    end
end

% If the upper bound is infinite, again approximate closer parameter
if upperBound == Inf
    [lowerBound, upperBound] = estimateBounds(fun, lowerBound, 5); % 'upper', search ascending from 5
    if ~isfinite(upperBound)
        error('Unable to find an upper bound for the estimate of the copula parameter.');
    end
end

dbg('Bounds for this minimization: [%f, %f]\n', lowerBound, upperBound);

%DEBUG PLOT
%a = linspace(lowerBound, upperBound, 100);
%plot(a, arrayfun( @(alpha)(loglike(archimpdf( family, U, alpha ))), a));

% Perform the actual minimization
[alphahat, ll, exitflag] = fminbnd(fun, lowerBound, upperBound);
if exitflag ~= 1
    erorr('Minimazation did not converge properly.')
end    

end

function [ nearBnd, farBnd ] = estimateBounds(nllFun, nearBnd, farStart)
% ESTIMATEBOUNDS the minimizer of a (one-param) negative log-likelihood
% function. nearBnd is a point known to be a lower/upper bound for the
% minimizer, this will be updated to tighten the bound if possible.
% farStart is the first trial point to test to see if it's an upper/lower
% bound for the minimizer. farBnd will be the desired upper/lower bound.
bound = farStart;
upperLim = 1e12; % arbitrary finite limit for search
oldnll = nllFun(bound);
oldbound = bound;

while abs(bound) <= upperLim
    bound = 2*bound; % assumes lower start is < 0, upper is > 0
    nll = nllFun(bound);
    if nll > oldnll
        % The neg loglikelihood increased, we're on the far side of the
        % minimum, so the current point is the desired far bound.
        farBnd = bound;
        break;
    else
        % The neg loglikelihood continued to decrease, so the previous point
        % is on the near side of the minimum, update the near bound.
        nearBnd = oldbound;
    end
    oldnll = nll;
    oldbound = bound;
end

if abs(bound) > upperLim
    farBnd = NaN;
end

end
      

