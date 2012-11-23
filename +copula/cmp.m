function cmp( U )
%COPULACMP Performs fit on different copula families and gives you
%comparison

%fit('gaussian', U, 50);
%fit('t', U, 50);
%fit('clayton', U, 50);
%fit('gumbel', U, 50);
%fit('frank', U, 50);
fit('claytonhac', U, 0, 'okhrin');
fit('gumbelhac', U, 0, 'okhrin');
fit('frankhac', U, 0, 'okhrin');

end

function fit(family, U, gofBootstraps, varargin)
fprintf('------ Evaluating %s fit ------\n', family);
n = size(U, 1);
copulaparams = copula.fit(family, U, varargin(:));
ll = loglike(copula.pdf(family, U, copulaparams));
fprintf('* LL: %f ', ll);
[aic, bic] = aicbic(ll, copulaparams.numParams, n);
fprintf('AIC: %f BIC: %f\n', aic, bic);
if (gofBootstraps > 0)
    [~, p] = copula.gof(family, U, gofBootstraps, 'snc', copulaparams);
    fprintf('* SnC p-value: %f\n', p);        
end
end