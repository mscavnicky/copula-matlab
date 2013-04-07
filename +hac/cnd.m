function [ Y ] = cnd( family, U, tree, m )
% HAC.CND Conditional cumulative distribution function for copulas.
%   Computes conditional CDF of d-dimensional copula, where m-th variable
%   is conditined upon the first m-1 variables.

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
   
% Get the CDF expression
g = hac.sym.cdf(family, tree);
% Get all the symbols used
vars = symvar(g);
% Replace symbols m:n with 1
for i=m:n
    g = subs(g, vars(i), 1);
end
% Derivate in variables 1-m-1
for i=1:m-1
   g = diff(g, vars(i)); 
end
% Create a matlab function to evaluate
gn = matlabFunction(g, 'vars', {vars(1:m-1)});


N = fn(U(:,1:m));    
D = gn(U(:,1:m-1));
Y = N ./ D;

end
