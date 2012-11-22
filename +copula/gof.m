function [ h, p ] =  gof( family, U, method, copulaparams )
%COPULAGOF Performs goodness-of-fit test given a fitted copula and data.
%

N = 10;
[n, d] = size(U);

switch method
case 'snc'
    % Compute statistics value for original dataset
    t = snc( family, U, copulaparams );
    % Boostraped statistics
    T = zeros(N, 1);
    for i=1:N
       fprintf('GOF Boostrap %d...\n', i);
       % Simulate fitted copula
       V = uniform(copula.rnd(family, n, d, copulaparams));
       % Fit simulated data
       copulaparams = copula.fit(family, U);
       % Get another bootstrapped statistics
       T(i) = snc( family, V, copulaparams ); 
    end
    
    p = mean(T > t);
    h = p > 0.05;
otherwise
    error('Method %s not recognized', method);
end


end

function [ T ] = snc( family, U, copulaparams )
    % Perform Rosenblatt's transformation
    E = copula.pit(family, U, copulaparams);
    % Compute test statistic
    T = sum((ecopula(E) - prod(E, 2)) .^ 2);
end

