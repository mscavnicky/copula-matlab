function [ postexpr ] = in2post( inexpr )
%IN2POST Convert infix expression to postfix expression
%
%   http://www.lawrence.edu/fast/greggj/CMSC270/Infix.html
%   http://scriptasylum.com/tutorials/infix_postfix/algorithms/infix-postfix/index.htm

%#ok<*AGROW>

% Map of operator precendence
pr = containers.Map({'+', '-', '*', '/'}, {1, 1, 3, 3});

% Extract tokens from infix expression
operands = regexp(inexpr, '\+|\*', 'split');
operators = regexp(inexpr, '\+|\*', 'match');

assert(numel(operands) == numel(operators) + 1);

tokens = {operands{1}};
for i=1:numel(operators)
   tokens{end+1} = operators{i}; 
   tokens{end+1} = operands{i+1};
end

% Convert tokens to postfix expression
stack = {};
len = 0;

postexpr = {};

for i=1:numel(tokens)
    token = tokens(i);
    % Unwrap token from cell array
    token = token{1};
    if isKey(pr, token)
        if len == 0
           len = len + 1;
           stack{len} =  token;
        else
            if pr(token) > pr(stack{len})
                len = len + 1;
                stack{len} = token;
            else
                while (len > 0) && (pr(token) <= pr(stack{len}))
                    postexpr{end+1} = stack{len};
                    len = len - 1;             
                end
                len = len + 1;
                stack{len} = token;
            end
        end
    else
        postexpr{end+1} = token;
    end   
end

% Put the rest of the stack to the output
while len > 0
   postexpr{end+1} = stack{len};
   len = len - 1;
end

end


