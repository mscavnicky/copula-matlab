function [y errors] = polylog(n,z) 
%% polylog - Computes the n-based polylogarithm of z: Li_n(z)
% Approximate closed form expressions for the Polylogarithm aka de 
% Jonquiere's function are used. Computes reasonably faster than direct
% calculation given by SUM_{k=1 to Inf}[z^k / k^n] = z + z^2/2^n + ...
%
% Usage:   [y errors] = PolyLog(n,z)
%
% Input:   z < 1   : real/complex number or array
%          n > -4  : base of polylogarithm 
%
% Output: y       ... value of polylogarithm
%         errors  ... number of errors 
%
% Approximation should be correct up to at least 5 digits for |z| > 0.55
% and on the order of 10 digits for |z| <= 0.55!
%
% Please Note: z vector input is possible but not recommended as precision
% might drop for big ranged z inputs (unresolved Matlab issue unknown to 
% the author). 
%
% following V. Bhagat, et al., On the evaluation of generalized
% Bose–Einstein and Fermi–Dirac integrals, Computer Physics Communications,
% Vol. 155, p.7, 2003
%
% v3 20120616
% -------------------------------------------------------------------------
% Copyright (c) 2012, Maximilian Kuhnert
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:  
% 
%     Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer. 
%     Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.  
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.          
% -------------------------------------------------------------------------

if nargin~=2
    errors=1;
    error('[Error in: polylog function] Inappropriate number of input arguments!')
end

if (isreal(z) && sum(z(:)>=1)>0) % check that real z is not bigger than 1 
    errors=1;
    error('[Error in: polylog function] |z| > 1 is not allowed')
elseif isreal(z)~=1 && sum(abs(z(:))>1)>0 % check that imaginary z is defined on unit circle
    errors=1;
    error('[Error in: polylog function] |z| > 1 is not allowed')
elseif n<=-4 % check that n is not too largly negative (see paper)
    errors=1;
    error('[Error in: polylog function] n < -4 might be inaccurate')
end

% display more digits in Matlab terminal:
%format long

alpha = -log(z); % see page 12

% if |z| > 0.55 use Eq. (27) else use Eq. (21):
if abs(z) > 0.55
    preterm = gamma(1-n)./alpha.^(1-n);
    nominator = b(0) + ...
        - alpha.*( b(1) - 4*b(0)*b(4)/7/b(3) ) + ...
        + alpha.^2.*( b(2)/2 + b(0)*b(4)/7/b(2) - 4*b(1)*b(4)/7/b(3) ) + ...
        - alpha.^3.*( b(3)/6 - 2*b(0)*b(4)/105/b(1) + b(1)*b(4)/7/b(2) - 2*b(2)*b(4)/7/b(3) );
    denominator = 1 + alpha.*4*b(4)/7/b(3) +...
        + alpha.^2.*b(4)/7/b(2) +...
        + alpha.^3.*2*b(4)/105/b(1) +...
        + alpha.^4.*b(4)/840/b(0);
    y = preterm + nominator ./ denominator;
else
    nominator = 6435*9^n.*S(n,z,8) - 27456*8^n*z.*S(n,z,7) + ...
        + 48048*7^n*z.^2.*S(n,z,6) - 44352*6^n*z.^3.*S(n,z,5) + ...
        + 23100*5^n*z.^4.*S(n,z,4) - 6720*4^n.*z.^5.*S(n,z,3) + ...
        + 1008*3^n*z.^6.*S(n,z,2) - 64*2^n*z.^7.*S(n,z,1);
    denominator = 6435*9^n - 27456*8^n*z + ...
        + 48048*7^n*z.^2 - 44352*6^n*z.^3 + ...
        + 23100*5^n*z.^4 - 6720*4^n*z.^5 + ...
        + 1008*3^n*z.^6 - 64*2^n*z.^7 + ...
        + z.^8;
    y = nominator ./ denominator;
end

% define b:
    function out = b(i)
        out = zeta(n-i);
    end
% define S as partial sums of Eq. 12:
    function out = S(n,z,j)
        out =0;
        for i=1:j
            out = out + z.^i./i^n;
        end
    end
    function [out] = zeta(x)
        %% Zeta Function  
        % Eq. 18
        % following V. Bhagat, et al., On the evaluation of generalized
        % Bose–Einstein and Fermi–Dirac integrals, Computer Physics Communications,
        % Vol. 155, p.7, 2003
        %
        % Usage: [out] = zeta(x)
        % with argument x and summation from 1 to j
        %
        % MK 20120615

        prefactor = 2^(x-1) / ( 2^(x-1)-1 );
        numerator = 1 + 36*2^x*eta(x,2) + 315*3^x*eta(x,3) + 1120*4^x*eta(x,4) +...
            + 1890*5^x*eta(x,5) + 1512*6^x*eta(x,6) + 462*7^x*eta(x,7);
        denominator = 1 + 36*2^x + 315*3^x + 1120*4^x + 1890*5^x + 1512*6^x +...
            + 462*7^x;
        out = prefactor * numerator / denominator;

        function [out] = eta(x,j)
            %% Eta Function  
            % Eq. 17 (partial sums)
            % following V. Bhagat, et al., On the evaluation of generalized
            % Bose–Einstein and Fermi–Dirac integrals, Computer Physics Communications,
            % Vol. 155, p.7, 2003
            %
            % Usage: [out] = eta(x,j)
            % with argument x and summation from 1 to j
            %
            % MK 20120615
            
            out=0;
            for k=1:j
                out = out + (-1)^(k+1) ./ k.^x;
            end
        end
    end
end