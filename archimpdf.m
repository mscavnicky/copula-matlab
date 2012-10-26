function [ Y ] = archimpdf( family, U, alpha )
%ARCHIMPDF
% McNeil & Neslehova

% Matrix dimension to compute derivative
d = size(U, 2);

% Declare symbols in symbolic expression
syms x p

% Select generator
switch family
    case 'frank'
        g = (-1/p) * log( 1 - ( 1 - exp(-p) ) .* exp(-x) );
    case 'gumbel'
        g = exp( -x ^ (1/p) );       
    case 'clayton'
        g = ( 1 + p*X ) ^ (-1/p);
end

% Differentiate generator dimension times



