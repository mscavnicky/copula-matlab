function [ l, u ] = archimbounds( family )
%ARCHIMBOUNDS Bounds of parameter of Archimedean copula

switch family
    case 'clayton'
        l = 0;
        u = Inf;
    case 'gumbel'
        l = 1;
        u = Inf;
    case 'frank'
        l = 0;
        u = Inf;
    otherwise
        error 'Unknown copula family'
end
        
end

