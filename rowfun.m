function [ Y ] = rowfun( fun, X )
%ROWFUN Applies function to each row of X
Y = cell2mat(cellfun(fun, num2cell(X, 2), 'UniformOutput', false));
end

