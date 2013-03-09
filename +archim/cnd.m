function [ Y ] = cnd( family, U, alpha, m )
% ARCHIM.CND Conditional cumulative distribution function for Archimedean
% copulas.
%   Computes conditional CDF of d-dimensional copula, where m-th variable
%   is conditined upon first m-1 variables.

X1 = sum(archim.inv(family, U(:,1:m), alpha), 2);
N = archim.gendiff(family, X1, alpha, m-1);

X2 = sum(archim.inv(family, U(:,1:m-1), alpha), 2);
D = archim.gendiff(family, X2, alpha, m-1);

Y = N ./ D;

end

