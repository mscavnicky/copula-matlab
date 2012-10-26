function [ Y ] = archimndiff( family, n, X, alpha )
%ARCHIMNDIFF Computes n-th derivate of Archimedean generator and evaluates.
% Derivation is computed analytically. Supports Frank, Gumbel and Clayton 
% copulas.

% Declare symbols
syms x p
% Define symbolic version of generator
switch family
    case 'frank'
        f = (-1/p) * log( 1 - ( 1 - exp(-p) ) * exp(-x) );        
    case 'clayton'
        f = (1 + p*x) ^ (-1/p);
    case 'gumbel'
        f = exp(-x ^ (1/p));
end

% Analytically compute n-th derivation
fn = diff(f, n);
% Convert derivation to Matlab function
ndiff = matlabFunction(fn, 'vars', [x p]);
% Compute function values
Y = ndiff(X, alpha);
        
end

