function [ Y ] = archimndiff( family, n, X, alpha )
%ARCHIMNDIFF Computes n-th derivate of Archimedean generator and evaluates.
% Derivation is computed analytically. Supports Frank, Gumbel and Clayton 
% copulas.

% Initialized cache for derivatives
persistent derivatives;
if isempty(derivatives)
    derivatives = containers.Map;
end

% The key of the derivative function computed
key = strcat(family, int2str(n));

if isKey(derivatives, key)
    nthDerivative = derivatives(key);
else
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
    fn = diff(f, n, x);
    % Convert derivation to Matlab function
    nthDerivative = matlabFunction(fn, 'vars', [x p]);
    % Store it in the cache
    derivatives(key) = nthDerivative;    
end    

% Compute function values
Y = nthDerivative(X, alpha);
        
end

