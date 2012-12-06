function [ str ] = dprint( obj )
%DPRINT Deep print on any nested object.
%   Supports 2-dimensional cell-arrays and matrices.
%   http://www.mathworks.com/help/matlab/data-type-identification.html
str = dprint2(obj, 0);

function [ str ] = dprint2( obj, depth )   
    if ischar(obj)
        str = obj; 
    elseif iscell(obj)
        ss = {};
        for i=1:length(obj)
            ss{end+1} = dprint2(obj{i}, depth+1);
        end
        str = join(ss, ', ', '{', '}');  
    elseif isa(obj, 'containers.Map')
        keys = obj.keys;        
        ss = {};
        for i=1:length(keys)
            key = keys(i);
            value = obj.values(key);
            ss{end+1} = sprintf('%s:%s', dprint2(key{1}, depth+1), dprint2(value{1}, depth+1));            
        end
        str = join(ss, ', ', '#{', '}');
    elseif isstruct(obj)   
        ss = {};
        names = fieldnames(obj);
        for i=1:length(names)
           key = names{i};
           value = getfield(obj, names{i});
           ss{end+1} = sprintf('%s:%s', dprint2(key, depth+1), dprint2(value, depth+1));           
        end
        str = join(ss, ', ', 'S{', '}');
    elseif isobject(obj)
        str = '[~obj]';
    elseif ismatrix(obj)
        str = mat2str(obj, 5);
    else
        error 'Type not supported.'
    end
end

function [ s ] = join(cells, delimiter, prefix, suffix)
    fmt = sprintf('%%s%s', delimiter);
    body = sprintf(fmt, cells{:});
    body = body(1:end - length(delimiter));
    s = sprintf('%s%s%s', prefix, body, suffix);
end
    

end

