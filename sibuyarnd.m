function [ X ] = sibuyarnd( alpha, n )
%SIBUYARND Sample Sibuya distribution as described in [1]
%
%   References:
%       [1] Hofert. M, Efficiently Sampling Nested Archimedean Copulas,
%       2011

U = rand(n, 1);
G = ((1 - U) * gamma(1 - alpha)).^(-1/alpha);
F = 1 - (1 / (G * beta(G, 1- alpha)));

X = zeros(n, 1);
X(F < U) = ceil(G(F < U));
X(F >= U) = floor(G(F >= U));
X(U <= alpha) = 1;

end

