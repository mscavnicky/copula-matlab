function [ Y ] = cnd( family, U, m, copulaparams )
% COPULACND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where d-th element is
%   the only unconditioned variable.
%
%   References:
%       [1] Savu, Trede, GOF tests for parametric families of Archimedean
%       copulas, 2004

switch family
case 'gaussian'
    rho = copulaparams.rho;
    sigma = rho(1:m-1, 1:m-1);
    c = rho(m, 1:m-1);
    B = c * 1/sigma;
    X = norminv(U(:,1:m-1));
    y = norminv(U(:,m));
    omega = 1 - B * sigma * B';
    mu = X * B';
    Y = normcdf((y-mu) / sqrt(omega));   
    
case 't'
    rho = copulaparams.rho;
    df = copulaparams.nu;
    sigma = rho(1:m-1, 1:m-1);
    c = rho(m, 1:m-1);
    B = c * 1/sigma;
    X = tinv(U(:,1:m-1), df);
    y = tinv(U(:,m), df);
    omega = 1 - B * sigma * B';
    mu = X * B';
    SQ = X * (c' * c) * X';
    Z = diag(df + SQ) / (df + m-1);
    Y = tcdf((y-mu) ./ sqrt(omega * Z), df);    
    
case {'frank', 'gumbel', 'clayton'}
    alpha = copulaparams.alpha;
    X1 = sum(archim.inv(family, U(:,1:m), alpha), 2);
    N = archim.ndiff(family, m-1, X1, alpha);
    X2 = sum(archim.inv(family, U(:,1:m-1), alpha), 2);
    D = archim.ndiff(family, m-1, X2, alpha);
    Y = N ./ D;
    
case {'claytonhac', 'gumbelhac', 'frankhac'}
    tree = copulaparams.tree;
    n = size(U, 2);
    % Get the CDF expression
    f = hac.sym.cdf(family, tree);
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
    fn = matlabFunction(f, 'vars', {vars(1:m)});    
    % Get the result in nominator
    N = fn(U(:,1:m));        

    g = hac.sym.cdf(family, tree);
    vars = symvar(g);
    for i=m:n
        g = subs(g, vars(i), 1);
    end
    for i=1:m-1
       g = diff(g, vars(i)); 
    end
    gn = matlabFunction(g, 'vars', {vars(1:m-1)});
    D = gn(U(:,1:m-1));

    Y = N ./ D;       
otherwise
    error('Copula family not supported.');    
end

end