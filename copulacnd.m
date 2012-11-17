function [ Y ] = copulacnd( family, U, varargin )
% COPULACND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where d-th element is
%   the only unconditioned variable. Dimension of determined by input
%   matrix.

m = size(U, 2);
V = U(:,1:m-1);

switch family
case 'gaussian'
    N = copulacdf('gaussian', U, varargin(:));
    D = prod(normpdf(norminv(V)), 2);
    Y = N ./ D;   
case 't'
    N = copulacdf('t', U, varargin(:));
    D = prod(tpdf(tinv(V)), 2);
    Y = N ./ D;    
case {'frank', 'gumbel', 'clayton'}
    % Conditional copula for flat archimedean copulas as described in [1]
    if ~iscell(varargin{1})
        alpha = varargin{1};
        N = archimndiff(family, sum(archiminv(family, U, alpha)), m-1);
        D = archimpdf(family, V, varargin);
        Y = N ./ D;
    else
        hac = varargin{1};
        % Get the CDF expression
        f = sym.haccdf(family, hac);
        % Get all the symbols used
        vars = symvar(f);
        % Replace symbols m+1:n with 1
        for i=m+1:n
           f = subs(f, vars(i), 1);
        end
        % Derivate in variables 1-m-1
        for i=1:m-1
           f = diff(f, vars(i)); 
        end
        % Create a matlab function to evaluate
        fn = matlabFunction(f, 'vars', {args(1:m)});    
        % Get the result in nominator
        N = fn(U);
        
        
        g = sym.haccdf(family, hac);
        vars = symvar(g);
        for i=m:n
            g = subs(g, vars(i), 1);
        end
        for i=1:m-1
           g = diff(g, vars(i)); 
        end
        gn = matlabFunction(g, 'vars', {args(1:m-1)})
        D = gn(V);
        
        Y = N ./ D;       
    end
otherwise
    error('Copula family not supported.');    
end

end