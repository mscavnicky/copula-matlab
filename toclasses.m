function [ C ] = toclasses( Y, c )
%TOCLASSES Converts continuouos attribute into n equal sized classes.

C = zeros(size(Y));
for i=1:c
    q = quantile(Y, i/c);
    C(Y <= q & C == 0) = i;
end

end

