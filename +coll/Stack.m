classdef Stack < handle
% STACK stack data strcuture
%
%   s = Stack(c);  c is a cells, and could be omitted
%   s.size() return the number of elements
%   s.isempty() return true when the stack is empty
%   s.push(el) push el to the top of stack
%   s.pop() pop out the top of the stack, and return the element
%   s.peek() return the top element of the stack
%   s.content() return all the data of the stack  

properties (Access = private)
    buffer      
    cur
    capacity
end

methods
    function obj = Stack(c)
        if nargin >= 1
            obj.buffer = c(:);
            obj.cur = numel(c);
            obj.capacity = obj.size;
        else
            obj.buffer = cell(4, 1);
            obj.capacity = 4;
            obj.cur = 0;
        end
    end

    function s = size(obj)
        s = obj.cur;
    end

    function b = isempty(obj)            
        b = (obj.cur == 0);
    end

    function push(obj, elem)
        if obj.cur >= obj.capacity
            obj.buffer(obj.capacity+1:2*obj.capacity) = cell(obj.capacity, 1);
            obj.capacity = 2*obj.capacity;
        end
        obj.cur = obj.cur + 1;
        obj.buffer{obj.cur} = elem;
    end

    function elem = peek(obj)
        if obj.cur == 0
            error('Cannot peek empty stack.');
        end
        elem = obj.buffer{obj.cur};
    end

    function elem = pop(obj)
        if obj.cur == 0
            error('Cannot pop empty stack.');
        end
        elem = obj.buffer{obj.cur};
        obj.cur = obj.cur - 1;
    end

    function c = content(obj)
        c = obj.buffer(1:obj.cur);
    end
end
    
end