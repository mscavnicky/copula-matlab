function [ Y ] = copulacnd( family, U, m, varargin )
% COPULACND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where d-th element is
%   the only unconditioned variable.

dprint(varargin);

switch family
case 'gaussian'
    %N = copulacdf('gaussian', U, varargin{1});
    %D = prod(normpdf(norminv(V)), 2);
    %Y = N ./ D;   
    
    %rho = varargin{1}
    %rho11 = rho(1:m-1,1:m-1);
    %rho12 = rho(1,2:m);
    %rho21 = rho(2:m,1);
    %rho22 = rho(m,m);
    
    %mu = rho21 * inv(rho11) * V
    %sigma = rho22 - rho21 * inv(rho11) * rho12
    %Y = mvncdf(norminv(U), mu, sigma)
    
    rho = varargin{1};
    sigma = rho(1:m-1, 1:m-1);
    c = rho(m, 1:m-1);
    B = c * 1/sigma;
    X = norminv(U(:,1:m-1));
    y = norminv(U(:,m));
    omega = 1 - B * sigma * B';
    mu = X * B';
    Y = normcdf((y-mu) / sqrt(omega));   
    
case 't'
    N = copulacdf('t', U(:,1:m), varargin(:));
    D = prod(tpdf(tinv(U(:,1:m-1))), 2);
    Y = N ./ D;    
case {'frank', 'gumbel', 'clayton'}
    % Conditional copula for flat archimedean copulas as described in [1]
    if ~iscell(varargin{1})
        alpha = varargin{1};
        N = archimndiff(family, sum(archiminv(family, U(:,1:m), alpha)), m-1);
        D = archimpdf(family, U(:,1:m-1), varargin);
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
        N = fn(U(:,1:m));
        
        
        g = sym.haccdf(family, hac);
        vars = symvar(g);
        for i=m:n
            g = subs(g, vars(i), 1);
        end
        for i=1:m-1
           g = diff(g, vars(i)); 
        end
        gn = matlabFunction(g, 'vars', {args(1:m-1)});
        D = gn(U(:,1:m-1));
        
        Y = N ./ D;       
    end
otherwise
    error('Copula family not supported.');    
end

end