function [ T ] = snb( E )
% SNB Goodness of fit test statistics

[n,d] = size(E);

t1 = n / 3^d;
t2 = sum(prod(1 - E.^2, 2), 1) / 2^(d-1);

t3 = 0;
for i=1:n
   for j=1:n
      t3 = t3 + prod(1 - max(E(i,:), E(j,:)), 2);
   end
end
t3 = t3 / n;

T = t1 - t2 + t3;

end

