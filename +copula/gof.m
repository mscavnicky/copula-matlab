function [ h, p ] = gof( copulaparams, U, bootstraps, method, showProgress, varargin )
%COPULAGOF Performs goodness-of-fit test given a fitted copula and data.

switch method
case 'snc'
    [h, p] = bootstrap(@copula.snc, bootstraps, U, copulaparams, showProgress, varargin{:});
case 'snb'
    [h, p] = bootstrap(@copula.snb, bootstraps, U, copulaparams, showProgress, varargin{:});
otherwise
    error('Method %s not recognized', method);
end

end

function [h, p] = bootstrap( stat, N, U, copulaparams, showProgress, varargin )
    [n, d] = size(U);
    % Perform Rosenblatt's transform on uniform variates
    E = copula.pit( copulaparams, U );    
    % Compute statistics value for the original dataset
    t = stat( E );
    % Boostraped statistics
    T = zeros(N, 1);
    
    times = zeros(N, 1);
    
    if showProgress
        fprintf('%4d/%4d (%7.1f)', 0, N, Inf);
    end
    
    i = 1;
    while i <= N
        tic();
        % Simulate fitted copula
        V = uniform(copula.rnd(copulaparams, n, d));
        % Fit simulated data       
        fitparams = copula.fit(copulaparams.family, V, varargin{:});
        % Compute Rosenblatt's transform of the fitted param
        E = copula.pit(fitparams, V);
        % Compute statistics of this bootstrap
        T(i) = stat(E);
        % Keep duration of this iteratioin
        times(i) = toc();
        % Print estimated time
        if showProgress
            timeLeft = mean(times(max(1, i-21):i)) * (N-i);
            fprintf(1, '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
            fprintf(1, '%4d/%4d (%7.1f)', i, N, timeLeft);
        end
        % Increment iterator
        i = i + 1;            
    end   
       
    p = mean(T > t);
    h = p > 0.05;
end

