function [ varargout ] = fit( family, U )
%COPULA.FIT Fit data to copula.

switch family
    case {'gaussian', 't'}
        varargout = copulafit(family, U);
    case {'clayton', 'gumbel', 'frank'}
        varargout = archimfit(family, U);
    case {'claytonhac', 'gumbelhac', 'frankhac'}
        varargout = hacfit(family(1:end-3), U);
    otherwise
        error('Copula family %s not recognized.', family);
end

end

