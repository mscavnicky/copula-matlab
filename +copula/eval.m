function eval(family, U, gofBootstraps, varargin)

fprintf('------ Evaluating %s fit ------\n', family);
n = size(U, 1);
copulaparams = copula.fit(family, U, varargin{:});
fprintf('%s\n', dprint(copulaparams));
ll = loglike(copula.pdf(family, U, copulaparams));
fprintf('* LL: %f ', ll);
[aic, bic] = aicbic(ll, copulaparams.numParams, n);
fprintf('AIC: %f BIC: %f\n', aic, bic);
if (gofBootstraps > 0)
    [~, p] = copula.gof(family, U, gofBootstraps, 'snb', copulaparams, varargin{:});
    fprintf('* SnB p-value: %f\n', p);        
end