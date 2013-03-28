function [ Y ] = cnd( copulaparams, U, m )
%COPULA.CND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where m-th variable
%   is conditined upon first m-1 variables.

family = copulaparams.family;

switch family
    
case 'independent'
    % Conditioning upon independent variables
    Y = U(:,m);
case 'gaussian'
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
    
case {'frank', 'gumbel', 'clayton'}
    Y = archim.cnd(family, U, copulaparams.alpha, m);
    
case {'claytonhac', 'gumbelhac', 'frankhac'}
    family = family(1:end-3);
    Y = hac.fcnd(family, U, copulaparams.tree, m);

case {'claytonhac*', 'gumbelhac*', 'frankhac*'}
    [tree, U] = hac.preprocess(copulaparams.tree, U);
    family = family(1:end-4);
    Y = hac.fcnd(family, U, tree, m);
     
otherwise
    error('Copula family not supported.');    
end

end