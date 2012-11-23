function [ Y ] = pdf( family, U, copulaparams )
%PDF Copula probability distribution function

switch family
case 'gaussian' 
    Y = copulapdf(family, U, copulaparams.rho);
case 't'
    Y = copulapdf(family, U, copulaparams.rho, copulaparams.nu);
case {'clayton', 'gumbel', 'frank'}
    Y = archim.pdf(family, U, copulaparams.alpha);
case {'claytonhac', 'gumbelhac', 'frankhac'}
    Y = hac.pdf(family(1:end-3), U, copulaparams.tree);
otherwise
    error('Copula family not recognized.');    
end

end

