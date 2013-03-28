function [ Y ] = pdf( copulaparams, U )
%COPULA.PDF Copula probability distribution function

family = copulaparams.family;

switch family
case 'independent'
    Y = ones(size(U, 1), 1);
case 'gaussian' 
    Y = copulapdf(family, U, copulaparams.rho);
case 't'
    Y = copulapdf(family, U, copulaparams.rho, copulaparams.nu);
case {'clayton', 'gumbel', 'frank'}
    Y = archim.pdf(family, U, copulaparams.alpha);
case {'claytonhac', 'gumbelhac', 'frankhac'}
    Y = hac.fpdf(family(1:end-3), U, copulaparams.tree);
otherwise
    error('Copula family not recognized.');    
end

end

