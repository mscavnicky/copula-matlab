function [ U ] = rnd( copulaparams, n, d )
%COPULASIM Random vectors from a copula

family = copulaparams.family;

switch family
case 'gaussian' 
    U = copularnd(family, copulaparams.rho, n);
case 't'
    U = copularnd(family, copulaparams.rho, copulaparams.nu, n);
case {'clayton', 'gumbel', 'frank'}
    U = archim.rnd(family, copulaparams.alpha, n, d);
case { 'claytonhac', 'gumbelhac', 'frankhac'}
    U = hac.rnd(family(1:end-3), copulaparams.tree, n);
otherwise
    error('Copula family not supported %d', family);    
end

end

