function [ Y ] = cnd( family, U, tree, m )
% COPULACND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where m-th variable
%   is conditined upon first m-1 variables.

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

end
