function [ fit ] = eval(family, U, bootstraps, varargin)

% Print size of the data set
[n, d] = size(U);
fprintf('Evalutating %s copula on [%d x %d]\n', family, n, d);

fprintf('\nFit:\n');
% Perform fit of the data to the function
tic();
copulaparams = copula.fit(family, U, varargin{:});
fprintf('  Duration: %f s\n', toc());
fit.copulaparams = copulaparams;

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
fit.ll = ll;
k = copulaparams.numParams;
fit.aic = -2*ll + (2*n*(k+1))/(n-k-2);
fit.bic = -2*ll + k*log(n);
fprintf('  NLL: %f\n  AIC: %f\n  BIC: %f\n', ll, fit.aic, fit.bic);


% Perform SnC GOF test
if (bootstraps > 0)
    fprintf('\nSnC GOF Test:\n  ');
    [~, p] = copula.gof(copulaparams, U, bootstraps, 'snc', 1, varargin{:});
    fprintf('  p-value: %f\n', p);
    fit.snc = p;
end

% Perform SnB GOF test
if (bootstraps > 0)
    fprintf('\nSnB GOF Test:\n  ');
    [~, p] = copula.gof(copulaparams, U, bootstraps, 'snb', 1, varargin{:});
    fprintf('  p-value: %f\n', p);
    fit.snc = p;
end

% New line for better readability
fprintf('\n');

end