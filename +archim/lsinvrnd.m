function [ V ] = lsinvrnd( family, alpha, n )
%LSINVRND Sample from the ditribution given by the Laplace-Stieltes
%transformation of the archimedean copula generator.

switch family
case 'clayton' 
    V = gamrnd(1/alpha, 1, n, 1);
case 'gumbel'
    % Testing of generating Gumbel copula number in R is done differently
    % then we are doing it. They use gamma=1. Our implementation was
    % succesfully tested against MATLAB implementation.
    V = stblrnd(1/alpha, 1, cos(pi/(2*alpha))^alpha, 0, n);
case 'frank'
    V = logrnd(1 - exp(-alpha), n);
case 'joe'
    V = sibuyarnd(1/alpha, n);
otherwise
    error('Copula family %s not recognized.', family);    
end

end

