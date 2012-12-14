function [ U ] = rnd( family, tree, n )
%RND Sample hierarchical archimedean copula
alpha = tree{end};
V0 = archim.lsinvrnd(family, alpha, n);
U = rndinner(family, tree, alpha, V0, n);
end

function [ U ] = rndinner( family, tree, alpha0, V0, n )
% Dimensions of top-level copula in hac structure
d = length(tree) - 1;
% Find alpha on this level
alpha1 = tree{end};
% Compute laplace transformation
V01 = laplace1(family, V0, alpha0, alpha1);
% Matrix for the random variates on this level
U = [];
for i=1:d
    if iscell(tree{i})
        U = [U, rndinner(family, tree{i}, alpha1, V01, n)];
    else
        U = [U, archim.gen(family, -log(X) ./ repmat(V01, 1, d), alpha1)]; 
    end
end

end

function [ V01 ] = laplace1( family, V0, theta0, theta1 )

n = length(V0);
alpha = theta0 / theta1;

switch family
case 'clayton'
    M = findOptimumM(V0);
    gamma = (cos(alpha * pi / 2) .* V0 ./ M)^(1/alpha);
    
    V01 = zeros(n, 1);    
    for i=1:n
       while true
          v = stblrnd(alpha, 1, gamma(i), 0);
          if (rand() <= exp(-v))
              V01(i) = v;
              break;
          end
       end
    end
    
case 'gumbel'
    gamma = (cos(alpha * pi / 2) .* V0)^(1/alpha);
    delta = V0 .* (alpha == 1);
    V01 = arrayfun(@(i) stablernd(alpha, 1, gamma(i), delta(i)), 1:n);
case 'frank'
    % Log-Series distribution parameter
    c1 = 1 - exp(-theta1);
    % Preallocation of return vector
    V01 = zeros(n, 1);
    
    for i=1:n    
        if abs(theta0) < 1
            while true
                U = rand();
                X = logrnd(c1);
                if U < 1/((X-alpha)*beta(X, 1-alpha))
                    V01(i) = X;
                    break;
                end
            end
        else
            while true
                U = rand();
                X = sibuyarnd(alpha, 1);
                if U <= c1^(X-1)
                   V01(i) = X;
                   break;
                end                
            end
        end
    end
end

end

function [ M ] = findOptimumM( V0 )

floorV = floor(V0);
ceilV = ceil(V0);
v1 = floorV * exp(V0 / floorV);
v2 = ceilV * exp(V0 / ceilV);

M = zeros(length(V0));
M(V0 <= 1) = 1;
M(V0 > 1 & v1 <= v2) = floorV(V0 > 1 & v1 <= v2);
M(V0 > 1 & v1 > v2) = ceilV(V0 > 1 & v1 > v2);

end

