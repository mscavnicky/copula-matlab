function [ Y ] = cnd( family, U, alpha, m )
% COPULACND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where m-th variable
%   is conditined upon first m-1 variables.

X1 = sum(archim.inv(family, U(:,1:m), alpha), 2);
N = archim.ndiff(family, m-1, X1, alpha);

X2 = sum(archim.inv(family, U(:,1:m-1), alpha), 2);
D = archim.ndiff(family, m-1, X2, alpha);

Y = N ./ D;

end

