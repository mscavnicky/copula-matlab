function [ Y ] = colfun( fun, X )
%COLFUN Applies function to each column of X
Y = cell2mat(cellfun(fun, num2cell(X, 1), 'UniformOutput', false));
end

