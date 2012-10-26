function [ Y ] = archimpdf( family, U, alpha )
%ARCHIMPDF Probability density function for multivariate archimedean copula.
% 
% TODO: 
% - add source McNeil & Neslehova
% - validation

% Acquire copula dimension for derivative
d = size(U, 2);
% Evaluate equation [1]
N = archimndiff( family, d, sum(archiminv( family, U, alpha ), 2), alpha );
D = prod( archimdiff( family, archiminv( family, U, alpha ), alpha ), 2 );
Y = N ./ D;

end
