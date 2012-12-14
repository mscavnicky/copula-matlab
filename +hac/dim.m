function [ d ] = dim( tree )
%DIM Recursively computes dimensions of the HAC copula.

d = 0;
for i=1:length(tree)-1
    if iscell(tree{i})
        d = d + hac.dim(tree{i});
    else
        d = d+1;
    end
end

end

