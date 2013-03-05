function [ Y ] = empcdf( F, X )
%EMPCDF Empirical cdf function for input X given the empirical values F

n = size(F, 1);
Y = zeros(size(X));
for i=1:size(X, 1)
    Y(i, :) = sum(F <= repmat(X(i, :), n, 1), 1) / (n + 1);
end

end

