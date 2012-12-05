function [ T ] = pit( family, U, copulaparams )
%COPULAPIT Performs probability integral transformation under the null
%hypothesis that the data are generated using given copula.
%
%   Computation of conditional probability is currently performing
%   duplicate work for each dimension. This is a minor performance
%   bottleneck that can be fixed in the future.
%
%   References:
%       [1] Breymann, Dependence Structures for Multivariate High-Frequency
%       Data in Finance, 2003

[n, d] = size(U);
T = zeros(n, d);

T(:,1) = U(:,1);
for i=2:d
    T(:,i) = copula.cnd( family, U, i, copulaparams );
end

end

