function [ str ] = dprint( obj, d )
%DPRINT Deep print on any nested object.
%   Supports 2-dimensional cell-arrays and matrices.
%   http://www.mathworks.com/help/matlab/data-type-identification.html

%#ok<*AGROW>

if nargin < 2
    d = 0;
end

if ischar(obj)
    str = obj; 
elseif iscell(obj)
    ss = {};
    for i=1:length(obj)
        ss{end+1} = dprint(obj{i}, d+1);
    end
    str = sprintf('{%s}', strjoin(ss, ', '));  
elseif isa(obj, 'containers.Map')
    keys = obj.keys;        
    ss = {};
    for i=1:length(keys)
        key = keys(i);
        value = obj.values(key);
        ss{end+1} = sprintf('%s:%s', dprint(key{1}, d+1), dprint(value{1}, d+1));            
    end
    str = sprintf('#{%s}', strjoin(ss, ', '));
elseif isstruct(obj)   
    ss = {};
    names = fieldnames(obj);
    for i=1:length(names)
       key = names{i};
       value = getfield(obj, names{i});
       ss{end+1} = sprintf('%s:%s', dprint(key, d+1), dprint(value, d+1));           
    end
    str =  sprintf('S{%s}', strjoin(ss, ', '));
elseif isobject(obj)        
    str = evalc('disp(obj)');
elseif ismatrix(obj)
    str = mat2str(obj, 5);
else
    error 'Type not supported.'
end

end

