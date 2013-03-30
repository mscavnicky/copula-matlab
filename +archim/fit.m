function [ alphahat ] = fit( family, U, lowerBound, upperBound )
%ARCHIM.FIT Fit a multivariate archimedean copula to data.
%   Data must be within interval [0, 1]. Returns value of fitted parameters
%   and likelihood of fit to data. Minimization is performed using fminbnd
%   method which requires likelihood method to be continuouos.

% Function giving likelihood of the sample for given alpha
optimfun = @(alpha) -sum(log((archim.pdf(family, U, alpha))));

% Get bound for Archimedean copula family in this dimension
if nargin < 3
    [ lowerBound, upperBound ] = archim.bounds( family, size(U, 2) );
end

% Debugging function plot
if 0
    L = linspace(1.0, min(5), 500);
    fig = figure;
    
    plot(L, arrayfun(@(alpha) -optimfun(alpha), L));
    xlabel('$\theta$', 'interpreter', 'latex');
    ylabel('$\ell(\theta)$', 'interpreter', 'latex');
    set(gca, 'FontName', 'NewCenturySchlbk');
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [10 4]);
    set(gcf, 'PaperPosition', [0 0 10 4]);
    print('-dpdf', '-r300', '../Images/archim-likelihood.pdf');
    pause(10);
    close(fig);
end

% If upperBoudn is infinite, estimate some close upperBound assuming the
% function is monotone
originalUpperBound = upperBound;
if upperBound == Inf
    newUpperBound = 4;    
    while optimfun(newUpperBound) > optimfun(newUpperBound * 2)
        newUpperBound = newUpperBound * 2;
    end
    upperBound = newUpperBound * 2;
end

% Estimate the alpha using MATLAB's optimization methods
alphahat = estimateAlpha(optimfun, max(lowerBound, -10), upperBound);

if originalUpperBound == Inf && abs(alphahat - upperBound) < 0.001
    warning('archim:fit:alpha', 'Estimated alpha too close to the upper bound.');
end

end

function [ alphahat ] = estimateAlpha(fun, lowerBound, upperBound)
[ alphahat, ~, exitflag ] = fminbnd(fun, lowerBound, upperBound, statset('copulafit'));
if exitflag ~= 1
    erorr('Minimazation did not converge properly.')
end
end