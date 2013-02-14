function [ s ] = stirling1( m, n )
%STIRLING1 Returns stirling number of the first kind.
%   Caches numbers up to dimension 32.

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



