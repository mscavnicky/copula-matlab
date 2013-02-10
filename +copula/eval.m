function [ fit ] = eval(family, U, bootstraps, varargin)

% Print size of the data set
[n, d] = size(U);
fprintf('Evalutating %s copula on [%d x %d]\n', family, n, d);

fprintf('\nFit:\n');
% Perform fit of the data to the function
tic();
copulaparams = copula.fit(family, U, varargin{:});
fprintf('  Duration: %f s\n', toc());

% Print fit result
switch family
case 'gaussian'
    fprintf('  rho: %s\n', dprint(copulaparams.rho));
case 't'
    fprintf('  rho: %s\n', dprint(copulaparams.rho));
    fprintf('  nu:  %s\n', dprint(copulaparams.nu));
case {'clayton', 'gumbel', 'frank'}
    fprintf('  alpha: %s\n', dprint(copulaparams.alpha));
case {'claytonhac', 'gumbelhac', 'frankhac'}
    fprintf('  tree: %s\n', dprint(copulaparams.tree));
end

% Compute log likelihood, AIC and BIC
ll = -loglike(copula.pdf(copulaparams, U));
k = copulaparams.numParams;
aic = -2*ll + (2*n*(k+1))/(n-k-2);
bic = -2*ll + k*log(n);
fprintf('  NLL: %f\n  AIC: %f\n  BIC: %f\n', ll, aic, bic);


% Perform SnC GOF test
if (bootstraps > 0)
    fprintf('\nSnC GOF Test:\n  ');
    [~, snc] = copula.gof(copulaparams, U, bootstraps, 'snc', 1, varargin{:});
    fprintf('  p-value: %f\n', snc);
end

% Perform SnB GOF test
if (bootstraps > 0)
    fprintf('\nSnB GOF Test:\n  ');
    [~, snb] = copula.gof(copulaparams, U, bootstraps, 'snb', 1, varargin{:});
    fprintf('  p-value: %f\n', snb);
end

% New line for better readability
fprintf('\n');

% Fill the fit struct
if numel(varargin) > 0
    fit.method = varargin{1};
end
fit.bootstraps = bootstraps;
fit.copulaparams = copulaparams;
fit.ll = ll;
fit.aic = aic;
fit.bic = bic;
if exist('snc', 'var')
    fit.snc = snc;
end
if exist('snb', 'var')
    fit.snb = snb;
end

end