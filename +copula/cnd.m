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
    %rho = copulaparams.rho;
    %sigma = rho(1:m-1, 1:m-1);
    %c = rho(m, 1:m-1);
    %B = c * 1/sigma;
    %X = norminv(U(:,1:m-1));
    %y = norminv(U(:,m));
    %omega = 1 - B * sigma * B';
    %mu = X * B';
    %Y = normcdf((y-mu) / sqrt(omega));
   
    X = norminv(U(:, 1:m-1));
    y = norminv(U(:, m));
    
    rho = copulaparams.rho(1:m, 1:m);    
    irho = inv(rho);
    add = irho(m,m);
    
    edges =  X * (irho(1:m-1,m) + irho(m,1:m-1)');
    
    H = sqrt(add) * y + edges / (2 * sqrt(add));
    subA = sum((X * irho(1:m-1,1:m-1)) .* X, 2);
    A = subA - edges.^2 / (4 * add);

    t1 = exp(-0.5 * A) .* normcdf(H);
    t2 = (2*pi)^(0.5 * (m-1)) * det(rho)^0.5 * sqrt(add);
    
    N = t1 ./ t2;
    D = mvnpdf( X, 0, rho(1:m-1,1:m-1) );
    
    Y = N ./ D;
case 't'
    %rho = copulaparams.rho;
    %df = copulaparams.nu;
    %sigma = rho(1:m-1, 1:m-1);
    %c = rho(m, 1:m-1);
    %B = c * 1/sigma;
    %X = tinv(U(:,1:m-1), df);
    %y = tinv(U(:,m), df);
    %omega = 1 - B * sigma * B';
    %mu = X * B';
    %SQ = X * (c' * c) * X';
    %Z = diag(df + SQ) / (df + m-1);
    %Y = tcdf((y-mu) ./ sqrt(omega * Z), df);
    
    nu = copulaparams.nu;    
    X = tinv(U(:, 1:m-1), nu);
    y = tinv(U(:, m), nu);
    
    rho = copulaparams.rho(1:m,1:m);
    irho = inv(rho);
    add = irho(m,m);
    
    edges =  X * (irho(1:m-1,m) + irho(m,1:m-1)');
    
    subA = sum((X * irho(1:m-1,1:m-1)) .* X, 2);
    A = subA - edges.^2 / (4 * add);
    
    H = @(z,i) (1 + (((sqrt(add)*z + edges(i)/(2*sqrt(add))).^2 + A(i)) / nu)).^(-0.5*(nu+m));
    
    t1 = gamma((nu+m)/2) / (gamma(nu/2) * (nu*pi)^(m/2) * det(rho)^0.5);   
    t2 = arrayfun(@(i) integral(@(z) H(z,i), -Inf, y(i)), (1:size(y))');
    
    N = t1 * t2;
    D = mvtpdf( X, rho(1:m-1,1:m-1), nu );  
    Y = N ./ D;    
    
case {'frank', 'gumbel', 'clayton', 'joe'}
    alpha = copulaparams.alpha;
    X1 = sum(archim.inv(family, U(:,1:m), alpha), 2);
    N = archim.ndiff(family, m-1, X1, alpha);
    X2 = sum(archim.inv(family, U(:,1:m-1), alpha), 2);
    D = archim.ndiff(family, m-1, X2, alpha);
    Y = N ./ D;
    
case {'claytonhac', 'gumbelhac', 'frankhac', 'joehac'}
    family = family(1:end-3);
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