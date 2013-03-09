function [ Y ] = gendiff( family, X, p, m )
%ARCHIM.GENDIFF Compute values of the m-th derivative of the generator of
%the Archimedean copula family using numerical methods.
%
%   References:
%       [1] Hofert (2011) - Likelihood Inference for Archimedean Copulas

[n, d] = size(X);

switch family
case 'clayton' 
    Y = prod((0:m-1) + (1/p)) * (1 + X).^(-(m+1/p));
case 'gumbel'
    a = zeros(m, 1);
    for i=1:m
       for j=i:m
          a(i) = a(i) + p^(-j) * stirling1(m, j) * stirling2(j, i);
       end        
       a(i) = (-1)^(m-i) * a(i); 
    end    
    
    P = zeros(n, d);
    for i=1:m
        P = P + a(i, 1) * X.^(i / p);
    end    
    
    Y = archim.gen('gumbel', X, p) ./ (X.^m) .* P;  
case 'frank'
    Y = (1/p) * npolylog(-m+1, (1-exp(-p)) * exp(-X));
end

Y = Y * (-1)^m;

end

function [ s ] = stirling1( m, n )
%STIRLING1 Returns stirling number of the first kind.
%   To avoid recomputing numbers, caches numbers up to dimension 32.

persistent cache;
if isempty(cache)
   cache = NaN(32, 32);
   % Put ones on diagonal
   cache(eye(32) == 1) = 1;
   % Zeros in the first column
   cache(2:32,1) = 0;   
end

s = cache(m+1,n+1);
if isnan(s)
   s = archim.stirling1(m-1, n-1) - (m-1)*archim.stirling1(m-1, n);
   cache(m+1,n+1) = s;
end

end

function [ s ] = stirling2(m, n)
%STIRLING2 Computes stirling number of the seconds kind.
%   Uses cache up to 32 dimensions.

persistent cache;
if isempty(cache)
   cache = NaN(32, 32);
   % Put ones on diagonal
   cache(eye(32) == 1) = 1;
   % Zeros in the first column
   cache(2:32,1) = 0;
   % Ones in the second column
   cache(2:32,2) = 1;   
end

s = cache(m+1,n+1);
if isnan(s)
   s = archim.stirling2(m-1, n-1) + n*archim.stirling2(m-1, n);
   cache(m+1,n+1) = s;
end

end

function [ Y ] = npolylog( n, X )
%NPOLYLOG Polylogratihm function for n < 0.
%
%   References:
%       [1] http://en.wikipedia.org/wiki/Polylogarithm#Particular_values

assert(n <= 0, 'Polylogarithm only implemented for non-positive numbers.');

n = abs(n);
W = X ./ (1 - X);

Y = zeros(size(X));
for i=0:n
    Y = Y + factorial(i) * (W .^ (i+1)) * archim.stirling2(n+1, i+1);
end

end


