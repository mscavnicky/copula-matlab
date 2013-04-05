function [ U ] = pseudoObservations( X )
%PSEUDOOBSERVATIONS Uniforms input sample to pseudo-observations.
%   Based on empirical CDF function described in [1]. We use n+1 for
%   division to keep empirical CDF lower than 1. 
%
%   References:
%       [1] Berg, D. Bakken, H. (2006) Copula Goodness-of-fit Tests: A
%       Comparative Study

[n, d] = size(X);
U = zeros(n, d);

for i=1:d
    U(:,i) = rankmax(X(:,i)) / (n + 1);
end

end

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
    x = S(i);
    if x == prev
        R(I(i)) = r;
    else
        prev = x;
        r = i;
        R(I(i)) = r;
    end    
end

end

