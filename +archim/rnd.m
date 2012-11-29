function [ U ] = rnd( family, alpha, n, d )
%RND Random vectors from a copula.
%   
%   References:
%       McNeil

% Special method
%X = unifrnd(0, 1, n, d);
%copulaparams.alpha = alpha;
%U = copula.pit( family, X, copulaparams );
%return;

switch family
case 'clayton' 
    V = gamrnd(1/alpha, 1, n, 1);
    X = unifrnd(0, 1, n, d);
    U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);
case 'gumbel'
    V = stablernd(1/alpha, 1, n) * (cos(pi/(2*alpha)))^alpha;
    %V = stblrnd(1/alpha, 1, cos(pi/(2*alpha))^alpha, 0, n, 1);
    X = unifrnd(0, 1, n, d);
    U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);
    %V = rand(n,1)*pi-pi/2;
    %W = -log(rand(n,1));
    %T = V + pi/2;
    %gamma = sin(T/alpha).^(1/alpha).*cos(V).^(-1).*((cos(V-T/alpha))./W).^(1-1/alpha);
    %U = exp( - (-log(rand(n,d))).^(1/alpha)./(gamma*ones(1,d))  );
case 'frank'
    % Log-series sampling taken from polish guys thesis
    V = floor(1+log(rand(n,1)) ./ log(1-exp(-alpha*rand(n,1))));
    X = unifrnd(0, 1, n,d);   
    U = archim.gen(family, -log(X) ./ repmat(V, 1, d), alpha);
otherwise
    error('Copula family %s not recognized.', family);    
end

end

function [ X ] = stablernd(alpha, beta, n)
t0 = atan(beta*tan((pi * alpha)/2))/alpha;
Theta = pi * (unifrnd(0, 1, n, 1) - 0.5);
W = -log(unifrnd(0, 1, n, 1));
term1 = sin(alpha*(t0+Theta))./(cos(alpha*t0)*cos(Theta)).^(1/alpha);
term2 = ((cos(alpha*t0+(alpha-1)*Theta))./W).^((1-alpha)/alpha);
X = term1.*term2;
end

