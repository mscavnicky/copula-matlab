function [ Y ] = gendiff( family, m, X, p )
%GENDIFF Compute m-th derivative of the generator of the Archimedean copula
%family.

[n, d] = size(X);

switch family
case 'clayton' 
    Y = prod((0:m-1) + (1/p)) * (1 + X).^(-(m+1/p));
case 'gumbel'
    a = zeros(m, 1);
    for i=1:m
       for j=i:m
          a(i) = a(i) + p^(-j) * archim.stirling1(m, j) * archim.stirling2(j, i);
       end        
       a(i) = (-1)^(m-i) * a(i); 
    end    
    
    P = zeros(n, d);
    for i=1:m
        P = P + a(i, 1) * X.^(i / p);
    end    
    
    Y = archim.gen('gumbel', X, p) ./ (X.^m) .* P;  
case 'frank'
    Y = (1/p) * archim.npolylog(m-1, (1-exp(-p)) * exp(-X));
end

Y = Y * (-1)^m;

end


