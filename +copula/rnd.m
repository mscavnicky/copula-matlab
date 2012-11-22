function [ U ] = rnd( family, N, copulaparams )
%COPULASIM Random vectors from a copula

switch family
case 'gaussian' 
    U = copularnd(family, copulaparams.rho, N);
case 't'
    U = copularnd(family, copulaparams.rho, copulaparams.nu, N);
otherwise
    error('Copula family not supported %d', family);    
end

end

