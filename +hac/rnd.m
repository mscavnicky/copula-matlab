function [ U ] = rnd( family, tree, n )
%RND Sample hierarchical archimedean copula

% Dimensions of top-level copula in hac structure
d = length(tree) - 1;
% Find alpha on this level
alpha = tree{end};
% Compute laplace transformation
V0 = archim.lsinvrnd(family, alpha, n);
% Matrix for the random variates on this level
U = [];
for i=1:d
    if iscell(tree{i})
        U = [U, rndinner(family, tree{i}, alpha, V0, n)];
    else
        X = rand(n, 1);
        U = [U, archim.gen(family, -log(X) ./ V0, alpha)]; 
    end
end

end

function [ U ] = rndinner( family, tree, alpha0, V0, n )
% Dimensions of top-level copula in hac structure
d = length(tree) - 1;
% Find alpha on this level
alpha1 = tree{end};
% Sample laplace transformation
V01 = sampleLaplace(family, V0, alpha0, alpha1);
% Matrix for the random variates on this level
U = [];
for i=1:d
    if iscell(tree{i})
        U = [U, rndinner(family, tree{i}, alpha1, V01, n)];
    else
        X = rand(n, 1);
        U = [U, archim.gen(family, -log(X) ./ V01, alpha1)]; 
    end
end

end

function [ V01 ] = sampleLaplace( family, V0, theta0, theta1 )
%SAMPLELAPLACE Sample laplace transform for given copula family.

%fprintf('%f, %f\n', theta0, theta1);

n = length(V0);
alpha = theta0 / theta1;

switch family
case 'clayton'
    M = findOptimumM(V0);
    gamma = (cos(alpha * pi / 2) .* V0 ./ M).^(1/alpha);
    
    V01 = zeros(n, 1); 
    for i=1:n
       for j=1:M(i)
           v = 0;
           while true
              x = stblrnd(alpha, 1, gamma(i), 0, 1);
              if (rand() <= exp(-x))
                  v = v + x;
                  break;
              end
           end
           V01(i) = v;
       end
    end
    
case 'gumbel'
    gamma = (cos(alpha * pi / 2) .* V0) .^ (1/alpha);
    delta = V0 .* (alpha == 1);
    V01 = arrayfun(@(i) stblrnd(alpha, 1, gamma(i), delta(i), 1), (1:n)');
case 'frank'
    % Log-Series distribution parameter
    c1 = 1 - exp(-theta1);
    % Preallocation of return vector
    V01 = zeros(n, 1);
    
    for i=1:n    
         if abs(theta0) < 1
             for j=1:V0(i)
                 v = 0;
                 while true
                     u = rand();
                     x = logrnd(c1, 1);
                     if u <= 1/((x-alpha)*beta(x, 1-alpha))
                         v = v + x;
                         break;
                     end
                 end
             end
             V01(i) = v;
         else
            while true
                u = rand();
                x = sum(sibuyarnd(alpha, V0(i)));
                if u <= c1^(x-1)
                   V01(i) = x;
                   break;
                end 
            end
        end
    end
case 'joe'
    V01 = zeros(n, 1);
    for i=1:n
       V01(i) = sum(sibuyarnd(alpha, V0(i)));
    end
end

end

function [ M ] = findOptimumM( V0 )

floorV = floor(V0);
ceilV = ceil(V0);
v1 = floorV .* exp(V0 ./ floorV);
v2 = ceilV .* exp(V0 ./ ceilV);

M = zeros(length(V0), 1);
M(V0 <= 1) = 1;
M(V0 > 1 & v1 <= v2) = floorV(V0 > 1 & v1 <= v2);
M(V0 > 1 & v1 > v2) = ceilV(V0 > 1 & v1 > v2);

end

