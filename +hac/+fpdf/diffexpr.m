function [ dexpr ] = diffexpr( expr )
%DIFFEXPR Differentiate expression given in a string

fexpr = sym(expr);
vars = symvar(fexpr);
for i=1:numel(vars)
    fexpr = diff(fexpr, vars(i));
    %char(fexpr)
end

dexpr = char(fexpr);

end

