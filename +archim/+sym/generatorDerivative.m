function [ Y ] = generatorDerivative( family, X, alpha, m )
%ARCHIM.GENDIFF Computes values of the m-th derivative of the generator of
%the Archimedean copula family using symbolic toolbox.
%   Symbolic derivations are cached to speed up computations.

% Initialized cache for functions repsenting generator derivatives
persistent derivatives;
if isempty(derivatives)
    derivatives = containers.Map;
end

% The key of the derivative function computed
key = sprintf('%s%d', family, m);

if isKey(derivatives, key)
    nthDerivative = derivatives(key);
else
    % Declare symbols
    syms x p
    % Acquire symbolic version of generator
    f = archim.sym.generator(family, x, p);
    % Analytically compute n-th derivation
    fn = diff(f, m, x);
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

