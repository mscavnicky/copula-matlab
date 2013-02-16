function [ copulaparams ] = fit( family, U, varargin )
%COPULA.FIT Estimates copula parameters for given copula family.
%   Returns struct of copula parameters.

d = size(U, 2);

copulaparams.family = family;
copulaparams.dim = d;

switch family
    case {'gaussian'}
        rho = copulafit(family, U);
        copulaparams.rho = rho;
        
        copulaparams.numParams = d*(d-1) / 2;
    case {'t'}
        if numel(varargin) > 0
            method = varargin{1};
        else
            method = 'approximateml';
        end
        [rho, nu] = copulafit(family, U, 'method', method);
        copulaparams.rho = rho;
        copulaparams.nu = nu;
        
        copulaparams.numParams = 1 + d*(d-1) / 2;
    case {'clayton', 'gumbel', 'frank'}
        alpha = archim.fit(family, U);
        copulaparams.alpha = alpha;
        
        copulaparams.numParams = 1;
    case {'claytonhac', 'gumbelhac', 'frankhac'}
        if numel(varargin) > 0
            method = varargin{1};
        else
            method = 'okhrin';
        end
        tree = hac.fit(family(1:end-3), U, method);
        copulaparams.tree = tree;
        
        copulaparams.numParams = d - 1;
    otherwise
        error('Copula family %s not recognized.', family);
end

end

