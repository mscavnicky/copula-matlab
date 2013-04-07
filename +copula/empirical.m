function [ C ] = empirical( U )
%COPULA.EMPIRICAL Empirical copula for d-dimensional data. 
%   Works with uniform variates.
%
%   References:
%       [1] Genest, C. (2009) Goodness-of-fit tests for copulas: A review
%       and a power study

[n d] = size(U);

C = zeros(n, 1);
for i=1:n
   S = ones(n, 1);
   % Make AND using logical bitmaps of each column
   for j=1:d
      S = S .* (U(:, j) <= U(i, j));
   end
   C(i) = sum(S) / n;
end

end

