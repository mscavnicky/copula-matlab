function [ R ] = rankmax( X )
%RANKMAX Returns vector of one-based ranks for each element
%   For the groups of same element, the maximum rank is returned. This can
%   be viewed as number of elements smaller or equal than given number.

% Number of elements
n = size(X, 1);
% Preallocate ranks vector
R = zeros(n, 1);
% Sort the array and retrieve indices
[S, I] =  sort(X);
% Rank of the previous element
r = n;
% Value of the previous element
prev = S(n);

for i=n:-1:1
    if S(i) == prev
        R(I(i)) = r;
    else
        prev = S(i);
        r = i;
        R(I(i)) = r;
    end    
end

end

