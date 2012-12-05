function [ h, p ] =  gof( family, U, N, method, copulaparams )
%COPULAGOF Performs goodness-of-fit test given a fitted copula and data.

switch method
case 'snc'
    [h, p] = bootstrap(@snc, N, family, U, copulaparams);
case 'snb'
    [h, p] = bootstrap(@snb, N, family, U, copulaparams);
otherwise
    error('Method %s not recognized', method);
end

end

function [h, p] = bootstrap( gof, N, family, U, copulaparams )
    [n, d] = size(U);
    % Compute statistics value for original dataset
    t = gof( family, U, copulaparams );
    % Boostraped statistics
    T = zeros(N, 1);
    for i=1:N       
       % Simulate fitted copula
       V = uniform(copula.rnd(family, n, d, copulaparams));
       % Fit simulated data
       copulaparams = copula.fit(family, V);
       % Get another bootstrapped statistics
       T(i) = gof( family, V, copulaparams ); 
       dbg('%d: %f\n', i, T(i, 1));
    end
    
    p = mean(T > t);
    h = p > 0.05;
end

function [ T ] = snc( family, U, copulaparams )
    % Perform Rosenblatt's transformation
    E = copula.pit(family, U, copulaparams);
    % Compute test statistic
    T = sum((ecopula(E) - prod(E, 2)) .^ 2);
end

function [ T ] = snb( family, U, copulaparams )
    % Size is needed for test statistics computation
    [n, d] = size(U);
    % Perform Rosenblatt's transformation
    E = copula.pit(family, U, copulaparams);
    % Compute test statistics
    t1 = n / 3^d;
    t2 = sum(prod(1 - E.^2, 2), 1) / 2^(d-1);

    t3 = 0;
    for i=1:n
       for j=1:n
          t3 = t3 + prod(1 - max(E(i,:), E(j,:)), 2);
       end
    end
    t3 = t3 / n;

    T = t1 - t2 + t3;

end

