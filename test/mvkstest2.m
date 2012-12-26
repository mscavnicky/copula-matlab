function [ H ] = mvkstest2(X, Y)    
assert(size(X, 2) == size(Y, 2), 'Dimensions do not match.');

d = size(X, 2);       
H = zeros(d, 1);
for t=1:10        
    for i=1:d
        h = kstest2(X(:,i), Y(:,i), 0.01);
        H(i) = H(i) + h;
    end
end

% Those that failed more thatn 1 times (alpha 10%)
H = (H > 1);
end