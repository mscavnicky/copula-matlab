function [ U ] = rnd( family, alpha, n, d )
%RND Random vectors from a copula.
%   
%   References:
%       Hofert - (2011) Nested Archimedean Copulas meet R
%       Kemp - (1981) Efficient generation of logarithimic pseudo-random
%       variables

%X = unifrnd(0, 1, n, d);
%copulaparams.alpha = alpha;
%U = copula.pit( family, X, copulaparams );
%return;

V = archim.lsinvrnd(family, alpha, n);
X = rand(n, d);
U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);

end