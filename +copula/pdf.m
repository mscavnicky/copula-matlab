function [ Y ] = pdf( copulaparams, U )
%PDF Copula probability distribution function

family = copulaparams.family;

switch family
case 'gaussian' 
    Y = copulapdf(family, U, copulaparams.rho);
case 't'
    Y = copulapdf(family, U, copulaparams.rho, copulaparams.nu);
case {'clayton', 'gumbel', 'frank'}
    Y = archim.pdf(family, U, copulaparams.alpha);
case {'claytonhac', 'gumbelhac', 'frankhac'}
    Y = hac.fpdf(family(1:end-3), U, copulaparams.tree);
case {'claytonhac*', 'gumbelhac*', 'frankhac*'}
    [tree, U] = hac.preprocess(copulaparams.tree, U);
    Y = hac.fpdf(family(1:end-4), U, tree);
otherwise
    error('Copula family not recognized.');    
end

end

