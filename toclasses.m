function [ C ] = toclasses( Y, n, cuts )
%TOCLASSES Converts continuouos attribute into n equal sized classes.

% Use quantiles if cuts not specified
if nargin < 3
    cuts = quantile(Y, (1:n-1)/n);
end

cuts = [(min(Y) - 1) cuts (max(Y) + 1)];

C = NaN(size(Y));
for i=1:n
    C(Y > cuts(i) & Y <= cuts(i+1)) = i;
end

end

