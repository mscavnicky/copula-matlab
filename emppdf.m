function [ Y, h ] = emppdf( F, X )
%EMPCDF Empirical pdf according to Wintermann

%n = size(F, 1);
%lambda = n ^ (-1/5);
%Y = (empcdf(F, X + lambda) - empcdf(F, X - lambda)) / (2 * lambda);

n = size(F, 1);    

Q1 = quantile(F, 0.25);
Q3 = quantile(F, 0.75);
IRQ = Q3 - Q1;
h = 0.9 * min(std(F), IRQ / 1.34) * n^(-0.2);

Y = zeros(size(X));

H = repmat(h, n, 1);
for i=1:size(Y, 1) 
    z = (repmat(X(i,:), n, 1) - F) ./ H;    
    Y(i,:) = sum(K(z)) ./ (n * h);
end

end

function [ Y ] = K( z )
%K Implementation of the Gaussian kernel
Y = exp(-z.^2 / 2) / sqrt(2 * pi);
end

