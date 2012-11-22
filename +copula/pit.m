function [ T ] = pit( family, U, copulaparams )
%COPULAPIT Performs probability integral transformation under the null
%hypothesis that the data are generated using given copula.
%
%   References:
%       [2] Breymann, Dependence Structures for Multivariate High-Frequency
%       Data in Finance, 2003

[n, d] = size(U);
T = zeros(n, d);

T(:,1) = U(:,1);
for i=2:d
    T(:,2) = copula.cnd( family, U, i, copulaparams );
end

end

