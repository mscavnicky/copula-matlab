function [ Y ] = archimcdf( family, U, alpha )
%ARCHIMCDF Multivariate CDF for Archimedean copulas.
Y = archimgen(family, sum(archiminv(family, U, alpha), 2), alpha);
end




