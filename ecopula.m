function [ C ] = ecopula( U )
%ECOPULA Empirical copula for n-dimensional data. Works with uniform values

[m n] = size(U);

C = zeros(m, 1);
for i=1:m
    % Compute samples less given sample
    S = ones(m, 1);
    for j=1:n
        S = S .* (U(:, j) <= U(i, j));
    end
    C(i, 1) = sum(S) / (m + 1);
end

end

