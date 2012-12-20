function eval(family, U, bootstraps, varargin)

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
ll = loglike(copula.pdf(family, U, copulaparams));
[aic, bic] = aicbic(ll, copulaparams.numParams, n);
fprintf('  NLL: %f\n  AIC: %f\n  BIC: %f\n', ll, aic, bic);

% Perform SnC GOF test
if (bootstraps > 0)
    fprintf('\nSnC GOF Test:\n  ');
    [~, p] = copula.gof(family, U, bootstraps, 'snc', copulaparams, varargin{:});
    fprintf('  p-value: %f\n', p);
end

% Perform SnB GOF test
if (bootstraps > 0)
    fprintf('\nSnB GOF Test:\n  ');
    [~, p] = copula.gof(family, U, bootstraps, 'snb', copulaparams, varargin{:});
    fprintf('  p-value: %f\n', p);
end

end