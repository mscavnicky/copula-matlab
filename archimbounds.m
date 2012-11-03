function [ l, u ] = archimbounds( family )
%ARCHIMBOUNDS Bounds of parameters of Archimedean copula.
%   http://support.sas.com/documentation/cdl/en/etsug/63939/HTML/default/viewer.htm#etsug_copula_sect017.htm

switch family
    case 'clayton'
        l = 0;
        u = Inf;
    case 'gumbel'
        l = 1;
        u = Inf;
    case 'frank'
        % Note that bounds for Frank copula exclude zero
        l = -Inf;
        u = Inf;
    otherwise
        error 'Copula family not recognized'
end
        
end

