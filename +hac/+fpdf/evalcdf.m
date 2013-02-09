function [ Y ] = evalcdf( expr, family, U, params )
%HAC.FPDF Evaluate copula cdf expression
%   Example C1(C2(u1, u3), u4) which is an expression in a prefix notation.

if regexp(expr, '^u[0-9]$') == 1
    Y = U(:, str2num(expr(2:end)));
else
    id = regexp(expr, '^C[0-9]+', 'match');
    
    vars = children(sym(expr));
    d = numel(vars);
    n = size(U, 1);
    V = zeros(n, d);    
    for i=1:d
       V(:,i) = hac.fpdf.evalcdf(char(vars(i)), family, U, params);
    end   
    
    Y = archim.cdf(family, V, params(id{1}));    
end

end

