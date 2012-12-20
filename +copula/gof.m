function [ h, p ] =  gof( family, U, N, method, copulaparams, varargin )
%COPULAGOF Performs goodness-of-fit test given a fitted copula and data.

switch method
case 'snc'
    [h, p] = bootstrap(@snc, N, family, U, copulaparams, varargin{:});
case 'snb'
    [h, p] = bootstrap(@snb, N, family, U, copulaparams, varargin{:});
otherwise
    error('Method %s not recognized', method);
end

end

function [h, p] = bootstrap( gof, N, family, U, copulaparams, varargin )
    [n, d] = size(U);
    % Compute statistics value for original dataset
    t = gof( family, U, copulaparams );
    % Boostraped statistics
    T = zeros(N, 1);
    
    times = zeros(N, 1);
    fprintf('                ');
    for i=1:N
       timeLeft = mean(times(max(1, i-21):i)) * (N+1-i);
       fprintf(1, '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%4d/%4d (%5.1f)', i, N, timeLeft);
       tic();
       % Simulate fitted copula
       V = uniform(copula.rnd(family, n, d, copulaparams));
       % Fit simulated data       
       copulaparams = copula.fit(family, V, varargin{:});       
       % Get another bootstrapped statistics
       T(i) = gof( family, V, copulaparams );
       % Keep duration of this iteratioin
       times(i) = toc();
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
    % Perform Rosenblatt's transformation
    E = copula.pit(family, U, copulaparams);
    % Compute test statistics
    T = copula.snbstat( E );
    
    %t1 = n / 3^d;
    %t2 = sum(prod(1 - E.^2, 2), 1) / 2^(d-1);

    %t3 = 0;
    %for i=1:n
    %   for j=1:n
    %      t3 = t3 + prod(1 - max(E(i,:), E(j,:)), 2);
    %   end
    %end
    %t3 = t3 / n;

    %T = t1 - t2 + t3;

end

