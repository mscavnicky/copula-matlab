function [ alphahat, ll ] = archimfit( family, U )
%ARCHIMFIT Fit multivariate archimedean copula to data

fun = @(alpha) loglike(archimpdf( family, U, alpha ));
[ lbnd, ubnd ] = archimbounds( family );
[alphahat, ll] = fminbnd(fun, lbnd, 10);
        
end

