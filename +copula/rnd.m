function [ U ] = rnd( family, n, d, copulaparams )
%COPULASIM Random vectors from a copula

switch family
case 'gaussian' 
    U = copularnd(family, copulaparams.rho, n);
case 't'
    U = copularnd(family, copulaparams.rho, copulaparams.nu, n);
case {'clayton', 'gumbel', 'frank'}
    U = archim.rnd(family, copulaparams.alpha, n, d);
otherwise
    error('Copula family not supported %d', family);    
end

end

