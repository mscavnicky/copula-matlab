function [ T ] = rosenblattTransform( copulaparams, U )
%COPULA.ROSENBLATTTRANSFORM Performs Rosenblatt's probability integral
%transformation under the null hypothesis that the data are generated using
%the given copula.
%
%   References:
%       [1] Breymann, Dependence Structures for Multivariate High-Frequency
%       Data in Finance, 2003

[n, d] = size(U);
T = zeros(n, d);

T(:,1) = U(:,1);
for i=2:d
    T(:,i) = copula.cnd( copulaparams, U, i );
end

end