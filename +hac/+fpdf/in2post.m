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

% Unnest tokens array
tokens = [tokens{:}];

% Convert tokens to postfix expression
stack = {};
ssize = 0;

postexpr = {};

for i=1:numel(tokens)
    token = tokens(i);
    if isKey(pr, token)
        if ssize == 0
           ssize = ssize + 1;
           stack{ssize} =  token;
        else
            if pr(token) > pr(stack{ssize})
                ssize = ssize + 1;
                stack{ssize} = token;
            else
                while (ssize > 0) && (pr(token) <= pr(stack{ssize}))
                    postexpr{end+1} = stack{ssize};
                    ssize = ssize - 1;             
                end
                ssize = ssize + 1;
                stack{ssize} = token;
            end
        end
    else
        postexpr{end+1} = token;
    end   
end

% Put the rest of the stack to the output
for i=1:ssize
   postexpr{end+1} = stack{i}; 
end


postexpr = strjoin(postexpr);

end


