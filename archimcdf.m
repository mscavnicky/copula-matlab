function [ Y ] = archimcdf( family, U, alpha )
%ARCHIMCDF Multivariate CDF for Archimedean copulas.
% 
% TODO: Validate alpha parameter

% Select generator function and its inverse
switch family
    case 'frank'
        gen = @frankgen;
        ginv = @frankinv;
    case 'gumbel'
        gen = @gumbelgen;
        ginv = @gumbelinv;        
    case 'clayton'
        gen  = @claytongen;
        ginv = @claytoninv;
end

% Use archimdean copula definition
Y = gen(sum(ginv(U, alpha), 2), alpha);

end




