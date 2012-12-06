function [ logreturns ] = logreturns( prices )
%LOGRETURNS Converts prices to log-returns.
%   
%   References:
%       [1] http://quantivity.wordpress.com/2011/02/21/why-log-returns/
returns = diff(prices) ./ prices(1:end-1);
logreturns = log(1 + returns);
end

