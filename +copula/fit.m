function [ copulaparams ] = fit( family, U )
%COPULA.FIT Fit data to copula.

copulaparam = struct();

switch family
    case {'gaussian'}
        rho = copulafit(family, U);
        copulaparams.rho = rho;
    case {'t'}
        [rho, nu] = copulafit(family, U);
        copulaparams.rho = rho;
        copulaparams.nu = nu;
    case {'clayton', 'gumbel', 'frank'}
        alpha = archimfit(family, U);
        copulaparams.alpha = alpha;
    case {'claytonhac', 'gumbelhac', 'frankhac'}
        tree = hacfit(family(1:end-3), U);
        copulaparams.tree = tree;
    otherwise
        error('Copula family %s not recognized.', family);
end

end

