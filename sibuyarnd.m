function [ X ] = sibuyarnd( alpha, n )
%SIBUYARND Sample Sibuya distribution as described in [1]
%
%   References:
%       [1] Hofert. M, Efficiently Sampling Nested Archimedean Copulas,
%       2011

U = rand(n, 1);
G = ((1 - U) * gamma(1 - alpha)) .^ (-1/alpha);
fG = floor(G);
cG = ceil(G);
F = 1 - (1 ./ (fG .* beta(fG, 1 - alpha)));

X = zeros(n, 1);
X(F < U) = cG(F < U);
X(F >= U) = fG(F >= U);
X(U <= alpha) = 1;

end

