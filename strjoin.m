function [ str ] = strjoin( strings, delimiter )
%STRJOIN Joins cell array of strings using delimiter

if nargin > 1
    fmt = sprintf('%%s%s', delimiter);
    str = sprintf(fmt, strings{:});
    str = str(1:end - length(delimiter));
else
    str = sprintf('%s', strings{:});
end

end

