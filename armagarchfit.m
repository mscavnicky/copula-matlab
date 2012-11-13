function [ coeff, errors, LLF, innovations, sigmas, summary ] = armagarchfit( x, p, q, gp, gq )
%ARMAGARCHFIT Fits ARMA/GARCH to a given series

spec = garchset('R',p,'M',q,'C',NaN,'Display','Off');
spec = garchset(spec, 'P', gp, 'Q', gq, 'VarianceModel','GARCH');
[coeff, errors, LLF, innovations, sigmas, summary] = garchfit(spec, x);
%[aic, bic] = aicbic( LLF, garchcount(coeff), size(x, 1) );
%autocorr((innovations./sigmas).^2);

end

