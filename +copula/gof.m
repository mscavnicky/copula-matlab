function [ h, p ] = gof( copulaparams, U, bootstraps, method, showProgress, varargin )
%COPULAGOF Performs goodness-of-fit test given a fitted copula and data.

switch method
case 'snc'
    [h, p] = bootstrap(@snc, bootstraps, U, copulaparams, varargin{:});
case 'snb'
    [h, p] = bootstrap(@snb, bootstraps, U, copulaparams, varargin{:});
otherwise
    error('Method %s not recognized', method);
end

end

function [h, p] = bootstrap( testfn, N, U, copulaparams, varargin )
    family = copulaparams.family;
    [n, d] = size(U);
    % Compute statistics value for original dataset
    t = testfn( family, U, copulaparams );
    % Boostraped statistics
    T = zeros(N, 1);
    
    times = zeros(N, 1);
    
    if showProgress
        fprintf('   0/%4d ( Inf)', N);
    end
    
    i = 1;
    while i <= N
        try            
            tic();
            % Simulate fitted copula
            V = uniform(copula.rnd(family, n, d, copulaparams));
            % Fit simulated data       
            copulaparams = copula.fit(family, V, varargin{:});       
            % Get another bootstrapped statistics
            T(i) = testfn( family, V, copulaparams );
            % Keep duration of this iteratioin
            times(i) = toc();
            % Print estimated time
            if showProgress
                timeLeft = mean(times(max(1, i-21):i)) * (N-i);
                fprintf(1, '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
                fprintf(1, '%4d/%4d (%5.1f)', i, N, timeLeft);
            end
            % Increment iterator
            i = i + 1;            
        catch err
            if ~strcmp(err.identifier, 'hac:fit:invalid')                
                rethrow(err);            
            end
        end
    end
    
    p = mean(T > t);
    h = p > 0.05;
end

function [ T ] = snc( family, U, copulaparams )
    % Perform Rosenblatt's transformation
    E = copula.pit(family, U, copulaparams);
    % Compute test statistic
    T = sum((copula.emp(E) - prod(E, 2)) .^ 2);
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

