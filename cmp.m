function [ M ] = cmp( X )
%CMP

[n, d] = size(X);
M = zeros(n, n);

for j=1:d
    for i=1:n
       M(i, :) = M(i, :) + (X(i,j) > X(:,j))';
    end
end

end

