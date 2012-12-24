function [ Y ] = ndiff( family, n, X, alpha )
%ARCHIMNDIFF Computes n-th derivate of Archimedean generator and evaluates.
%   Derivation is computed analytically. Supports Frank, Gumbel and Clayton 
%   copulas. To improve performance derivatives are cached in persistent
%   map.

% Initialized cache for functions repsenting generator derivatives
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
    % Acquire symbolic version of generator
    f = archim.sym.gen(family, x, p);
    % Analytically compute n-th derivation
    fn = diff(f, n, x);
    % Simplify equation for performance reasons
    fn = simplify(fn);    
    % Convert derivation to Matlab function
    nthDerivative = matlabFunction(fn, 'vars', [x p]);
    % Store it in the cache
    derivatives(key) = nthDerivative;    
end    

% Compute function values
Y = nthDerivative(X, alpha);
        
end

