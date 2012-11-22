function [ U ] = rnd( family, alpha, n, d )
%RND Random vectors from a copula.
%   
%   References:
%       McNeil

switch family
case 'clayton' 
    V = gamrnd(1/alpha, 1, n, 1);
    X = unifrnd(0, 1, n, d);
    U = archim.gen(family, bsxfun(@rdivide, -log(X), V), alpha);
case 'gumbel'
    V = stablernd(1/alpha, 1, n) * (cos(pi/(2*alpha)))^alpha;
    X = unifrnd(0, 1, n, d);
    U = archim.gen(family, bsxfun(@rdivide, -log(X), V), alpha);
case 'frank'
    % Taken from Polish guys thesis
    gamma = floor(1+log(rand(n,1)) ./ (log(1-exp(-alpha*rand(n,1)))));
    U = -log(1-exp(log(rand(n,d))./(gamma*ones(1,d)))*(1-exp(-alpha)))/alpha;
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

