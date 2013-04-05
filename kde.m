function [ Y ] = kde( F, X )
%EMPPDF Implementation of the Kernel density smoothing.
%   Evalutes kernel density of the sample F in the points X. When matrices
%   are provided esimated kernel density for each vector separately.

% Number of observations
n = size(F, 1);    

% Estimate bandwith parameters for each dimension
Q1 = quantile(F, 0.25);
Q3 = quantile(F, 0.75);
IRQ = Q3 - Q1;
h = 0.9 * min(std(F), IRQ / 1.34) * n^(-0.2);

% Evaluate kernel density at X
H = repmat(h, n, 1);
Y = zeros(size(X));
for i=1:size(Y, 1) 
    z = (repmat(X(i,:), n, 1) - F) ./ H;    
    Y(i,:) = sum(K(z)) ./ (n * h);
end

end

function [ Y ] = K( z )
%K Gaussian kernel function.
Y = exp(-z.^2 / 2) / sqrt(2 * pi);
end

