function [ Y ] = generatorDerivative( family, X, alpha, m )
%ARCHIM.GENERATORDERIVATIVE Computes values of the m-th derivative of the
%generator of the Archimedean copula family using Symbolic toolbox.
%Symbolic derivations are cached to speed up computations.

% Initialized cache for functions repsenting generator derivatives
persistent derivatives;
if isempty(derivatives)
    derivatives = containers.Map;
end

% The key of the derivative function computed
cacheKey = sprintf('%s%d', family, m);

if isKey(derivatives, cacheKey)
    nthDerivative = derivatives(cacheKey);
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
    derivatives(cacheKey) = nthDerivative;    
end    

% Compute function values
Y = nthDerivative(X, alpha);
        
end

