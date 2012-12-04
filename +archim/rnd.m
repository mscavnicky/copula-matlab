function [ U ] = rnd( family, alpha, n, d )
%RND Random vectors from a copula.
%   
%   References:
%       McNeil

% Special method
%X = unifrnd(0, 1, n, d);
%copulaparams.alpha = alpha;
%U = copula.pit( family, X, copulaparams );
%return;

switch family
case 'clayton' 
    V = gamrnd(1/alpha, 1, n, 1);
    X = unifrnd(0, 1, n, d);
    U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);
case 'gumbel'
    % Testing of generating Gumbel copula number in R is done differently
    % then we are doing it. They use gamma=1. Our implementation was
    % succesfully tested against MATLAB implementation.
    V = stblrnd(1/alpha, 1, cos(pi/(2*alpha))^alpha, 0, n, 1);
    X = unifrnd(0, 1, n, d);
    U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);
case 'frank'
    % Log-series sampling taken from polish guys thesis
    V = floor(1+log(rand(n,1)) ./ log(1-exp(-alpha*rand(n,1))));
    X = unifrnd(0, 1, n,d);   
    U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);
otherwise
    error('Copula family %s not recognized.', family);    
end

end