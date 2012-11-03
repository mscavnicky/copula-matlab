function [ Y ] = archimcdf( family, U, alpha )
%ARCHIMCDF CDF of multivariate Archimedean copulas.
Y = archimgen(family, sum(archiminv(family, U, alpha), 2), alpha);`
end




