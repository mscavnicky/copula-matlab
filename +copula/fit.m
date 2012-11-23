function [ copulaparams ] = fit( family, U )
%COPULA.FIT Fit data to copula.

d = size(U, 2);

copulaparams.family = family;
copulaparams.dim = d;

switch family
    case {'gaussian'}
        rho = copulafit(family, U);
        copulaparams.rho = rho;
        
        copulaparams.numParams = d*(d-1) / 2;
    case {'t'}
        [rho, nu] = copulafit(family, U);
        copulaparams.rho = rho;
        copulaparams.nu = nu;
        
        copulaparams.numParams = 1 + d*(d-1) / 2;
    case {'clayton', 'gumbel', 'frank'}
        alpha = archim.fit(family, U);
        copulaparams.alpha = alpha;
        
        copulaparams.numParams = 1;
    case {'claytonhac', 'gumbelhac', 'frankhac'}
        tree = hacfit(family(1:end-3), U);
        copulaparams.tree = tree;
        
        copulaparams.numParams = d - 1;
    otherwise
        error('Copula family %s not recognized.', family);
end

end

