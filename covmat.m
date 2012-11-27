function [ C ] = covmat( array )
%COVMAT Produces a symmetric matrix with lower triangular filled by array.
%   The ordering for lower triangular matrix is that it is filled column by
%   column.

n = round((1 + sqrt(1 + 8*length(array))) / 2);
C = eye(n);

C(tril(ones(n), -1) == 1) = array;
C = C + triu(C', 1);

end

