function [ C ] = ecopula( U )
%ECOPULA Empirical copula for d-dimensional data. 
%   Works with uniform variates. Method uses (n+1) as the denominator to
%   avoid having ranks of 1.0. However in [2] n is used as the denominator.
%
%   References:
%       [1] Berg, D. Bakken, H. (2006) Copula Goodness-of-fit Tests: A
%       Comparative Study
%       [2] Genest, C. (2009) Goodness-of-fit tests for copulas: A review
%       and a power study

[n d] = size(U);


% C = zeros(n, 1);
% S = sortrows(U)
% for i=1:n
%     [~, loc] = ismember(U(i,:), S, 'rows');
%     C(i) = loc / (n + 1);
% end

C = zeros(n, 1);
for i=1:n
   S = ones(n, 1);
   % Make AND using logical bitmaps of each column
   for j=1:d
      S = S .* (U(:, j) <= U(i, j));
   end
   C(i) = sum(S) / n;
   
%    S = all((U <= repmat(U(i, :), n, 1)), 2);
%    C(i) = sum(S) / (n + 1);
   
end

end

