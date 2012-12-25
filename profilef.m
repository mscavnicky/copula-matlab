function [ times ] = profilef( fun, n )
%PROFILE Profile function

times = zeros(n, 1);
for i=1:n
    tic();
    fun();
    times(i) = toc();
    fprintf('Time: %f\n', times(i));
end

end

% times = profilef(@()(copula.emp(unifrnd(0, 1, 10000, 5))), 10);
% times = profilef(@()(uniform(normrnd(0, 100, 30000, 5))), 20)


